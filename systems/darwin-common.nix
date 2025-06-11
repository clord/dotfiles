{
  pkgs,
  ...
}:
{
  system = {

    defaults = {
      spaces.spans-displays = false;
      alf.globalstate = 1;

      WindowManager = {
        GloballyEnabled = false;
        EnableStandardClickToShowDesktop = false;
        StandardHideDesktopIcons = true;
        EnableTilingByEdgeDrag = false;
        EnableTopTilingByEdgeDrag = false;
        EnableTilingOptionAccelerator = true;
      };

      ".GlobalPreferences" = {
        "com.apple.mouse.scaling" = -1.0;
      };

      CustomUserPreferences = {
        "com.apple.desktopservices" = {
          DSDontWriteNetworkStores = true;
          DSDontWriteUSBStores = true;
        };

        "com.apple.screensaver" = {
          askForPassword = 1;
          askForPasswordDelay = 2;
        };

        "com.apple.SoftwareUpdate" = {
          AutomaticCheckEnabled = true;
          ScheduleFrequency = 1;
          AutomaticDownload = 1;
          CriticalUpdateInstall = 1;
        };

        # Turn on app auto-update
        "com.apple.commerce".AutoUpdate = true;

        # Prevent Photos from opening automatically when devices are plugged in
        "com.apple.ImageCapture".disableHotPlug = true;

      };

      dock = {
        autohide = false;
        orientation = "left";
        show-process-indicators = true;
        show-recents = false;
        mru-spaces = false;
        showhidden = true;
      };

      screencapture = {
        location = "~/Screenshots";
        disable-shadow = true;
      };
      finder = {
        NewWindowTarget = "Home";
        ShowPathbar = true;
        ShowStatusBar = true;
        FXEnableExtensionChangeWarning = false;
        _FXShowPosixPathInTitle = true;

        AppleShowAllExtensions = true;
        QuitMenuItem = true;
        ShowExternalHardDrivesOnDesktop = true;
        ShowHardDrivesOnDesktop = true;
        ShowMountedServersOnDesktop = true;
        ShowRemovableMediaOnDesktop = true;
      };
      NSGlobalDomain = {
        AppleInterfaceStyle = "Dark";
        AppleKeyboardUIMode = 3;
        "com.apple.keyboard.fnState" = false;
        ApplePressAndHoldEnabled = false;

        InitialKeyRepeat = 10;
        KeyRepeat = 1;

        PMPrintingExpandedStateForPrint = true;
        NSNavPanelExpandedStateForSaveMode = true;
        NSNavPanelExpandedStateForSaveMode2 = true;

        # NSAutomaticCapitalizationEnabled = false;
        # NSAutomaticInlinePredictionEnabled = false;
        # NSAutomaticDashSubstitutionEnabled = false;
        # NSAutomaticPeriodSubstitutionEnabled = false;
        # NSAutomaticQuoteSubstitutionEnabled = false;
        # NSAutomaticSpellingCorrectionEnabled = false;
      };

      trackpad.Clicking = true;
      trackpad.TrackpadThreeFingerDrag = true;

    };
  };

  environment.systemPackages = with pkgs; [
    fish
    vim
    git
    home-manager
    devenv
  ];
}
