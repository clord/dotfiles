{ pkgs, ... }:
{
  programs.fish = {
    enable = true;
    plugins = [
      {
        name = "tide";
        src = pkgs.fetchFromGitHub {
          owner = "IlanCosman";
          repo = "tide";
          rev = "a34b0c2809f665e854d6813dd4b052c1b32a32b4";
          sha256 = "sha256-ZyEk/WoxdX5Fr2kXRERQS1U1QHH3oVSyBQvlwYnEYyc=";
        };
      }
    ];
    interactiveShellInit = ''
      set fish_greeting # Disable greeting
      fish_vi_key_bindings
      set fish_cursor_default block
      set fish_cursor_insert line
      set fish_cursor_replace_one underscore
      set fish_cursor_visual block
      set -g theme_display_vi yes
      set -g theme_title_display_user ssh
      set -g theme_title_display_hostname ssh
      set -g theme_display_nix no
      set -g default_user clord

      cat ${./logo.ascii}

      if test -d $GHOSTTY_RESOURCES_DIR/shell-integration/fish/vendor_conf.d
          for file in $GHOSTTY_RESOURCES_DIR/shell-integration/fish/vendor_conf.d/*.fish
              source $file
          end
      end

    '';
    shellAliases = {
    };
    shellAbbrs = {
      v = "neovide";
      vim = "nvim";
      c = "clear";
      g = "git";
      s = "git status -sb";
      ga = "git add -A";
      gs = "git switch";
      "gs!" = "git switch --create";
      gc = "git commit --verbose";
      gp = "git push";
      gu = "git pull";
      gd = "git diff";
      fomo = "git fetch origin main && git rebase origin/main";
      lll = "eza -bghHliS";
    };
    functions = {
      t = "cd (mktemp -d /tmp/$1.XXXX)";
      mcd = "mkdir -p $argv; and cd $argv";

      print_help = {
        argumentNames = [
          "msg"
          "script_name"
        ];
        body = ''
          if test -n "$msg"
              set_color red
              echo "$msg"
          end
          set_color yellow
          echo "Usage:"
          echo "  git diff --cached | $script_name"
          set_color grey
          echo "  # or"
          set_color yellow
          echo "  $script_name (git diff --cached)"
        '';
      };

      gen_commit_msg = {
        argumentNames = [ "gitDiff" ];
        body = ''
          # Constants
          set prompt "I want you to act as a commit message generator. I will provide you with a git diff containing changes I've made to my project, and I would like you to generate 3 appropriate commit messages using the conventional commit format. Do not give me choices like \"if the commit was adding a feature, choose this commit message,\" or \"if the commit was fixing a bug, choose that commit message;\" just do your best to decide which 3 commit messages are the most appropriate based on the changes contained in the git diff. Do not write any explanations or other words, just reply with the commit message. Here is the git diff: \n"

          # Input Handling
          if not isatty stdin
              read -z pipeInput
          end

          if test -n "$gitDiff" -a -n "$pipeInput"
              print_help "Both a piped value and a function arg were passed to this function, but only one can be accepted." (status function)
              return 1
          else if test -n "$gitDiff"
              set input $gitDiff
          else if test -n "$pipeInput"
              set input $pipeInput
          else
              print_help "No git diff or text was passed to this function." (status function)
              return 1
          end

          # Format Input
          set codeblocked_git_diff "```"(echo $input)"```"

          # Use Ollama to Generate Commit Messages
          set result (ollama run qwen2.5-coder:32b-base-q2_K  "$prompt\n$codeblocked_git_diff")

          if test $status -eq 0
              echo $result
          else
              set_color red
              echo "Error: Failed to generate commit messages using Ollama."
              return 1
          end
        '';
      };
      prepend_path = {
        argumentNames = [ "r" ];
        body = ''
          if test -d $r
              test -d $r/sbin ; and set PATH $r/sbin $PATH
              test -d $r/bin ; and set PATH $r/bin $PATH
              test -d $r/scripts ; and set PATH $r/scripts $PATH
              test -d $r/share/man ; and set MANPATH $r/share/man $MANPATH
          end
        '';
      };
    };
  };
}
