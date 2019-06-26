defmodule IntersectionController.TeamSupervisor do
  @moduledoc """
  Supervises all processes required to control a single simulator.
  """
  use Supervisor

  def start_link(opts) do
    name = Keyword.fetch!(opts, :name)
    Supervisor.start_link(__MODULE__, opts, name: name)
  end

  def init(opts) do
    # Get configuration parameters
    teamnr = Keyword.fetch!(opts, :teamnr)
    topics = Keyword.fetch!(opts, :topics)
    traffic_model = Keyword.fetch!(opts, :traffic_model)

    subscriptions =
      for topic <- topics do
        {"#{teamnr}#{topic}", 1}
      end

    children = [
      {
        IntersectionController.Processor,
        name: String.to_atom("IntersectionController.Processor#{teamnr}"),
        traffic_model: traffic_model
      },
      {
        IntersectionController.MQTTMessageHandler,
        name: String.to_atom("IntersectionController.MQTTMessageHandler#{teamnr}"),
        processor: String.to_atom("IntersectionController.Processor#{teamnr}"),
        clientid: "ExMQTT-#{teamnr}",
        teamnr: teamnr
      },
      {Tortoise.Connection,
       [
         client_id: "ExMQTT-#{teamnr}",
         server: {
           Tortoise.Transport.SSL,
           host: 'broker.0f.nl', port: 8883, cacertfile: :certifi.cacertfile()
         },
         handler:
           {IntersectionController.MQTTHandler,
            [teamnr, String.to_atom("IntersectionController.MQTTMessageHandler#{teamnr}")]},
         subscriptions: subscriptions,
         will: %Tortoise.Package.Publish{
           topic: "#{teamnr}/features/lifecycle/controller/ondisconnect",
           payload: "",
           qos: 1
         }
       ]},
      {
        Task.Supervisor,
        name: String.to_atom("IntersectionController.TaskSupervisor#{teamnr}"),
        strategy: :one_for_one
      },
      Supervisor.child_spec(
        {Task,
         fn ->
           IntersectionController.loop(
             teamnr,
             String.to_atom("IntersectionController.MQTTMessageHandler#{teamnr}"),
             String.to_atom("IntersectionController.TaskSupervisor#{teamnr}"),
             String.to_atom("IntersectionController.Processor#{teamnr}"),
             []
           )
         end},
        restart: :permanent
      )
    ]

    Supervisor.init(children, strategy: :one_for_all)
  end
end
