let pubkeys = import ../pubkeys/default.nix;
in
{
  "rootPasswd.age".publicKeys = pubkeys.clord.computers;
  "clordPasswd.age".publicKeys = pubkeys.clord.computers;
  "chickenpiAppSecret.age".publicKeys = pubkeys.clord.computers;
  "chickenpiRipCert.age".publicKeys = pubkeys.clord.computers;
  "chickenpiRipKey.age".publicKeys = pubkeys.clord.computers;
  "chickenpiConfig.age".publicKeys = pubkeys.clord.computers;
}
