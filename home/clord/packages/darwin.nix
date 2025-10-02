# macOS-specific packages
{pkgs, ...}: {
  home.packages = with pkgs; [
    # Node packages
    nodePackages.svgo

    # Note: Kubernetes tools (k3d, tilt, kubernetes-helm, kind) moved to
    # home/clord/modules/kubernetes.nix (role-based configuration)
  ];
}
