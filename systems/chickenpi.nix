{ config, restedpi, ... }: {

  networking = {
    hostName = "chickenpi";
    wireless.enable = false;
    useDHCP = true;
  };

  hardware.bluetooth.powerOnBoot = false;

  services.prometheus = {
    exporters = {
      node = {
        enable = true;
        enabledCollectors = [ "systemd" ];
        port = 9002;
      };
    };
  };

  systemd.services.restedpi = {
    enable = true;
    environment = { RUST_BACKTRACE = "1"; };
    description = "restedpi exposes a graphql api on the raspberry pi";
    unitConfig = { };
    serviceConfig = {
      ExecStart =
        "${restedpi}/bin/restedpi --config-file /run/secrets/configuration --log-level warn server";
    };
    wantedBy = [ "multi-user.target" ];
  };

}

