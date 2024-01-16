let
  pubkeys = import ../pubkeys/default.nix;
in
{
  "rootPasswd.age".publicKeys = pubkeys.clord.computers;
  "clordPasswd.age".publicKeys = pubkeys.clord.computers;
  "chickenpiAppSecret.age".publicKeys = pubkeys.clord.host "chickenpi";
  "chickenpiRipCert.age".publicKeys = pubkeys.clord.host "chickenpi";
  "chickenpiRipKey.age".publicKeys = pubkeys.clord.host "chickenpi";
  "chickenpiConfig.age".publicKeys = pubkeys.clord.host "chickenpi";
}
