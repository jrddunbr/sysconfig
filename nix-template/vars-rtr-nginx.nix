{ config, pkgs, ... }:
{
  services.nginx = {
    enable = true;
    recommendedTlsSettings = true;
    recommendedOptimisation = true;
    recommendedGzipSettings = true;
    recommendedProxySettings = true;

    virtualHosts = {
      chat = {
        locations."/" = {
          proxyPass = "http://10.0.0.31:8065";
          proxyWebsockets = true;
        };
        serverName = "chat.ja13.org";
        forceSSL = true;
        enableACME = true;
      };
    };
  };

  security.acme.acceptTerms = true;
  security.acme.certs."chat.ja13.org".email = "chat@ja13.org";
}
