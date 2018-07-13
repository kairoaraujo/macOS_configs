#!/bin/bash
#
#

# Install Brew
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# Install Brew packages
brew install python vim git ctags wget httpie

# Install my Python packages
pip install dbgp pep8 flake8 pyflakes isort tox git-review

# Install my VIM IDE
cp vimrc -O $HOME/.vimrc
vim -E -u $HOME/.vimrc +qall
