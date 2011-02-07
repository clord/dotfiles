# Install

Start by getting the files:

	git clone https://github.com/clord/dotfiles.git


then run `cd dotfiles; init` which will initialize your home directory.


## Adding new vim plugins

Since I use `pathogen.vim` to manage plugins, everything goes in the bundle subdir. To make version management easier, 
any plugins going into that directory should be git sub-modules, so that the `git submodule update` command will 
take care of upgrading components.

	cd ~/$1
	git submodule add https://github.com/$author/vim-$plugname.git vim/bundle/$plugname

will perpare the repository so as to pull this plugin.

## IRB


	gem install interactive_editor awesome_print
