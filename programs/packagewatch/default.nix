{
  pkgs,
  ...
}:
let
  watchList = [
    {
      attr = "brotli";
      minimum = "1.2.1";
    }
    {
      attr = "ffmpeg";
      minimum = "9.0.3";
    }
    {
      attr = "sqlite";
      minimum = "3.54.1";
    }
  ];

  checkPackages = pkgs.writeShellApplication {
    name = "check-nixpkgs-packages";

    runtimeInputs = with pkgs; [
      nix
      coreutils
      gnused
      jq
      libnotify
    ];

    text = ''
      state_dir="''${XDG_STATE_HOME:-$HOME/.local/state}/nixpkgs-watch"
      mkdir -p "$state_dir"

      # Refresh master and evaluate all packages together.
      if ! results=$(nix eval --refresh --impure --json --expr '
        let
          flake = builtins.getFlake "github:NixOS/nixpkgs/master";
          packages = import flake.outPath {
            system = "${pkgs.stdenv.hostPlatform.system}";
          };
          lib = packages.lib;
          watches = builtins.fromJSON ${builtins.toJSON (builtins.toJSON watchList)};
        in
          map (watch:
            let
              path = lib.splitString "." watch.attr;
              found = lib.hasAttrByPath path packages;
            in
              watch // {
                current =
                  if found
                  then (lib.getAttrFromPath path packages).version
                  else null;
              }
          ) watches
      '); then
        echo "Failed to evaluate nixpkgs master" >&2
        exit 1
      fi

      # Process results without additional Nix evaluations.
      while IFS=$'\t' read -r attr minimum current; do
        if [[ -z "$current" ]]; then
          echo "$attr: package not found" >&2
          continue
        fi

        echo "$attr: $current (target: $minimum)"

        key=$(printf '%s:%s' "$attr" "$minimum" |
          sha256sum | cut -d' ' -f1)
        marker="$state_dir/$key"

        if [[ -e "$marker" ]]; then
          continue
        fi

        if printf '%s\n' "$minimum" "$current" | sort -V -C; then
          if notify-send \
            "Nixpkgs package updated" \
            "$attr $current is available (target: $minimum)"; then
            touch "$marker"
          fi
        fi
      done < <(
        printf '%s' "$results" |
          jq -r '.[] | [.attr, .minimum, (.current // "")] | @tsv'
      )
    '';
  };
in
{
  systemd.user = {
    services.nixpkgs-watch = {
      description = "Check nixpkgs package versions";

      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${checkPackages}/bin/check-nixpkgs-packages";
      };
    };

    timers.nixpkgs-watch = {
      description = "Daily nixpkgs package version check";

      wantedBy = [ "timers.target" ];

      timerConfig = {
        OnCalendar = "daily";
        Persistent = true;
        RandomizedDelaySec = "30min";
        Unit = "nixpkgs-watch.service";
      };
    };
  };
}
