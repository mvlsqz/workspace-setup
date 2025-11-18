# Cloud SQL DMS Migration Playbook

**Custom Action Plugins & Automated Database Migration**

---

Good [morning/afternoon] everyone. Today I'm going to walk you through our automated Cloud SQL migration solution using Google's Database Migration Service, or DMS. What makes this automation particularly powerful is that we've developed **five custom Ansible action plugins** specifically for DMS workflows – these plugins extend Ansible's capabilities to interact directly with Google Cloud's Database Migration Service and Cloud SQL Admin APIs.

This automation runs entirely within a Docker container, providing a consistent, reproducible execution environment. The entry point is a simple Makefile command that orchestrates what we call a "live migration" – moving production MySQL databases between Cloud SQL instances with minimal downtime, typically just 5-10 seconds.

Let me show you how the custom tooling we built makes this complex process safe and repeatable.

---

## Architecture Overview (2 minutes)

When you execute a DMS migration, you're running commands like this:

```bash
make run promotion setup
make run promotion monitor
make run promotion promote
make run promotion reverse-replication
```

### Custom Action Plugins

**1. dms_action** – Controls DMS migration jobs (describe, promote, start)
**2. cloud_sql_action** – Manages Cloud SQL instance operations (describe, demote, promote)
**3. gcloud_dms_logging_read** – Queries GCP Cloud Logging for DMS errors
**4. gcp_access_token** – Retrieves OAuth access tokens for direct API calls
**5. cloud_sql_operations** – Lists and filters Cloud SQL operations by status

---

## Custom Action Plugins Deep Dive (2.5 minutes)

### 1. dms_action.py (52 lines)

This is the workhorse for DMS operations. It accepts an `action` parameter – describe, promote, or start – along with job_id, project, and region. It constructs commands like:

```bash
gcloud database-migration migration-jobs describe <job_id> \
  --project <project> --region <region> --format=json
```

This plugin is used throughout monitoring and promotion phases to query job status and execute the actual promotion.

### 2. cloud_sql_action.py (49 lines)

Manages Cloud SQL instance lifecycle operations. It wraps `gcloud sql instances` commands with dynamic actions like describe, promote, or demote. The playbook uses this during setup to demote the destination to READ_REPLICA mode, and during promotion to change instance roles. The plugin captures JSON output and makes it available to Ansible facts.

### 3. gcloud_dms_logging_read.py (50 lines)

Specialized for error detection. It queries GCP Cloud Logging with a constructed resource filter:

```bash
gcloud logging read \
  'resource.type="datamigration.googleapis.com/MigrationJob" \
   AND resource.labels.migration_job_id="<job_id>" \
   AND severity>=ERROR' \
  --limit=5 --format=json --project <project>
```

This runs during every monitoring phase to surface replication errors immediately, rather than requiring manual log inspection in the GCP console.

### 4. gcp_access_token.py (48 lines)

A simple but critical plugin. It runs `gcloud auth print-access-token` to retrieve the current OAuth access token. This token is used in the reverse-replication phase for direct REST API calls to Cloud SQL Admin API endpoints that aren't wrapped by standard Ansible modules. Without this, we'd need to manage service account keys manually.

### 5. cloud_sql_operations.py (51 lines)

Lists Cloud SQL operations filtered by status. It's used during setup to verify that instance demotion operations complete successfully, filtering for DONE status to ensure state transitions finish before proceeding.

### Plugin Pattern

All five plugins follow the same pattern: they extend `ActionBase`, validate required arguments, construct gcloud commands, execute them via subprocess, and handle errors gracefully with structured output. They're located in the **action_plugins/** directory, which Ansible automatically loads when the playbook runs.

---

## Phase 1: Setup (2.5 minutes)

When you run **`make run promotion setup`**, the playbook executes **seven critical tasks** from dms.yaml, leveraging our custom plugins:

### Task Sequence

**First**, it discovers both Cloud SQL instances using the standard Google Cloud Ansible collection, then sets facts for source and destination instance data.

**Second**, it creates CA certificates by extracting SSL certificates from both instances and writing them to temporary files.

**Third**, **dms-required-users.yaml** creates dedicated replication users on both instances with minimal required privileges.

**Fourth**, **dms-replicate-users.yaml** copies all application user accounts from source to destination to ensure post-promotion connectivity.

**Fifth**, **dms-configuration-checks.yaml** validates binlog configuration. If binlog_format isn't ROW, the playbook fails immediately before creating invalid DMS jobs.

### Sixth: DMS Job Provisioning (Using Custom Plugins)

This is where our custom plugins really shine. **dms-job-resources.yaml** provisions the DMS infrastructure:

1. Generates Terraform configuration and applies it to create the DMS job
2. Uses **cloud_sql_action** plugin with `action: describe` to check the destination's current instance type
3. Uses **cloud_sql_action** plugin with `action: demote` to demote the destination to READ_REPLICA
4. Uses **cloud_sql_operations** plugin in a retry loop to wait for the demotion operation to reach DONE status – up to 120 retries at 60-second intervals
5. Uses **dms_action** plugin with `action: start` to initiate the DMS job

The combination of Terraform for resource provisioning and our custom gcloud wrapper plugins for instance management provides a powerful, declarative workflow.

### Expected Duration

**Setup tasks**: 5-10 minutes
**FULL_DUMP phase**: Hours (depends on database size)

---

## Phase 2: Monitor (2.5 minutes)

The monitoring phase showcases our **dms_action** and **gcloud_dms_logging_read** plugins working together.

When you run **`make run promotion monitor`**, the playbook in **dms-monitoring.yaml** executes:

### Step 1: Retrieve Job Status

Calls **dms_action** plugin with `action: describe` to retrieve the current job status:

```yaml
dms_action:
  action: describe
  job_id: "{{ source_instance_name }}-to-{{ destination_instance_name }}"
  project: "{{ gcp_project }}"
  region: "{{ region }}"
register: job_status_raw
```

The plugin returns JSON output which the playbook parses to extract the job's state and phase. This includes a retry loop – 30 attempts with 30-second delays – to handle transient API failures or jobs that are transitioning between states.

### Step 2: Check for Errors

Calls **gcloud_dms_logging_read** plugin to check for errors:

```yaml
gcloud_dms_logging_read:
  log_level: ERROR
  job_id: "{{ source_instance_name }}-to-{{ destination_instance_name }}"
  project: "{{ gcp_project }}"
register: error_logs
```

This plugin constructs a specific Cloud Logging query filtered by the DMS job resource and ERROR severity. It returns up to 5 recent error messages. If the list is empty, the job is healthy.

### Step 3: Determine Sync Readiness

The playbook determines sync readiness by checking: `job_status.phase == 'CDC'` AND `error_logs == []`. When both conditions are true, you see **"IN SYNC - Ready for promotion."**

### Job Phases

| Phase       | Description                            | Duration | Ready for Promotion? |
| ----------- | -------------------------------------- | -------- | -------------------- |
| `CREATING`  | DMS job initializing                   | 1-2 min  | ❌ No                |
| `FULL_DUMP` | Initial data copy in progress          | Hours\*  | ❌ No                |
| `CDC`       | Change Data Capture (binlog streaming) | Ongoing  | ✅ Yes               |
| `COMPLETED` | Job finished (after promotion)         | N/A      | N/A                  |

\*Duration depends on database size

### Plugin Benefits

The beauty of these custom plugins is that they encapsulate complex gcloud commands with proper error handling and structured output. The playbook logic remains clean and readable.

---

## Phase 3: Promotion (2.5 minutes)

The Promotion phase uses **dms_action** plugin for the critical cutover operation.

When you run **`make run promotion promote`**, the playbook in **promote-destination.yaml** first re-runs the monitoring task to get current job status, then performs validation:

### Pre-Flight Validation

```yaml
- name: "PROMOTE: Verify DMS is in CDC phase"
  assert:
    that:
      - job_status.phase == 'CDC'
    fail_msg: "Must be in CDC phase. Current: {{ job_status.phase }}"
```

### Manual Confirmation

After manual confirmation where you type **PROMOTE**, the playbook executes the critical promotion:

```yaml
- name: "PROMOTE: Execute promotion"
  dms_action:
    action: promote
    job_id: "{{ source_instance_name }}-to-{{ destination_instance_name }}"
    project: "{{ gcp_project }}"
    region: "{{ region }}"
```

### What the Plugin Does

The **dms_action** plugin constructs and executes:

```bash
gcloud database-migration migration-jobs promote <job_id> \
  --project <project> --region <region> --format=json
```

This single command triggers the DMS service to stop CDC replication, apply final binlog transactions, promote destination to READ_WRITE, and demote source to READ_ONLY – all in about 5-10 seconds.

### Error Handling

The plugin captures the command output, checks the return code, and reports success or failure back to Ansible. If the gcloud command fails, the plugin catches the `CalledProcessError`, extracts stdout/stderr, and returns a structured error to the playbook.

### Promotion Timeline

```
T+0s  │ User types PROMOTE and presses Enter
T+1s  │ DMS stops accepting new writes to source
T+2s  │ Final binlog events are applied to destination
T+5s  │ Destination promoted to READ_WRITE
T+6s  │ Source demoted to READ_ONLY
T+6s  │ Promotion complete
```

**Expected Downtime**: 5-10 seconds

---

## Phase 4: Reverse Replication (2 minutes)

The reverse-replication phase uses **gcp_access_token** plugin for direct API authentication.

When you run **`make run promotion reverse-replication`**, the playbook in **reverse-replication.yaml** first retrieves an access token:

### Step 1: Obtain Access Token

```yaml
- name: "R-REPLICATION: Get GCP access token"
  gcp_access_token:
  register: gcp_token_result
```

The **gcp_access_token** plugin runs `gcloud auth print-access-token` and returns the OAuth token. This token is then used in subsequent `ansible.builtin.uri` tasks that make direct HTTPS calls to Cloud SQL Admin API endpoints.

### Step 2: Create External Master Representation

The playbook creates an external master representation and demotes the source instance using REST API calls with the token in the Authorization header:

```yaml
uri:
  url: "https://sqladmin.googleapis.com/sql/v1beta4/..."
  method: POST
  headers:
    Authorization: "Bearer {{ gcp_token_result.access_token }}"
```

### Why Use the Token Plugin?

Why use the token plugin instead of gcloud commands? Because the `demoteMaster` API endpoint isn't wrapped by a gcloud command – it requires direct API access. Our plugin bridges this gap.

### Step 3: Verify Replication

After demotion completes, the source instance automatically configures itself as a replica of the destination, establishing the rollback safety net.

Verification via SQL:

```sql
-- On source instance (mysql-prod-01)
SHOW SLAVE STATUS\G

-- Look for:
-- Slave_IO_Running: Yes
-- Slave_SQL_Running: Yes
-- Seconds_Behind_Master: 0
-- Master_Host: <destination-instance-ip>
```

### Rollback Capability

With reverse replication in place, rollback takes just 2-5 minutes:

1. Stop application writes to destination
2. Wait for source to catch up (Seconds_Behind_Master = 0)
3. Promote source back to primary
4. Update application connection strings

**Best Practice**: Keep reverse replication running for **7+ days** after migration.

---

## Custom Plugin Benefits (1 minute)

Why did we build custom action plugins instead of using shell commands or the uri module directly?

### 1. Abstraction and Reusability

Each plugin encapsulates the logic for constructing gcloud commands with proper argument validation. You call `dms_action: action=promote` instead of writing shell commands with string concatenation.

### 2. Structured Error Handling

Every plugin captures stdout, stderr, and return codes. If a gcloud command fails, the plugin returns a structured error message that Ansible can process and display clearly.

### 3. Idempotency and Safety

The plugins validate required parameters before execution. Missing a required field like `job_id` or `project` results in a clear error message before any gcloud command runs.

### 4. JSON Parsing

All plugins request JSON output from gcloud and return it as structured data. The playbook can parse job status, instance state, and error logs without text manipulation.

### 5. Controller-Side Execution

As action plugins, they run on the Ansible controller (localhost inside the container), not on target hosts. This is perfect for DMS workflows that don't involve SSH connections.

### Plugin Statistics

These five plugins – totaling about **250 lines of Python** – provide a robust interface between Ansible and Google Cloud's Database Migration Service that didn't exist before we built them.

---

## Safety Features & Error Handling (1 minute)

Throughout all phases, the custom plugins enable safety mechanisms:

### Plugin-Enabled Safety Features

**Parameter validation** in every plugin prevents typos or missing arguments from executing invalid commands.

**Structured output** allows assertions to check job phase, instance state, and error logs programmatically.

**Retry capabilities** in the monitoring plugin handle transient API failures gracefully.

**Manual confirmation** works because plugins run in the containerized environment with interactive terminal support.

### Built-in Safeguards

**Pre-flight checks** in setup validate binlog configuration and instance states. If checks fail, setup halts before creating invalid resources.

**Phase assertions** prevent out-of-order execution. You can't promote unless you're in CDC phase.

**Retry logic** handles transient failures:

- Job status checks: 30 retries × 30 seconds = 15 minutes
- Instance demotion: 120 retries × 60 seconds = 2 hours

**Error logging** surfaces issues immediately via the **gcloud_dms_logging_read** plugin.

---

## Real-World Example (1.5 minutes)

Real-world timeline using our custom tooling to migrate `mysql-prod-v1` to `mysql-prod-v2`:

### Day 1

**10:00 AM** - Setup Phase

```bash
make run promotion setup
```

- **dms_action** starts job
- **cloud_sql_action** demotes destination
- **cloud_sql_operations** verifies completion
- **Duration**: 10 minutes
- **Result**: DMS job created, FULL_DUMP starts

**10:15 AM** - First Monitor Check

```bash
make run promotion monitor
```

- **dms_action** reports State=RUNNING, Phase=FULL_DUMP
- **gcloud_dms_logging_read** finds no errors
- **Action**: Wait for FULL_DUMP to complete

**2:00 PM** - Second Monitor Check

```bash
make run promotion monitor
```

- **dms_action** reports Phase=CDC (4-hour FULL_DUMP completed)
- **gcloud_dms_logging_read** confirms no errors
- **Result**: Ready for CDC stabilization

**4:00 PM** - Third Monitor Check

```bash
make run promotion monitor
```

- **Output**: IN SYNC - Ready for promotion
- **Action**: Let CDC run overnight for confidence

### Day 2

**8:00 AM** - Pre-Cutover Check

```bash
make run promotion monitor
```

- **Output**: Still IN SYNC (24 hours of CDC stability)
- **Decision**: Proceed with promotion

**8:30 AM** - CUTOVER (Low-Traffic Window)

```bash
make run promotion promote
```

- Manual confirmation prompt appears
- **Type**: PROMOTE
- **dms_action** executes promotion
- **Duration**: ~10 seconds downtime
- **Result**: Destination is now primary

**8:35 AM** - Application Update

- Update connection strings to mysql-prod-v2
- Restart application servers

**8:45 AM** - Establish Failback

```bash
make run promotion reverse-replication
```

- **gcp_access_token** retrieves OAuth token
- Creates external master representation via API
- Demotes source instance via API
- **Duration**: ~5 minutes
- **Result**: Old instance now replicating from new instance
- **Safety**: Can rollback if issues found

**5:00 PM** - Post-Migration Monitoring

- Verify source is in sync (Seconds_Behind_Master=0)
- Monitor application performance
- Check for any errors

### Day 3+

- Keep reverse replication running for 7 days
- If all stable, decommission old instance
- Run `make clean` to remove Terraform state

### Migration Summary

| Metric                   | Value                                   |
| ------------------------ | --------------------------------------- |
| **Total Downtime**       | 5-10 seconds                            |
| **Total Migration Time** | ~24 hours (with CDC stabilization)      |
| **Human Interaction**    | 7 make commands + 1 manual confirmation |
| **Custom Plugin Calls**  | ~15-20 across all phases                |

---

## Containerized Execution (1 minute)

### Docker & Volume Mounts

The Makefile's `run` target executes:

```bash
sudo docker build --build-arg REGISTRY="${DOCKER_REGISTRY}" \
  --progress=quiet . -t ansible-runner > /dev/null

sudo docker run -it \
  -v "${PWD}/iac/:/migration/iac" \
  -v "${PWD}/gcloud/:/home/xoom/.config/gcloud" \
  --rm ansible-runner \
  group_vars/promotion.yaml setup
```

### Volume Mount Purposes

**iac/ directory mount** – Persists Terraform state between container runs. Critical because setup creates DMS job state, and monitor/promote read that state.

**gcloud/ directory mount** – Provides container access to your local Google Cloud credentials. The entrypoint runs `gcloud auth login` to refresh your session.

### Execution Benefits

**Dependency isolation** – Container includes specific versions of Ansible, Terraform, Google Cloud SDK, and Python libraries. No local installation needed.

**Stateful execution** – Terraform state persists in iac/. Each container run has access to previous state.

**Credential management** – gcloud credentials mounted from your local system. No need to manage service account keys.

**Cleanup capability** – `make clean` removes iac/ directory and recreates it with proper permissions (ownership 999:999 for xoom user).

**Auditability** – GCP Cloud Audit Logs capture all operations. Container image tag provides versioned, immutable execution environment.

---

## Closing (30 seconds)

This DMS automation demonstrates how custom Ansible plugins can extend infrastructure-as-code capabilities to integrate with cloud-native services. The five plugins we built – **dms_action**, **cloud_sql_action**, **gcloud_dms_logging_read**, **gcp_access_token**, and **cloud_sql_operations** – transform Google Cloud's gcloud CLI into declarative, reusable Ansible tasks.

### Key Achievements

✅ **5 custom action plugins** (~250 lines of Python)
✅ **4-phase workflow** (setup, monitor, promote, reverse-replication)
✅ **5-10 seconds downtime** during promotion
✅ **Fully containerized** execution environment
✅ **Persistent state** via volume mounts
✅ **Built-in safety** through validation and manual confirmations

The combination of containerized execution, persistent Terraform state, and purpose-built plugins creates a migration workflow that's safe, auditable, and repeatable.

---

## Questions?

I'm happy to take questions about:

- The custom action plugins and their implementation
- The DMS workflow phases and task execution
- The containerized execution environment
- Volume mount strategy and state persistence
- Error handling and rollback procedures
- Real-world migration scenarios

Thank you!
