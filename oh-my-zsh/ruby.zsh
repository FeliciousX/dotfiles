# Use RVM to manage ruby versions
# https://rvm.io/

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"

# Load RVM into a shell session *as a function*
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"

# TODO: confirm if this is really required
#export rvmsudo_secure_path=0

