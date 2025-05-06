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
    git
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
  ] ++ lib.optionals stdenv.isDarwin [
    cowsay
  ];

  # Homebrew packages
  homebrew = lib.mkIf pkgs.stdenv.isDarwin {
    enable = true;
    # onActivation.cleanup = "zap";
    onActivation.autoUpdate = true;
    onActivation.upgrade = true;
    taps = [ ];
    brews = [ ];
    casks = [
      "ghostty"
    ];
  };

  # Fonts
  fonts.packages = [
    pkgs.nerd-fonts.symbols-only
    pkgs.meslo-lgs-nf
  ];
}
