defmodule MiewWeb.Router do
  use MiewWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {MiewWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", MiewWeb do
    pipe_through :browser

    live "/", DashboardLive
    live "/dash", DashboardLive

    live "/deck/new", NewDeckLive
    live "/deck/list", DeckListLive
    live "/deck/:id", DeckLive
    live "/deck/:id/results", DeckResultsLive
    live "/deck/:id/rank", DeckRankLive
    live "/deck/:id/rank/adjust", DeckRankAdjustLive

    live "/player/new", NewPlayerLive

    live "/match/new", NewMatchLive
    live "/match/list", MatchListLive
    live "/match/:id", MatchLive

    live "/:type/:id/state", StateLive
    live "/:type/:id/log", LogLive

    live "/log/:limit", LogLive

    live "/tag/add", AddTagLive

    live "/load/decks", ParseDecksLive
    live "/load/games", ParseGamesLive
    live "/export", ExportLive
  end

  # Other scopes may use custom stacks.
  # scope "/api", MiewWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: MiewWeb.Telemetry
    end
  end
end
