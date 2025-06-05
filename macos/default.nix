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
      persistent-apps = [ ];
      appswitcher-all-displays = true;
    };
    trackpad = {
      Clicking = true; # Enable tap to click
      TrackpadThreeFingerDrag = true; # Enable three finger drag
    };
    NSGlobalDomain = {
      AppleShowAllExtensions = true;
      AppleShowAllFiles = true;
      _HIHideMenuBar = true; # Autohide the menu bar.
      "com.apple.trackpad.forceClick" = false; # Disable force click
    };
    CustomUserPreferences = {
      NSGlobalDomain = {
        WebKitDeveloperExtras = true; # Add a context menu item for showing the Web Inspector in web views
      };
      "com.apple.finder" = {
        ShowExternalHardDrivesOnDesktop = true;
        ShowHardDrivesOnDesktop = true;
        ShowMountedServersOnDesktop = true;
        ShowRemovableMediaOnDesktop = true;
        _FXSortFoldersFirst = true;
        # When performing a search, search the current folder by default
        FXDefaultSearchScope = "SCcf";
      };
      "com.apple.desktopservices" = {
        # Avoid creating .DS_Store files on network or USB volumes
        DSDontWriteNetworkStores = true;
        DSDontWriteUSBStores = true;
      };
      "com.apple.screensaver" = {
        # Require password immediately after sleep or screen saver begins
        askForPassword = 1;
        askForPasswordDelay = 0;
      };
      "com.apple.screencapture" = {
        location = "~/Desktop";
        type = "png";
      };
      "com.apple.AdLib" = {
        allowApplePersonalizedAdvertising = false;
      };
      "com.apple.print.PrintingPrefs" = {
        "Quit When Finished" = true; # Automatically quit printer app once the print jobs complete
      };
      "com.apple.SoftwareUpdate" = {
        AutomaticCheckEnabled = true;
        ScheduleFrequency = 1; # Check for software updates daily, not just once per week
        AutomaticDownload = 1; # Download newly available updates in background
        CriticalUpdateInstall = 1; # Install System data files & security updates
      };
      "com.apple.TimeMachine".DoNotOfferNewDisksForBackup = true; # Disable Time Machine popup when external drives are connected
      "com.apple.ImageCapture".disableHotPlug = true; # Prevent Photos from opening automatically when devices are plugged in
      "com.apple.commerce".AutoUpdate = true; # Turn on app auto-update
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
    /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u # Allows us to avoid a logout/login cycle to apply the settings
    defaultbrowser vivaldi # Set default browser
  '';

  # Set Git commit hash for darwin-version.
  system.configurationRevision = self.rev or self.dirtyRev or null;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 6;

  # Disable the Nix daemon, as it is not needed since determinate linux is monitoring this
  nix.enable = false;
}
