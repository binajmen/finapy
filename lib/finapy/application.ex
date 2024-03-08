defmodule Finapy.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      FinapyWeb.Telemetry,
      Finapy.Repo,
      {DNSCluster, query: Application.get_env(:Finapy, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Finapy.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Finapy.Finch},
      # Start a worker by calling: Finapy.Worker.start_link(arg)
      # {Finapy.Worker, arg},
      # Start to serve requests, typically the last entry
      FinapyWeb.Endpoint
    ]

    Corsica.Telemetry.attach_default_handler(log_levels: [rejected: :error])

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Finapy.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    FinapyWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
