{roles, ...}: let
  pubkeys = import ../../../../pubkeys;
in {
  programs.ssh = {
    inherit (roles.terminal) enable;
    privateKeys = ["~/.ssh/id_ed25519"];
    authorizedKeys = pubkeys.clord;
  };
}
