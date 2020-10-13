{ config, pkgs, ... }:
{
  services.nginx = {
    enable = true;
    recommendedTlsSettings = true;
    recommendedOptimisation = true;
    recommendedGzipSettings = true;
    recommendedProxySettings = true;

    virtualHosts = {
      "chat.ja13.org" = {
        locations."/".proxyPass = "http://10.0.0.31:8065";
      };
    };
  };
}
