  let
    user = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINXLYw43gNlnfEoHpmK/UWae4DcQyLBQTGQH9ZYlRG5q"# clord@wildwood
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINLtiIXQ0r+l0gtnjCj1hT5Z1YzRqgJ/g66pP/eEuXM3"# clord@ipad
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHTOl4xwPOT82EmW5bEBpWyi5Iy9ZEYWPToJEQjIagyO"# clord@1p
    ];
    hosts = {
      edmon = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG44RTSc6mqKI+9F0SbP9Qstk1xVg1FAALK/sVCDHaj/" ];
      chickenpi = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO6l/tsNUalrBFf0Zaftlk0QqYTQZKMfomJxv1dt7a/1"];
      jasper = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO6l/tsNUalrBFf0Zaftlk0QqYTQZKMfomJxv1dt7a/1"];
    };
  in
  {
    clord = { 
      inherit user;
      computers = user ++ (builtins.foldl' (a: b: a ++ b) [ ] (builtins.attrValues hosts)); # everything
      host = hn: (hosts.${hn} ++ user);
      hosts = hn: ((map (x: hosts.${x}) hn) ++ user);
    };
  }
