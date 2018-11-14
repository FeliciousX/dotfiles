# piping fortune into cowsay
fortune -a | cowsay -f $(ls /usr/share/cows | shuf -n1) -n
