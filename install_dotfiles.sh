#!/bin/bash

set -e
set -o pipefail

cd "${0%/*}"

NOW=`date "+%Y%m%d%H%M%S"`

for DOTFILE in .bash_profile .vimrc .gitconfig .gitignore .ctags
do
    # Move existing configs out of the way and add timestamp
    # On Linux you can add the "mv --backup=t" flag for even more safety, but it's not available on OSX :(
    [ -f i~/$DOTFILE ] && mv ~/$DOTFILE ~/$DOTFILE.$NOW

    # Create symlinks to repository dotfiles
    ln -s $PWD/$DOTFILE ~/$DOTFILE
done

# Install Git completion from the official Git repo
wget https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash -O ~/.git-completion.bash

echo -e "Run the following command to complete installation:\nsource ~/.bash_profile"
