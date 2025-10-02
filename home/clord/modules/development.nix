{
  lib,
  pkgs,
  roles,
  ...
}: {
  config = lib.mkMerge [
    # Base development tools
    (lib.mkIf roles.development.enable {
      home.packages = with pkgs; [
        # Version control
        git
        git-lfs
        gh
        difftastic
        git-crypt

        # Build tools
        gnumake
        cmake
        meson
        ninja

        # Debugging
        lldb

        # Documentation
        pandoc
        typst

        # Code quality
        pre-commit
        actionlint

        # Language servers & formatters
        nixd
        nil
        nixfmt-rfc-style

        # Database tools
        sqlite
        postgresql

        # API tools
        curl
        httpie
        postman

        # Ruby development (moved from common.nix)
        rbenv
        bundix

        # Performance & benchmarking
        sysbench
      ];

      home.sessionVariables = {
        EDITOR = "nvim";
        VISUAL = "nvim";
      };
    })

    # Go development
    (lib.mkIf (roles.development.enable && roles.development.languages.go) {
      home = {
        packages = with pkgs; [
          go
          gopls
          gotools
          go-migrate
          golangci-lint
          delve
          gomodifytags
          gotests
          moq
          impl
          godef
        ];

        sessionPath = ["$HOME/go/bin"];

        sessionVariables = {
          GOPATH = "$HOME/go";
          GO111MODULE = "on";
        };
      };
    })

    # Rust development
    (lib.mkIf (roles.development.enable && roles.development.languages.rust) {
      home = {
        packages = with pkgs; [
          rustup
          # rust-analyzer is included in rustup
          cargo-edit
          cargo-watch
          cargo-audit
          cargo-outdated
          cargo-expand
          sccache
        ];

        sessionPath = ["$HOME/.cargo/bin"];
      };
    })

    # Node.js development
    (lib.mkIf (roles.development.enable && roles.development.languages.node) {
      home = {
        packages = with pkgs; [
          nodejs_22
          corepack_22
          yarn
          pnpm
          bun
        ];

        sessionPath = [
          "node_modules/.bin"
          "$HOME/.local/node_modules/.bin"
        ];
      };
    })

    # Python development
    (lib.mkIf (roles.development.enable && roles.development.languages.python) {
      home.packages = with pkgs; [
        python3
        python311Packages.pip
        python311Packages.virtualenv
        python311Packages.pynvim
        python311Packages.black
        python311Packages.pylint
        python311Packages.pytest
        pyenv
        pipenv
        poetry
      ];
    })

    # Zig development
    (lib.mkIf (roles.development.enable && roles.development.languages.zig or false) {
      home.packages = with pkgs; [
        zig
        zls # Zig language server
      ];
    })
  ];
}
