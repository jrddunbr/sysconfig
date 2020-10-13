{ config, pkgs, ... }:
{
  services.nginx = {
    enable = true;
    recommendedTlsSettings = true;
    recommendedOptimisation = true;
    recommendedGzipSettings = true;
    recommendedProxySettings = true;


    services.nginx.enable = true;
      services.nginx.virtualHosts.gitea.locations."/".proxyPass = "http://127.0.0.1:3000";
      services.nginx.virtualHosts.gitea.locations."/".proxyWebsockets = true;
      services.nginx.virtualHosts.gitea.serverName = "git.ja4.org";
      services.nginx.virtualHosts.gitea.forceSSL = true;
      services.nginx.virtualHosts.gitea.enableACME = true;

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
