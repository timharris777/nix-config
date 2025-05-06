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
    gawk
    gnused
    zoxide
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
    bruno
    aerospace
    karabiner-elements
    awscli2
    ssm-session-manager-plugin
    utm
    lastpass-cli
    appcleaner
    sketchybar
    slack
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
    taps = [ ];
    brews = [
      "helm" # not supported by nix on mac
    ];
    casks = [
      "ghostty" # not supported by nix on mac
      "visual-studio-code" # vscode
      "dbgate"
      "firefox@beta"
      "logseq"
      "postman"
      "vivaldi" # not supported by nix on mac
    ];
  };

  # Fonts
  fonts.packages = with pkgs; [
    fira-code
  ];
}
