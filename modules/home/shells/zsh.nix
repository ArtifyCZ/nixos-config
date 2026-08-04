{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.homeProfile.shells.zsh;
  inherit (pkgs.stdenv.hostPlatform) isDarwin;
in

{
  options.homeProfile.shells.zsh = {
    enable = lib.mkEnableOption "Enable Zsh shell";
  };

  config = lib.mkIf cfg.enable {
    programs.zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;

      # Smart Tab Completion Settings
      completionInit = ''
        autoload -U compinit && compinit
        zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' # Case-insensitive matching
        zstyle ':completion:*' menu select                      # Arrow key selection menu
      '';

      # History configuration
      history = {
        size = 50000;
        save = 50000;
        ignoreDups = true;
        share = true; # Share history instantly across all terminal windows
        extended = true; # Save timestamp with commands
      };

      # Key quality-of-life aliases
      shellAliases = {
        # Modern replacements
        ls = "eza --icons --group-directories-first";
        ll = "eza -lh --icons --git --group-directories-first";
        la = "eza -lah --icons --git --group-directories-first";
        tree = "eza --tree --icons";
        cat = "bat";
        grep = "rg";
        find = "fd";

        # Quick git shortcuts
        g = "git";
        gf = "git fetch --all";
        gs = "git status";
        gd = "git diff";
        gl = "git log --oneline --graph --decorate";
        gp = "git push";
        gpf = "git push --force-with-lease";
        grb = "git rebase -i --autosquash";
      };

      # Custom bindings & environment
      initContent = lib.concatStrings (
        [
          ''
            # Keybindings (Fixes Home/End/Delete key behaviors on macOS/Linux)
            bindkey '^[[H' beginning-of-line
            bindkey '^[[F' end-of-line
            bindkey '^[[3~' delete-char

            # Substring history search (type a command prefix, then press Up/Down arrows)
            autoload -U up-line-or-beginning-search down-line-or-beginning-search
            zle -N up-line-or-beginning-search
            zle -N down-line-or-beginning-search
            bindkey '^[[A' up-line-or-beginning-search
            bindkey '^[[B' down-line-or-beginning-search
          ''
        ]
        ++ (lib.optional isDarwin ''
          export PATH="$PATH:/opt/homebrew/bin";
          export PATH="$PATH:$HOME/.cargo/bin";
        '')
      );
    };

    # Starship Prompt (Fast, cross-shell prompt)
    programs.starship = {
      enable = true;
      enableZshIntegration = true;
      settings = {
        add_newline = false;
        character = {
          success_symbol = "[❯](bold green)";
          error_symbol = "[❯](bold red)";
        };
        directory = {
          style = "bold cyan";
          truncation_length = 3;
          truncate_to_repo = true;
        };
        git_status = {
          style = "bold yellow";
        };
        # Hide long toolchain versions unless needed
        python.disabled = true;
        ruby.disabled = true;
        java.disabled = true;
      };
    };

    # Zoxide (Smarter 'cd')
    programs.zoxide = {
      enable = true;
      enableZshIntegration = true;
      options = [ "--cmd cd" ]; # Replaces standard 'cd' with zoxide!
    };

    # FZF (Fuzzy Finder integration)
    programs.fzf = {
      enable = true;
      enableZshIntegration = true;
      defaultCommand = "fd --type f --hidden --exclude .git";
      fileWidget.command = "fd --type f --hidden --exclude .git";
    };

    home.packages = with pkgs; [
      eza # Modern ls
      bat # Syntax-highlighted cat
      fd # Fast file finder
      ripgrep # Fast text searching
      fzf # Fuzzy finder UI
      zoxide # Smart directory jumper
      htop # Process viewer
    ];
  };
}
