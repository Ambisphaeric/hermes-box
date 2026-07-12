# Verification record

Tests should be rerun on both Docker Desktop and OrbStack before calling the release broadly portable.

## Required release checks

- Build on macOS arm64 and amd64.
- `up`, health transition, noVNC page, VNC authentication, dashboard, and Hermes TUI.
- Confirm RAM/CPU limits via `docker inspect` and `docker stats`.
- Write a marker under `/opt/data/workspace`, run `down` then `up`, and confirm it remains.
- Clone while stopped and confirm source and clone diverge after subsequent writes.
- Reset and confirm prior state is absent and Hermes bootstraps fresh state.
- Change 2 GB to 4 GB and confirm the container is recreated with the new limit.
- Kill PID 1 and verify Docker restart policy recovers it.
- Install launchd keeper, remove the container, and verify reconciliation after Docker is ready.
- Confirm all published ports resolve to `127.0.0.1` and no host/Docker socket is mounted.

## Current evidence

Test host: macOS arm64, OrbStack Docker Engine 29.4.0, Compose v2.

- PASS: image builds from the current official `nousresearch/hermes-agent:latest` digest.
- PASS: official entrypoint initialized bundled skills and mapped Hermes to the host account IDs.
- PASS: Supervisor reports desktop/noVNC running; direct health check passes and Docker reports `healthy`.
- PASS: noVNC `GET /vnc.html` and Hermes dashboard `GET /` return successfully.
- PASS: authenticated VNC capture produced a 1440×900 XFCE desktop; a remote double-click opened the desktop shortcut into a live Hermes TUI.
- PASS: container ports inspect as loopback-only; mount inspection shows only the repository instance data directory.
- PASS: inspect proves 2 GiB/2 CPU limits and `unless-stopped`; changing `MEMORY` to `4g` recreated it with `4294967296` bytes.
- PASS: a `20g` user override recreated high with a `21474836480` byte ceiling; restoring the 8 GiB preset also succeeded.
- PASS: changing the soft disk budget to 25 GiB reached the container environment, and returning it to 10 GiB did not alter data.
- PASS: a workspace marker survived `compose down` followed by image rebuild/container recreation.
- PASS: a stopped instance clone retained its marker and diverged independently after a clone-only write.
- PASS: killing Supervisor inside the container produced `RestartCount=1` and returned to `healthy`.
- PASS: the Hermes runtime UID can write the persistent workspace.
- PASS: light, medium, and high ran concurrently with separate 2/4/8 GiB limits, names, loopback ports, health states, and persistence directories.
- PASS: reset removed an old-state marker and the next boot generated fresh Hermes configuration and identity files.
- PASS: a temporary UID/GID migration and return migration preserved a marker and runtime write access.
- PASS: a user LaunchAgent recreated a deliberately removed high container, then uninstalled cleanly.
- PASS: the supervised gateway connected to Telegram in polling mode, registered bot commands, and remained part of the container health check.
- PASS: OpenAI Codex authentication completed a live `gpt-5.6-luna` request with medium reasoning and returned the expected test response.
- NOT RUN: Docker Desktop, macOS amd64, or Hermes provider setup (requires user credentials).
