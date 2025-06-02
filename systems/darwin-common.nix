{
  pkgs,
  ...
}:
{
  system = {
    keyboard = {
      enableKeyMapping = true;
      remapCapsLockToControl = true;
    };

    defaults = {
      spaces.spans-displays = false;
      alf.globalstate = 1;
      WindowManager = {
        GloballyEnabled = true;
        EnableStandardClickToShowDesktop = false;
        StandardHideDesktopIcons = true;
        EnableTilingByEdgeDrag = false;
        EnableTopTilingByEdgeDrag = false;
        EnableTilingOptionAccelerator = true;
      };
      ".GlobalPreferences" = {
        "com.apple.mouse.scaling" = -1.0;
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
        location = "$HOME/Desktop";
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

        NSAutomaticCapitalizationEnabled = false;
        NSAutomaticInlinePredictionEnabled = false;
        NSAutomaticDashSubstitutionEnabled = false;
        NSAutomaticPeriodSubstitutionEnabled = false;
        NSAutomaticQuoteSubstitutionEnabled = false;
        NSAutomaticSpellingCorrectionEnabled = false;
        NSNavPanelExpandedStateForSaveMode = true;
        NSNavPanelExpandedStateForSaveMode2 = true;
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
