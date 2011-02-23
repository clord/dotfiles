# Install

Start by getting the files:

	git clone https://github.com/clord/dotfiles.git

then run `cd dotfiles; init` to initialize your home directory with appropriate symlinks. 
WARNING: The above command will not make any backups of the files it clobbers. Only use if you know
what you are doing. 


## Adding new vim plugins

Since I use `pathogen.vim` to manage plugins, everything goes in the bundle subdir. To make version management easier, 
any plugins going into that directory should be git sub-modules, so that the `git submodule update` command will 
take care of upgrading components.

	cd $dotfiles
	git submodule add https://github.com/$author/vim-$plugname.git vim/bundle/$plugname

will perpare the repository so as to pull this plugin.
