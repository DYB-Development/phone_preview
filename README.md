# phone_preview

Opens a Rails app running on your Mac on a phone, through an ngrok tunnel at a
fixed public address.

`phone_preview` starts the app's server and an ngrok tunnel on one port, prints
the public address and a QR code of it to scan with the phone's camera, and in
development makes emailed links use that address so they open on the phone.

## Requirements

- An ngrok account with a reserved domain for the app, such as
  `app-dev.ngrok.app`, and the `ngrok` command signed in to that account.
- `overmind`, which runs the server and the tunnel together.

## Installing

Add the gem to the app's development group:

```ruby
group :development do
  gem "phone_preview"
end
```

Give the app a `bin/phone` that names its public address and runs the gem's
command:

```sh
#!/usr/bin/env sh

export PUBLIC_BASE_URL="${PUBLIC_BASE_URL:-https://app-dev.ngrok.app}"

exec bundle exec phone_preview "$@"
```

## Using it

Run `bin/phone`, or `up phone` from symphony, which picks the first free port.
Open the printed address on the phone, or scan the QR code.

With no `PORT` set, the server starts on port 3000.

When `PUBLIC_BASE_URL` is set in development, emailed links use it over https
with no port. With it unset, or outside development, emailed links keep the
app's own `action_mailer.default_url_options`.

Live connections through Action Cable need no setting, because Rails accepts a
connection whose origin matches the address the request arrives on.
