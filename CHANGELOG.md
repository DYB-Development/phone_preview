# Changelog

## [Unreleased]

### Added

- `phone_preview` says ngrok is not installed, or not signed in to an account, and starts nothing.
- `phone_preview` names a port already in use, or an address already held by another running tunnel, and starts nothing.
- When the tunnel stops while the app runs, the terminal says the phone can no longer reach the app.

## [0.1.0] - 2026-10-22

### Added

- `phone_preview` starts the app's server and an ngrok tunnel on one port, and prints the public address and a QR code of it.
- With no `PORT` set, `phone_preview` starts on port 3000.
- In development, emailed links use `PUBLIC_BASE_URL` over https with no port when it is set.
