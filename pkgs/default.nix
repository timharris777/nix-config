{
  self,
  inputs,
  pkgs,
  lib,
  ...
}:
{
  # Nix packages
  environment.systemPackages = with pkgs; [
    neovim
    yq
    jq
    kubectl
    kustomize
    kubectx
    saml2aws
    tmux
    stern
    git
    git-credential-manager
    nixfmt-rfc-style
    nixd
    fzf
    tmux
    zsh
    gnupg
    gawk
    gnused
    # zoxide
    k6
    starship
    direnv
    devenv
    zoxide
    findutils
    asdf
    colima
    docker-client
    docker-compose
    # karabiner-elements
    awscli2
    bruno
    ssm-session-manager-plugin
    utm
    lastpass-cli
    appcleaner
    teams
  ] ++ lib.optionals stdenv.isDarwin [
    cowsay
  ];

  # Homebrew packages
  homebrew = lib.mkIf pkgs.stdenv.isDarwin {
    enable = true;
    onActivation.cleanup = "zap";
    onActivation.autoUpdate = true;
    onActivation.upgrade = true;
    taps = [
      "nikitabobko/tap"
      "FelixKratz/formulae"
    ];
    brews = [
      "argocd" # Argocd admin gives open dist/app/index.html: file does not exist with nix on mac
      "helm" # not supported by nix on mac
      "FelixKratz/formulae/sketchybar" # not working properly nix on mac
      "zoxide"
    ];
    casks = [
      "ghostty" # not supported by nix on
      "visual-studio-code" # vscode
      "karabiner-elements" # not working properly with nix on mac
      "dbgate"
      "firefox@beta"
      "logseq"
      # "bruno" # oauth popup not working properly with nix on mac
      "postman"
      "slack" # mic not working properly with nix on mac
      "raycast"
      "vivaldi" # not supported by nix on mac
      "nikitabobko/tap/aerospace" # sketchybar not interacting properly with aerospace with nix on mac
    ];
  };

  # Fonts
  fonts.packages = with pkgs; [
    fira-code # terminal and editor
    nerd-fonts.hack # sketchybar
  ];
}
