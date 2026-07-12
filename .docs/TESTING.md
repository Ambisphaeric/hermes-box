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
- PASS: container ports inspect as loopback-only; mount inspection shows only the repository instance data directory.
- PASS: inspect proves 2 GiB/2 CPU limits and `unless-stopped`; changing `MEMORY` to `4g` recreated it with `4294967296` bytes.
- PASS: a workspace marker survived `compose down` followed by image rebuild/container recreation.
- PASS: a stopped instance clone retained its marker and diverged independently after a clone-only write.
- PASS: killing Supervisor inside the container produced `RestartCount=1` and returned to `healthy`.
- PASS: the Hermes runtime UID can write the persistent workspace.
- NOT RUN: browser-visible desktop/VNC login interaction because the in-app browser was unavailable; HTTP and process-level checks passed.
- NOT RUN: Docker Desktop, macOS amd64, reset, launchd reconciliation, or Hermes provider setup (requires user credentials).
