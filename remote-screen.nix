# The job search screen: a separate virtual display (:1) where the job search Chrome runs,
# viewable over Tailscale for solving CAPTCHAs the application agent hands over
# (~/Projects/claire-job-proj, phase 6).
#
# Your real desktop (:0) is never shared. Only display :1 is, and the only thing on it is the
# job search Chrome (its own data folder: ~/.local/share/chrome-jobsearch, started by
# ~/Projects/claire-job-proj/bin/jobsearch-chrome).
#
#   Xvfb :1      virtual display, no physical screen
#   x11vnc       shares :1 only, on localhost only
#   noVNC        web viewer on the Tailscale address, port 6080
#
#   Open:      http://nixos.tailefd4ab.ts.net:6080/vnc.html?autoconnect=1&resize=scale
#   Password:  ~/.vnc/passwd (set with: x11vnc -storepasswd ~/.vnc/passwd; VNC uses max 8 chars)
{ pkgs, ... }:
let
  tailscaleIp = "100.115.213.110";
  display = ":1";
in
{
  environment.systemPackages = [ pkgs.x11vnc pkgs.novnc ];

  systemd.user.services.jobscreen-display = {
    description = "Virtual display ${display} for the job search Chrome";
    wantedBy = [ "default.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.xvfb}/bin/Xvfb ${display} -screen 0 1366x1000x24 -nolisten tcp";
      Restart = "always";
      RestartSec = 5;
    };
  };

  systemd.user.services.x11vnc = {
    description = "Share the job search display (${display}) over VNC, localhost only";
    wantedBy = [ "default.target" ];
    after = [ "jobscreen-display.service" ];
    bindsTo = [ "jobscreen-display.service" ];
    unitConfig.StartLimitIntervalSec = 0;
    serviceConfig = {
      ExecStart = "${pkgs.x11vnc}/bin/x11vnc -display ${display} -localhost -rfbport 5900 -rfbauth %h/.vnc/passwd -forever -shared -noxdamage -quiet";
      Restart = "always";
      RestartSec = 5;
    };
  };

  systemd.user.services.novnc = {
    description = "noVNC web viewer for the job search display (Tailscale address only)";
    wantedBy = [ "default.target" ];
    after = [ "x11vnc.service" ];
    path = [ pkgs.procps pkgs.coreutils pkgs.gnugrep pkgs.gnused ]; # the novnc wrapper script calls ps
    unitConfig.StartLimitIntervalSec = 0;
    serviceConfig = {
      # Binds to the Tailscale address only; retries until Tailscale is up after boot.
      ExecStart = "${pkgs.novnc}/bin/novnc --listen ${tailscaleIp}:6080 --vnc localhost:5900 --file-only";
      Restart = "always";
      RestartSec = 10;
    };
  };

  # Open 6080 on the Tailscale interface only.
  networking.firewall.interfaces.tailscale0.allowedTCPPorts = [ 6080 ];
}
