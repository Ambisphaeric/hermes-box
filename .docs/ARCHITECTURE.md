# Architecture

The image extends the official Hermes Agent image with XFCE, TigerVNC, noVNC, and Supervisor. The official entrypoint remains first in the boot chain; it initializes `/opt/data`, fixes ownership, drops to the unprivileged `hermes` user, starts the optional dashboard, then launches Supervisor. Supervisor keeps only the desktop, web VNC proxy, and soft disk monitor alive.

The host-facing trust boundary is deliberately narrow: three loopback TCP ports and one bind mount beneath this repository. A PID ceiling, RAM/CPU limits, and no Docker socket reduce blast radius. The official entrypoint briefly needs root capabilities to map the container account to the macOS owner, then drops privileges before Hermes starts. The desktop user has passwordless `sudo` inside the container for appliance administration; that privilege does not cross Docker's boundary. This is stronger application isolation than a native install, but weaker than a separate VM kernel.

Persistence is directory-based so it is transparent, copyable, backup-friendly, and independent of Docker's internal volume database. Clone stops the source before copying to avoid torn SQLite/session files. A future restore command can add checksummed archives without changing the storage contract.

One checkout manages multiple appliances. Each `.instances/<name>/instance.env` is both its Compose identity and private operator configuration; `.instances/<name>/data` is its durable filesystem. The `.env` symlink only selects the default. Explicit `--instance` operations never depend on that mutable selection, which makes launchd and scripts deterministic.

“Smart cron” is two layers: Docker restart policy for container/process recovery, and optional user LaunchAgent reconciliation for declarative recovery. Health checks make degraded UI state visible. The keeper is intentionally simple and deterministic rather than an AI loop.

The default 10 GB value is a warning threshold. Portable Docker on macOS cannot enforce or shrink an individual bind-mounted directory. Docker Desktop/OrbStack manage their Linux VM disk globally. Hard per-instance quotas would require a host sparse image or a privileged loopback filesystem, both of which complicate portability and recovery and are deferred.
