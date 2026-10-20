# Pulls the server's nightly database dumps (/srv/backups, read-only through rrsync) into
# ~/Backups/server, checks each project's newest dump and pings its healthchecks.io check:
# healthchecks.io alerts (Signal) when a ping says it failed or stops coming at all; a desktop
# notification shows when the pull fails while you're logged in.
#
# Needs, outside the Nix store:
#   ~/.ssh/backup_pull_ed25519              the key restricted on the server
#   ~/.config/backup-pull/env               (0600) the server and a ping URL per project:
#                                           BACKUP_SERVER=<user>@<address>
#                                           HC_GLEANER=https://hc-ping.com/<uuid>
{
  config,
  lib,
  pkgs,
  ...
}:

let
  key = "${config.home.homeDirectory}/.ssh/backup_pull_ed25519";
  dest = "${config.home.homeDirectory}/Backups/server";
  # The server keeps 14 days; the desktop keeps its own copies this long.
  keepDays = 365;

  # A folder under /srv/backups each, with what its newest dump must be like. Each needs its
  # HC_<NAME> line (upper case, - as _) in ~/.config/backup-pull/env.
  projects = {
    gleaner = {
      pattern = "gleaner-*.dump";
      minBytes = 4096;
      maxAgeHours = 36;
    };
  };

  report =
    name: p:
    "report ${
      lib.escapeShellArgs [
        name
        p.pattern
        (toString p.minBytes)
        (toString p.maxAgeHours)
      ]
    }";

  backupPull = pkgs.writeShellApplication {
    name = "backup-pull";
    runtimeInputs = with pkgs; [
      rsync
      openssh
      postgresql_17 # pg_restore --list, as new as the server's pg_dump
      curl
      coreutils
      findutils
    ];
    text = ''
      server="''${BACKUP_SERVER:?no BACKUP_SERVER in ~/.config/backup-pull/env}"
      dest=${lib.escapeShellArg dest}
      mkdir -p "$dest"
      chmod 700 "$dest"

      # No --delete: copies outlive the server's 14 days. The network may not be up yet right
      # after boot (the timer catching up), hence the retries.
      pulled=false
      for attempt in 1 2 3; do
        if rsync --recursive --times --chmod=D700,F600 --exclude='*.partial' \
          -e "ssh -i ${key} -o IdentitiesOnly=yes -o BatchMode=yes -o ConnectTimeout=30" \
          "$server":./ "$dest/"; then
          pulled=true
          break
        fi
        echo "pull attempt $attempt failed" >&2
        if [ "$attempt" -lt 3 ]; then sleep 60; fi
      done

      # Project, "" or "/fail", message.
      hc_ping() {
        local name="''${1^^}"
        local var="HC_''${name//-/_}"
        local url="''${!var:-}"
        if [ -z "$url" ]; then
          echo "$1: no $var in ~/.config/backup-pull/env" >&2
          return 1
        fi
        curl -fsS -m 10 --retry 5 --data-raw "$3" "$url$2" >/dev/null || echo "$1: ping failed" >&2
      }

      # Project, file pattern, minimum bytes, maximum age in hours. Says what's wrong, or what's
      # there.
      check() {
        local newest size age
        newest=$(find "$dest/$1" -maxdepth 1 -type f -name "$2" -printf '%T@ %p\n' 2>/dev/null | sort -n | tail -n 1 | cut -d' ' -f2-)
        if [ -z "$newest" ]; then
          echo "no dump matching $2"
          return 1
        fi
        size=$(stat -c %s "$newest")
        age=$((($(date +%s) - $(stat -c %Y "$newest")) / 3600))
        if [ "$size" -lt "$3" ]; then
          echo "$(basename "$newest") is only $size bytes"
          return 1
        fi
        if [ "$age" -ge "$4" ]; then
          echo "the newest dump, $(basename "$newest"), is $age hours old"
          return 1
        fi
        if ! pg_restore --list "$newest" >/dev/null 2>&1; then
          echo "pg_restore can't read $(basename "$newest")"
          return 1
        fi
        echo "$(basename "$newest"): $size bytes, $age hours old"
      }

      failed=0
      report() {
        local msg
        if [ "$pulled" != true ]; then
          msg="couldn't pull from the server"
        elif msg=$(check "$@"); then
          echo "$1: $msg"
          hc_ping "$1" "" "$msg" || failed=1
          return
        fi
        echo "$1: $msg" >&2
        hc_ping "$1" /fail "$msg" || true
        failed=1
      }

      ${lib.concatStringsSep "\n" (lib.mapAttrsToList report projects)}

      find "$dest" -type f -name '*.dump' -mtime +${toString keepDays} -delete
      exit "$failed"
    '';
  };
in
{
  systemd.user.services.backup-pull = {
    Unit = {
      Description = "Pull the server's database dumps";
      OnFailure = [ "backup-pull-failed.service" ];
    };
    Service = {
      Type = "oneshot";
      # Missing, the unit fails (and notifies) rather than quietly skipping the pings.
      EnvironmentFile = "%h/.config/backup-pull/env";
      ExecStart = lib.getExe backupPull;
    };
  };

  systemd.user.services.backup-pull-failed = {
    Unit.Description = "Tell that pulling the server's dumps failed";
    Service = {
      Type = "oneshot";
      ExecStart = "${lib.getExe' pkgs.libnotify "notify-send"} --urgency=critical --app-name=backup-pull 'Backup pull failed' 'journalctl --user -u backup-pull'";
    };
  };

  # The server dumps at 03:30.
  systemd.user.timers.backup-pull = {
    Unit.Description = "Pull the server's database dumps daily";
    Timer = {
      OnCalendar = "*-*-* 05:00:00";
      Persistent = true;
      RandomizedDelaySec = "15m";
    };
    Install.WantedBy = [ "timers.target" ];
  };
}
