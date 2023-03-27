defmodule LinkedinResponse.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      LinkedinResponseWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: LinkedinResponse.PubSub},
      # Start Finch
      {Finch, name: LinkedinResponse.Finch},
      # Start the Endpoint (http/https)
      LinkedinResponseWeb.Endpoint

      # Start a worker by calling: LinkedinResponse.Worker.start_link(arg)
      # {LinkedinResponse.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: LinkedinResponse.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    LinkedinResponseWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
