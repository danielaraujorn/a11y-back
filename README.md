# AccessibilityReporter

Prerequisites to run this project:

* Install `docker` and `docker-compose` in your machine
* Install `elixir` and `erlang` with `asdf` in your machine
  
To start docker containers:

* Run `docker-compose up -d`

To start your Phoenix server:

* Install dependencies with `mix deps.get`
* Create and migrate your database with `mix ecto.setup`
* Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`
  
Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

To see server routers:

* Run `mix phx.routes`

To see mailbox:

* You can visit [`localhost:4000/dev/mailbox`](http://localhost:4000/dev/mailbox/) from your browser.

Tip: If you have problems with network ports (http), you can run `sudo fuser -k port/tcp` whenever necessary.
