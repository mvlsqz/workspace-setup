set _fd (brew --prefix fd)/bin/fd
set _fzf (brew --prefix fzf)/bin/fzf

function goto
    set selection ( $_fd -0 -t d --exclude "ENVS" . ~/ |
      $_fzf --read0 --multi --height=80% --border=rounded \
      --preview='tree -C {}' --preview-window='45%,border-rounded' \
      --prompt='Dirs 󰅬 '
    )

    if test -d $selection
        cd $selection
        ls
    end
end
