# Hermes Box

A reproducible, headed Linux appliance for [Nous Research Hermes Agent](https://github.com/NousResearch/hermes-agent), aimed at macOS users who want VPS-like isolation without managing UTM. It adds an XFCE desktop, VNC/noVNC, local-only ports, persistent instance state, resource presets, health checks, and a small operator CLI around the official Hermes image.

This is container isolation, not a full VM boundary. The Linux kernel belongs to Docker Desktop/OrbStack, and a container escape would cross this boundary. Hermes Box does not mount the Docker socket or your home directory.

## Quick start

Requirements: Apple Silicon or Intel Mac, Docker Desktop or OrbStack, and Docker Compose v2.

```sh
./manager init light
./manager up
./manager setup
open "$(./manager url)"
```

The desktop and Hermes dashboard bind only to localhost. `init` generates the VNC password in `.env` (classic VNC authentication uses only eight characters). The desktop shortcut opens the Hermes TUI. Instance state—including configuration, credentials, sessions, memories, skills, workspace, and any file-backed database under `/opt/data`—lives in `.instances/<name>/data` and survives rebuilds and container replacement.

## Presets

| Preset | RAM | CPU ceiling | Default ports |
|---|---:|---:|---|
| light | 2 GB | 2 | 5901 / 6081 / 9119 |
| medium | 4 GB | 4 | 5902 / 6082 / 9120 |
| high | 8 GB | 6 | 5903 / 6083 / 9121 |

`./manager set MEMORY 20g` and `./manager set CPUS 8` are valid overrides. This is system RAM, not VRAM; Docker cannot allocate Apple GPU VRAM to a Linux container as if it were a CUDA VPS.

Disk is intentionally a soft, observable budget (`DISK_BUDGET_GB`, default 10), not a fake fixed disk. Docker bind mounts grow with available macOS storage and do not offer a portable per-volume shrink operation. `./manager disk` reports use. Decreasing the budget never destroys data. For a hard disk ceiling, use a separately managed sparse disk image or a VM; that is outside the portable 1.0 contract.

## Commands:

```text
./manager init light|medium|high [NAME]  Create local config and blank state
./manager up                              Build/start; safe to repeat
./manager stop | start | down             Lifecycle controls
./manager status | logs | shell           Datacenter-style operations
./manager setup                           Run the Hermes setup wizard
./manager url                             Print the noVNC URL
./manager disk                            Show persistence use/budget
./manager set MEMORY 4g                   Change an allowed setting
./manager clone NEW_NAME                  Stop and copy consistent state
./manager reset --yes                     Destroy state and make a blank appliance
./manager watchdog-install                Install a per-user macOS launchd keeper
./manager watchdog-remove                 Remove it
```

Docker's `restart: unless-stopped` handles process crashes and Docker restarts. The optional launchd keeper calls the idempotent `up` command every minute and at login, covering a missing container after Docker becomes available. It cannot start a Docker engine the user has disabled.

## Three independent Hermes instances

Clone this template into three directories (or use three Git worktrees), run `init light`, `init medium`, and `init high`, and choose unique names/ports. Never point two running Hermes containers at the same data directory. To test a clean “new DVD,” run `./manager reset --yes`; to preserve and duplicate an appliance, use `clone` while it is stopped.

## Status

This is an MVP template, not yet a claimed cross-platform 1.0. The design follows the official one-container/one-`/opt/data` recommendation. See [.docs/ARCHITECTURE.md](.docs/ARCHITECTURE.md) and [.docs/TESTING.md](.docs/TESTING.md) for decisions and exact verification evidence. Publishing to GitHub is deliberately not automatic: the Docker Desktop/Intel and visual interaction checks remain, and an owner/repository name must be selected.
