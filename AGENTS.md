# Maintainer instructions

- Keep all instance state under `.instances/`; never mount the Docker socket or arbitrary host directories.
- Bind every UI port to `127.0.0.1`. Treat dashboard and VNC access as sensitive.
- Preserve the official Hermes entrypoint so ownership, config bootstrap, skills, and privilege dropping keep working.
- Test lifecycle and persistence before claiming a release is ready. Record results in `.docs/TESTING.md`.
- Do not commit `.env`, credentials, auth files, or `.instances/`.
