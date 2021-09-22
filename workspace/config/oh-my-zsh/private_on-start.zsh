# piping fortune into cowsay
fortune -a | cowsay -f $(ls /usr/share/cows | grep -E cow$ | shuf -n1) -n | lolcat
