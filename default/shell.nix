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
    initExtra = "[[ ! -f ${config.xdg.configHome}/zsh/p10k.zsh ]] || source ${config.xdg.configHome}/zsh/p10k.zsh";
    oh-my-zsh = {
      enable = true;
      custom = "${config.xdg.configHome}/zsh/custom/plugins";
      plugins = [ "git" "zsh-autosuggestions" "zsh-history-substring-search" "zsh-syntax-highlighting" ];
      theme = "powerlevel10k/powerlevel10k";
    };
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