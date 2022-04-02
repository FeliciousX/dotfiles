function extract
  if test (count $argv) -lt 1
    echo "Supply file to extract"
    return
  end

  set -l file $argv[1]

  switch $file
    case '*.tar'
      echo tar xvf $file
    case '*.tar.gz' '*.tgz'
      echo tar xvzf $file
    case '*.tar.bz2' '*.tbz2'
      echo tar xvjf $file
    case '*.bz2'
      echo bunzip2 $file
    case '*.rar'
      echo unrar x $file
    case '*.gz'
      echo gunzip $file
    case '*.zip'
      echo unzip $file
    case '*.Z'
      echo uncompress $file
    case '*.7z'
      echo 7z x $file
    case '*'
      echo "Don't know how to extract" $file
    end
end
