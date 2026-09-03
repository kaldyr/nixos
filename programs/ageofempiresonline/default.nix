{
  boot.kernel.sysctl."net.ipv4.ip_unprivileged_port_start" = 1000; # AoeO
  networking.firewall.allowedUDPPortRanges = [ { from = 1000; to = 1005; } ]; # AoeO
}
