defmodule IntersectionController.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      {
        DynamicSupervisor,
        name: IntersectionController.MainSupervisor, strategy: :one_for_one
      },
      {Task,
       fn ->
         IntersectionController.initialize(
           Application.fetch_env!(:intersection_controller, :team_numbers),
           Application.fetch_env!(:intersection_controller, :topics),
           Application.fetch_env!(:intersection_controller, :traffic_model)
         )
       end}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_all, name: IntersectionController.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
