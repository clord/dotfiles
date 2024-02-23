let
  clord = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINXLYw43gNlnfEoHpmK/UWae4DcQyLBQTGQH9ZYlRG5q clord" # wildwood
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINLtiIXQ0r+l0gtnjCj1hT5Z1YzRqgJ/g66pP/eEuXM3 clord" # ipad
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPHrw5QuFDaSsiZIXHypWLk4xQgxIoaVzPn4QzRag4eX clord" # chickenpi
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHTOl4xwPOT82EmW5bEBpWyi5Iy9ZEYWPToJEQjIagyO clord" # 1p
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPbu/FXxZhyXOEsQpsAm2YLR4P07WoFcYTm1tbUohQ1U clord" # dunbar
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIP3DeyWHOIc+SdTqNP9iFD4jpf0fg1FVTsaWn2qcKDTa clord" # edmon
  ];
  eugene = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBjFa1FBFggj9BTAd8kKfWBX4EJB1DhTgzlaBqjZpBUU eugene" # munchkin
  ];
  hosts = {
    edmon = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG44RTSc6mqKI+9F0SbP9Qstk1xVg1FAALK/sVCDHaj/"];
    chickenpi = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICq9/gH0UlteZW5mhWN0gNvGN/EFyrjpmmcQ9Tf2hhgj"];
    jasper = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO6l/tsNUalrBFf0Zaftlk0QqYTQZKMfomJxv1dt7a/1"];
    dunbar = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHuh/pr52sE9A0KJC1wUsE+z/TVdOOR38bSjNqjkbqTU"];
    munchkin = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHpEGG6sYzCWQZ+bTpy5V50B3qxsCbyLGsevqBXBxHX9"];
    wildwood = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICccVCVLq1RLFuxYfL9qJW8RV3CdKoAqJ2/F/hRG1Sry"];
  };
  mkUser = user: {
    inherit user;
    computers = clord ++ user ++ (builtins.foldl' (a: b: a ++ b) [] (builtins.attrValues hosts)); # everything
    host = hn: (hosts.${hn} ++ user ++ clord);
    hosts = hn: ((map (x: hosts.${x}) hn) ++ user ++ clord);
  };
in {
  eugene = mkUser eugene;
  clord = mkUser clord;
}
