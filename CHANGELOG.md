# Changelog

## [Unreleased]

### Added

- `phone_preview` starts the app's server and an ngrok tunnel on one port, and prints the public address and a QR code of it.
- With no `PORT` set, `phone_preview` starts on port 3000.
- In development, emailed links use `PUBLIC_BASE_URL` over https with no port when it is set.
