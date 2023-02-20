defmodule RelayWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :relay

  @ping_timeout Application.compile_env(:relay, :ping_timeout, 30_000)
  @connection_timeout Application.compile_env(:relay, :connection_timeout, 60_000)

  # The session will be stored in the cookie and signed,
  # this means its contents can be read but not tampered with.
  # Set :encryption_salt if you would also like to encrypt it.
  @session_options [
    store: :cookie,
    key: "_relay_key",
    signing_salt: "02v94M05",
    same_site: "Lax"
  ]

  socket("/", RelayWeb.Sockets.RequestSocket,
    websocket: [
      path: "",
      timeout: @connection_timeout,
      ping: @ping_timeout,
      connect_info: [:peer_data, :user_agent],
      compress: true
    ],
    longpoll: false
  )

  socket("/live", Phoenix.LiveView.Socket, websocket: [connect_info: [session: @session_options]])

  # Serve at "/" the static files from "priv/static" directory.
  #
  # You should set gzip to true if you are running phx.digest
  # when deploying your static files in production.
  plug(Plug.Static,
    at: "/",
    from: :relay,
    gzip: false,
    only: RelayWeb.static_paths()
  )

  # Code reloading can be explicitly enabled under the
  # :code_reloader configuration of your endpoint.
  if code_reloading? do
    socket("/phoenix/live_reload/socket", Phoenix.LiveReloader.Socket)
    plug(Phoenix.LiveReloader)
    plug(Phoenix.CodeReloader)
    plug(Phoenix.Ecto.CheckRepoStatus, otp_app: :relay)
  end

  plug(Phoenix.LiveDashboard.RequestLogger,
    param_key: "request_logger",
    cookie_key: "request_logger"
  )

  plug(Plug.RequestId)
  plug(Plug.Telemetry, event_prefix: [:phoenix, :endpoint])

  plug(Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Phoenix.json_library()
  )

  plug(Plug.MethodOverride)
  plug(Plug.Head)
  plug(Plug.Session, @session_options)
  plug(RelayWeb.Router)
end
