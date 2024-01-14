{ config, pkgs, ... }:

{
  users = {
    mutableUsers = false;
    users.clord = {
      extraGroups = [ "wheel" "networkmanager" "video" "docker" ];
      isNormalUser = true;
      createHome = true;
      description = "Christopher Lord";
      hashedPassword =
        "$6$rqif/DR0LEsLvTQZ$5InFT61IlLackePHpFbtd978GdFt9X1G1JgGFGS7nGzjAmLbSdoZxy7Vob3ppkDsP1eaqNgBtp.X26e/4hzDO.";
      shell = pkgs.fish;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIP3DeyWHOIc+SdTqNP9iFD4jpf0fg1FVTsaWn2qcKDTa clord@edmon"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINXLYw43gNlnfEoHpmK/UWae4DcQyLBQTGQH9ZYlRG5q clord@wildwood"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINLtiIXQ0r+l0gtnjCj1hT5Z1YzRqgJ/g66pP/eEuXM3 clord@ipad"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHTOl4xwPOT82EmW5bEBpWyi5Iy9ZEYWPToJEQjIagyO clord@1p"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPbu/FXxZhyXOEsQpsAm2YLR4P07WoFcYTm1tbUohQ1U clord@dunbas_vm"
      ];
    };
  };

  programs.fish.enable = true;
}

