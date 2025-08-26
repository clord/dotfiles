{lib, ...}: {
  options.roles = {
    terminal.enable = lib.mkEnableOption "Terminal and shell tools";
    
    development = {
      enable = lib.mkEnableOption "General development tools";
      languages = {
        go = lib.mkEnableOption "Go development";
        rust = lib.mkEnableOption "Rust development";
        node = lib.mkEnableOption "Node.js development";
        python = lib.mkEnableOption "Python development";
        zig = lib.mkEnableOption "Zig development";
      };
    };
    
    kubernetes = {
      enable = lib.mkEnableOption "Kubernetes tools";
      includeHelm = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Include Helm package manager";
      };
      includeK9s = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Include k9s terminal UI";
      };
    };
    
    grafana = {
      enable = lib.mkEnableOption "Grafana development setup";
      includeCloud = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Include Grafana Cloud tools";
      };
    };
    
    desktop = {
      enable = lib.mkEnableOption "Desktop environment and GUI apps";
      gaming = lib.mkEnableOption "Gaming tools and platforms";
      multimedia = lib.mkEnableOption "Multimedia editing tools";
    };
    
    server = {
      enable = lib.mkEnableOption "Server and infrastructure tools";
    };
  };
  
  config = {};
}
