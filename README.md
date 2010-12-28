# Install

Start by getting the files:

	git clone https://github.com/clord/dotfiles.git


then run `dotfiles/init.rb dotfiles` (or whatever you want `$1` to be), which will perform the following:

	cd dotfiles
	git submodule init
	git submodule update
	ln -s ~/$1/zshrc ~/.zshrc
	ln -s ~/$1/vimrc ~/.vimrc
	ln -s ~/$1/irbrc ~/.irbrc
	ln -s ~/$1/vim ~/.vim
	mkdir -p ~/tmp
	touch ~/tmp/user.vim

## Adding new vim plugins

Since I use `pathogen.vim` to manage plugins, everything goes in the bundle subdir. To make version management easier, 
any plugins going into that directory should be git sub-modules, so that the `git submodule update` command will 
take care of upgrading components.

	cd ~/$1
	git submodule add https://github.com/$author/vim-$plugname.git vim/bundle/$plugname

will perpare the repository so as to pull this plugin.
