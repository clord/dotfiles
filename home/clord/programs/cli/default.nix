{pkgs, ...}: {
  imports = [
    ./bat.nix
    ./btop.nix
    ./direnv.nix
    ./eza.nix
    ./fish.nix
    ./nushell.nix
    ./git.nix
    ./helix.nix
    ./nvim
    ./ssh.nix
    ./atuin.nix
  ];
  config = {

    programs.neovim.enable = true;

    programs.bun.enable = true;

    home = {
      sessionPath = ["node_modules/.bin" "$HOME/go/bin"];
      sessionVariables = {
        EDITOR = "nvim";
      };
      packages = with pkgs; [
        age
        dua
        difftastic
        fd
        ffmpeg
        hledger
        fzf
        git
        go
	rustup
        mosh
	nixd
	nil
        angle-grinder
        nodejs_22
        corepack_22
        pandoc
        python311Packages.pynvim
        sqlite
        sysbench
        tldr
        typst
        unzip
        wget
        xz
        zig
        zip
      ] ++ [
	# Grafana stuff
	gnumake
	libiconv
	
	go
	gopls
	act
	gotools
	go-migrate
	gh
	mage
	
	# Grafana stuff
	google-cloud-sdk
	jsonnet-bundler
	
	# Node stuff
	nodejs
	corepack_22
	nodePackages.concurrently
	nodePackages.prettier

	# Tilt requires some kube stuff
	tilt
	tanka
	ctlptl
	kubernetes-helm
      ];
    };
  };
}
