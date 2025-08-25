# macOS-specific packages
{pkgs, ...}: {
  home.packages = with pkgs; [
    # Kubernetes tools (commonly used on macOS for dev)
    k3d
    tilt
    kubernetes-helm
    kind

    # Node packages
    nodePackages.svgo
  ];
}
