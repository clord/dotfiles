# Kubernetes tools configuration
{
  config,
  lib,
  pkgs,
  roles,
  ...
}: {
  config = lib.mkIf roles.kubernetes.enable {
    home.packages = with pkgs;
      [
        # Core tools
        kubectl
        kubernetes-helm

        # Local development clusters
        kind
        k3d
        minikube

        # Development tools
        tilt
        skaffold
        telepresence2
        ctlptl # Local kubernetes cluster management

        # Manifest management
        kustomize

        # Monitoring and debugging
        stern
        kubectx
        kubecolor

        # Policy and security
        kubeval
        kubesec

        # Operators and controllers
        operator-sdk

        # Cloud provider tools
        eksctl

        # GitOps
        argocd
        fluxcd
      ]
      ++ (lib.optional roles.kubernetes.includeK9s k9s)
      ++ (lib.optional roles.kubernetes.includeHelm helmfile);

    programs.fish.shellAbbrs = lib.mkIf config.programs.fish.enable {
      k = "kubectl";
      kx = "kubectx";
      kn = "kubens";
      kg = "kubectl get";
      kd = "kubectl describe";
      kl = "kubectl logs";
      kaf = "kubectl apply -f";
      kdel = "kubectl delete";
      kgp = "kubectl get pods";
      kgs = "kubectl get services";
      kgd = "kubectl get deployments";
    };

    home.sessionVariables = {
      KUBECONFIG = "$HOME/.kube/config";
    };

    home.file.".kube/config".text = lib.mkDefault ''
      # Kubernetes config will be managed here
      # Add your cluster configurations
    '';
  };
}