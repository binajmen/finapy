defmodule FinapyWeb.Router do
  use FinapyWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug FinapyWeb.Plugs.Ory, "en"
  end

  scope "/api", FinapyWeb do
    pipe_through :api
    resources "/categories", CategoryController, except: [:new, :edit]
  end

  # Enable Swoosh mailbox preview in development
  if Application.compile_env(:Finapy, :dev_routes) do
    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
