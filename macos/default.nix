{
  self,
  inputs,
  pkgs,
  lib,
  ...
}:

{
  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";

  # Allow installation of unfree packages
  nixpkgs.config.allowUnfree = true;

  # Packages to install
  imports = [
    ../pkgs
  ];

  # OSX System settings
  system.defaults = {
    dock = { 
      autohide = true;
      orientation = "left";
      show-recents = false;
      persistent-apps = [];
      appswitcher-all-displays = true;
    };
    NSGlobalDomain = {
      AppleShowAllExtensions = true;
      AppleShowAllFiles = true;
      _HIHideMenuBar = true; # Autohide the menu bar.
    };
    CustomUserPreferences = {
      "com.apple.symbolichotkeys" = {
        AppleSymbolicHotKeys = {
          # Disable 'Cmd + Space' for Spotlight Search
          "64" = {
            enabled = false;
          };
          # Disable 'Cmd + Alt + Space' for Finder search window
          "65" = {
            enabled = false;
          };
        };
      };
    };
  };

  # Allout the user to use touch ID authentication for sudo.
  security.pam.services.sudo_local.touchIdAuth = true;

  # Necessary for using flakes on this system.
  nix.settings.experimental-features = "nix-command flakes";

  # Declare the user that will be running `nix-darwin`.
  users.users."tim.harris" = {
    name = "tim.harris";
    home = "/Users/tim.harris";
  };

  system.activationScripts.postUserActivation.text = ''
    # Following line should allow us to avoid a logout/login cycle
    /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
  '';

  # Set Git commit hash for darwin-version.
  system.configurationRevision = self.rev or self.dirtyRev or null;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 6;

  # Disable the Nix daemon, as it is not needed since determinate linux is monitoring this
  nix.enable = false;
}
