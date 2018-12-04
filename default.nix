# Main nix environment setup script.
#
# Based on https://github.com/nmattia/homies/blob/master/default.nix
let

  pkgs = import <nixpkgs> { };

  # The list of packages to be installed
  tools = with pkgs;
    [
      # Customized packages
      bashrc
      git
      tmux
      vim
      zsh
      silver-searcher
      emacs

      pkgs.bash
      pkgs.cacert
      pkgs.gnupg
      pkgs.pinentry
      pkgs.reattach-to-user-namespace
      pkgs.zsh-completions
      pkgs.gawk
      pkgs.less
      pkgs.nix
      pkgs.tree
      pkgs.gitAndTools.hub
    ];

  ## Some customizations

  # A custom '.bashrc' (see bashrc/default.nix for details)
  bashrc = pkgs.callPackage ./bashrc {};

  # Git with config baked in
  git = import ./git (
    { inherit (pkgs) makeWrapper symlinkJoin;
      git = pkgs.git;
    });

  # silver-searcher with environment setup
  silver-searcher = import ./silver-searcher (
    { inherit (pkgs) makeWrapper symlinkJoin;
      silver-searcher = pkgs.silver-searcher;
    });

  # custom prezto
  zsh-prezto = import ./zsh/prezto.nix (
    { inherit (pkgs) stdenv fetchgit; }
  );

  # Zsh with config baked in
  zsh = import ./zsh (
    { inherit (pkgs) makeWrapper symlinkJoin;
      zsh = pkgs.zsh;
      zsh-prezto = zsh-prezto;
    });

  # Tmux with a custom tmux.conf baked in
  tmux = import ./tmux (with pkgs;
    { inherit
        makeWrapper
        symlinkJoin
        ;
      tmux = pkgs.tmux;
    });

  vim = import ./vim (
    {
      neovim = pkgs.neovim;
      vimPlugins = pkgs.vimPlugins;
    });

  emacs = import ./emacs (with pkgs;
    { inherit
        makeWrapper
        symlinkJoin
      ;
      emacsWithPackages = (pkgs.emacsPackagesNgGen pkgs.emacs).emacsWithPackages;
      epkgs = pkgs.epkgs.melpaStablePackages;
    });

in
  if pkgs.lib.inNixShell
  then pkgs.mkShell
    { buildInputs = tools;
      shellHook = ''
        $(bashrc)
        '';
    }
  else tools
