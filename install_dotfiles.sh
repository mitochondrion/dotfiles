#!/bin/bash

set -e
set -o pipefail

cd "${0%/*}"

NOW=$(date "+%Y%m%d%H%M%S")

symlink() {
    local src="$1"
    local dst="$2"
    # Back up anything already at the destination (file, symlink, or broken symlink)
    if [ -e "$dst" ] || [ -L "$dst" ]; then
        mv "$dst" "$dst.$NOW"
    fi
    ln -s "$src" "$dst"
}

for FILE in .bash_profile .vimrc .gitconfig .gitignore .ctags Brewfile; do
    symlink "$PWD/$FILE" ~/"$FILE"
done

# Install Git completion from the official Git repo
wget https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash -O ~/.git-completion.bash

echo "Run the following command to complete installation:"
echo "source ~/.bash_profile"
