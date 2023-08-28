{ config, pkgs, ... }:
{
  # allows home-manager to manager bash
  programs.bash = {
    enable = true;
    enableCompletion = true;
    initExtra = ''
      export PS1="\\[\\033[01;32m\\]\\u@\\h:\\w\\[\\033[00m\\]\\$ "
      '';
    historyFile = "${config.xdg.configHome}/bash_history";
  };

  # Install zsh, and allows home-manager to manage zsh configs, with plugins, and oh-my-zsh management
  programs.zsh = {
    enable = true;
    dotDir = ".config/zsh";
    autocd = true;
    history =  {
      path = "${config.xdg.configHome}/zsh/zsh_history";
      expireDuplicatesFirst = true;
    };
    historySubstringSearch.enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    # source p10k theme at ZSH_CUSTOM in XDG_DATA_HOME
    initExtra = ''
      [[ ! -f ${config.xdg.configHome}/zsh/p10k.zsh ]] || source ${config.xdg.configHome}/zsh/p10k.zsh
      bindkey '^[[3~' delete-char # Delete
      bindkey '^[[3;5~' kill-word # Ctrl + Delete
      bindkey '^H' backward-kill-word # Ctrl + Backspace
      bindkey '^[[1;5C' forward-word # Ctrl + Right
      bindkey '^[[1;5D' backward-word # Ctrl + Left
      bindkey '^[[H' beginning-of-line # Home
      bindkey '^[[F' end-of-line # End
      bindkey '^[[5~' beginning-of-buffer-or-history # Page Up
      bindkey '^[[6~' end-of-buffer-or-history # Page Down
      '';
    plugins = [
      {name = "zsh-autosuggestions";src = pkgs.zsh-autosuggestions;}
      {name = "zsh-history-substring-search";src = pkgs.zsh-history-substring-search;}
      {name = "zsh-syntax-highlighting";src = pkgs.zsh-syntax-highlighting;}
      {name = "powerlevel10k";src = pkgs.zsh-powerlevel10k;file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";}
    ];
  };

  home.file."p10k.zsh" = {
    enable = true;
    target = ".config/zsh/p10k.zsh";
    source = "${./config/p10k.zsh}";
  };

  # Install fish and allows home-manager to manage fish configs
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting
      set sponge_purge_only_on_exit true
    ''; # Disable greeting, sponge only purge on exit
    plugins = [
     { name = "tide"; src = pkgs.fishPlugins.tide.src; } # p10k-like theme for fish
     { name = "grc"; src = pkgs.fishPlugins.grc.src; } # grc for colorized command output
     { name = "fzf-fish"; src = pkgs.fishPlugins.fzf-fish.src; } # PatrickF1 fzf key bindings
     { name = "sponge"; src = pkgs.fishPlugins.sponge.src; } # clean fish history from typos automatically
     { name = "z"; src = pkgs.fishPlugins.z.src; } # Pure-fish z directory jumping
     ];
    };
}
