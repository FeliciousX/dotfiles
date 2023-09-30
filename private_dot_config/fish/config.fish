if status is-interactive
    # Commands to run in interactive sessions can go here
end
# set up path before everything else
# fish_add_path ~/.cargo/bin
fish_add_path ~/.local/bin
fish_add_path ~/.npm-global/bin

# environment
set -gx EDITOR helix

# aliases
abbr l ls
abbr la ls -a
abbr ls-npm-scripts jq .scripts package.json

## gpg
if type -q gpgconf
  set SSH_AUTH_SOCK (gpgconf --list-dirs agent-ssh-socket)
  set GPG_TTY (tty)
  gpgconf --launch gpg-agent
end

## git
if type -q git
  abbr ga git add
  abbr gf git fetch -p
  abbr gc git commit -v
  abbr gb git branch
  abbr gbD git branch -D
  abbr gd git diff
  abbr gds git diff --staged
  abbr gm git merge
  abbr gst git status
  abbr gsw git switch
  abbr gswc git switch -c
  abbr gswd git switch -d
  abbr gco git checkout
  abbr grb git rebase
  abbr grba git rebase --abort
  abbr grbc git rebase --continue
  abbr grbi git rebase --interactive
  abbr grs git reset
  abbr grsh git reset --hard
  abbr gcp git cherry-pick
  abbr gcpa git cherry-pick --abort
  abbr gcpc git cherry-pick --continue
  abbr glog git log
  abbr glgo git log --graph --oneline
end

## tmux
if type -q tmux
  abbr ts tmux new -s
  abbr tl tmux ls
  abbr ta tmux attach -t
end

### wip
function unwip
  set -l last_commit (git log -1 --format=%B)
  if string match -q -- '--wip--*' -- $last_commit
    git reset --soft HEAD~
  else
    echo 'Current HEAD not a WIP commit'
  end
end

## get external ips, https://unix.stackexchange.com/a/81699/37512
abbr wanip 'dig @resolver4.opendns.com myip.opendns.com +short'
abbr wanip4 'dig @resolver4.opendns.com myip.opendns.com +short -4'
abbr wanip6 'dig @resolver1.ipv6-sandbox.opendns.com AAAA myip.opendns.com +short'

# system-specific

## gcloud completion/cask
## $ set -Ux CLOUDSDK_HOME ...
if set -q CLOUDSDK_HOME && test -d $CLOUDSDK_HOME
  source "$CLOUDSDK_HOME/path.fish.inc"
end

## set up xdg-open alias
if type -q xdg-open
  abbr x xdg-open
end

## nnn setup
if type -q nnn
  set -gx NNN_BMS 'w:~/workspaces;d:~/Documents;D:~/Downloads;p:~/Pictures;m:~/Music;v:~/Videos'

  # optionally enable trash
  if type -q trash-put
    set -gx NNN_TRASH '1'
  end
end

## clipboard setup
switch (uname)
  case Linux
    if test "$XDG_SESSION_TYPE" = 'wayland' && type -q wl-copy && type -q wl-paste
      set -gx COPY wl-copy -n
      set -gx PASTE wl-paste -n
    else if test "$XDG_SESSION_TYPE" = 'x11' && type -q xclip
      set -gx COPY xclip -selection clipboard -rmlastnl
      set -gx PASTE xclip -selection clipboard -out
    end
  case Darwin
    set -gx COPY pbcopy
    set -gx PASTE pbpaste
end

## use exa instead of ls if available
if type -q exa
  abbr l exa
  abbr ls exa
  abbr la exa -a
end

## alias fd to fdfind if available
if type -q fdfind
  abbr fd fdfind
end

## fuzzy search commands
if type -q fzy
  function fs
    fd -t file 2> /dev/null | fzy | $COPY
  end

  function hs
    history | fzy | eval "$COPY"
  end

  function v
    if test -z $argv
      set -l pasted ($PASTE)
      if test -e $pasted
        $EDITOR $pasted
      else if git rev-parse --verify $pasted &> /dev/null
        git checkout $pasted
      else
        fs
      end
    else
      $EDITOR $argv
    end
  end
end

## tz setup, https://github.com/oz/tz
if type -q tz
  set -gx TZ_LIST 'Etc/UTC,Europe/Amsterdam,Asia/Tokyo,Australia/Sydney,America/New_York,America/Chicago,America/Los_Angeles'
  abbr tzq tz -q
end

## direnv setup
if type -q direnv
  direnv hook fish | source
end

## tj/n
if type -q n
  set -gx N_PREFIX "$HOME/.local/share/"
  fish_add_path $N_PREFIX/bin
end

# prompt setup
if type -q starship
  starship init fish | source
end

# kakoune kcr alias
if type -q kcr
  abbr k 'kcr edit'
  abbr K 'kcr-fzf-shell'
  abbr KK 'K --working-directory .'
  abbr ks 'kcr shell --session'
  abbr kl 'kcr list'
  abbr a 'kcr attach'

  # Open files _from_ and _to_ a session.
  # $ :f src
  # $ f: mawww/kakoune
  abbr :f 'kcr fzf files'
  abbr f: 'KK kcr fzf files'
  abbr fm: 'K sidetree --working-directory'

  abbr :g 'kcr fzf grep'
  abbr g: 'KK kcr fzf grep'
end

function zenudiff
  git diff --name-only --diff-filter=ACMR origin/release \
    'config/**.cf*' \
    'controllers/**.cf*' \
    'events/**.cf*' \
    'global/**.cf*' \
    'helpers/**.cf*' \
    'migrator/templates/**.cf*' \
    'migrator/migrations/**.cf*' \
    'migrator/Migrate.cfc' \
    'models/**.cfc' \
    'services/**.cfc' \
    'tests/**.cfc' | tr '\n' ','
end

abbr zenucompose docker compose -f docker-compose.yml -f docker-compose.zenu.yml
