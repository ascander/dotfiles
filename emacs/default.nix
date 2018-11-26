# emacs with init.el baked in

{ emacsWithPackages, epkgs, symlinkJoin, makeWrapper }:

let

  my-emacs = emacsWithPackages (epkgs: (with epkgs; [
    evil
    evil-org
    helm
    key-chord
    linum-relative
    magit
    markdown-mode
    org
    spaceline
    projectile
    color-theme-sanityinc-tomorrow
    which-key

    # Nix
    nix-mode

    # Scala
    scala-mode
    sbt-mode
  ]));

in
  symlinkJoin {
    name = "emacs";
    buildInputs = [ makeWrapper ];
    paths = [ my-emacs ];
    postBuild = ''
      wrapProgram "$out/bin/emacs" \
      --add-flags "-q -l ${./init.el}"
    '';
  }
