# Prior art

Hermes Agent now publishes an official container image and Docker guide. The official layout makes `/opt/data` the durable profile root and recommends one container and one data directory per independent agent. Hermes Box follows that contract instead of forking or reinstalling Hermes.

- Official Docker guide: https://github.com/NousResearch/hermes-agent/blob/main/website/docs/user-guide/docker.md
- Official image: https://hub.docker.com/r/nousresearch/hermes-agent
- Official profiles guide: https://hermes-agent.nousresearch.com/docs/user-guide/profiles/

The upstream image does not provide a general headed Linux desktop, macOS resource presets, per-instance noVNC, reset/clone/owner migration, or launchd reconciliation. Those are the wrapper's scope.
