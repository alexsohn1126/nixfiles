{ config, pkgs, lib, ... }:

let 
  overpass-api = pkgs.callPackage ./overpass.nix {};
  overpass-api-path = toString overpass-api;
  instanceName = "overpass";
in 
{
  users.users.${config.services.nginx.user} = {
    isSystemUser = true;
    group = config.services.nginx.group;
    extraGroups = [ "overpass"];
  };
  users.groups.${config.services.nginx.group} = {};
  users.groups.overpass = {};

  # Configure isolated fcgiwrap instance
  services.fcgiwrap.instances.${instanceName} = {
    socket = {
      type = "unix";
      address = "/run/fcgiwrap-${instanceName}.sock";
      user = config.services.nginx.user;    # Must match nginx user
      group = "overpass"; # Must match nginx group
      mode = "0666";     # Allow nginx user/group access
    };
    process = {
      user = config.services.nginx.user;    # Run fcgiwrap as nginx user
      group = "overpass"; # Run fcgiwrap as nginx group
      prefork = 4;       # Number of worker processes
    };
  };

  # Configure Nginx
  services.nginx.enable = true;
  systemd.services.nginx.serviceConfig.ProtectHome = "read-only";
  services.nginx.virtualHosts."overpass" = {
    locations."/api/" = {
    alias = "${overpass-api-path}/cgi-bin/";
    extraConfig = ''
      fastcgi_pass unix:${config.services.fcgiwrap.instances.${instanceName}.socket.address};
      include ${config.services.nginx.package}/conf/fastcgi_params;
      fastcgi_param SCRIPT_FILENAME $request_filename;
    '';
    };
  };
}
