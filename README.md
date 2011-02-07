# Install

Start by getting the files:

	git clone https://github.com/clord/dotfiles.git


then run `cd dotfiles; init` which will perform the following:

    #!/bin/zsh
    wdir=`pwd`
    git submodule init
    git submodule update
    ln -fs $pwd/zshrc ~/.zshrc
    ln -fs $pwd/vimrc ~/.vimrc
    ln -fs $pwd/irbrc ~/.irbrc
    ln -fs $pwd/vim ~/.vim
    ln -fs $pwd/zshrc ~/.zshrc
    ln -fs $pwd/zshenv ~/.zshenv
    ln -fs $pwd/zprofile ~/.zprofile
    ln -fs $pwd/zsh ~/.zsh
    mkdir -p ~/tmp
    touch ~/tmp/user.vim

## Adding new vim plugins

Since I use `pathogen.vim` to manage plugins, everything goes in the bundle subdir. To make version management easier, 
any plugins going into that directory should be git sub-modules, so that the `git submodule update` command will 
take care of upgrading components.

	cd ~/$1
	git submodule add https://github.com/$author/vim-$plugname.git vim/bundle/$plugname

will perpare the repository so as to pull this plugin.

## IRB


	gem install interactive_editor awesome_print
