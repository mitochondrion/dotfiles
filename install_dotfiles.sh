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

for DOTFILE in .bash_profile .vimrc .gitconfig .gitignore .ctags; do
    symlink "$PWD/$DOTFILE" ~/"$DOTFILE"
done

symlink "$PWD/Brewfile.mbp2021" ~/Brewfile

# Install Git completion from the official Git repo
wget https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash -O ~/.git-completion.bash

echo "Run the following command to complete installation:"
echo "source ~/.bash_profile"
