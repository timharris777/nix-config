{
  self,
  inputs,
  pkgs,
  lib,
  ...
}:

{
  imports = [
    ../pkgs
  ];

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";

  # Allow installation of unfree packages
  nixpkgs.config.allowUnfree = true;

  # Nix packages to install
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
    direnv
    starship
  ];

  # Homebrew packages to install
  homebrew = {
    enable = true;
    # onActivation.cleanup = "zap";
    onActivation.autoUpdate = true;
    onActivation.upgrade = true;

    taps = [ ];
    brews = [
      "cowsay"
    ];
    casks = [
      "ghostty"
    ];
  };

  # Fonts to install
  fonts.packages = [
    pkgs.nerd-fonts.symbols-only
    pkgs.meslo-lgs-nf
  ];

  # OSX System settings
  system.defaults = {
    dock.autohide = true;
    dock.orientation = "left";
    NSGlobalDomain = {
      AppleShowAllExtensions = true;
      AppleShowAllFiles = true;
    };
  };

  # Necessary for using flakes on this system.
  nix.settings.experimental-features = "nix-command flakes";

  # Disable the Nix daemon, as it is not needed since determinate linux is monitoring this
  nix.enable = false;

  # Enable alternative shell support in nix-darwin.
  programs.zsh.enable = true;

  # Declare the user that will be running `nix-darwin`.
  users.users."tim.harris" = {
    name = "tim.harris";
    home = "/Users/tim.harris";
  };

  # Set Git commit hash for darwin-version.
  system.configurationRevision = self.rev or self.dirtyRev or null;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 6;
}
