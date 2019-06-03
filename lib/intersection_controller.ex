defmodule IntersectionController do
  require Logger

  def initialize(group_numbers, topics, traffic_model) do
    for n <- group_numbers do
      {:ok, _pid} =
        DynamicSupervisor.start_child(
          IntersectionController.MainSupervisor,
          {
            IntersectionController.TeamSupervisor,
            name: String.to_atom("IntersectionController.TeamSupervisor#{n}"),
            teamnr: n,
            topics: topics,
            traffic_model: traffic_model
          }
        )
    end
  end

  def loop(teamnr, message_handler, task_supervisor, processor, associated_running) do
    associated_running =
      receive do
        {:associated_started, groups} ->
          groups ++ associated_running

        {:associated_stopped, group} ->
          Enum.filter(associated_running, fn associated_group -> associated_group != group end)
      after
        1000 ->
          associated_running
      end

    solution = IntersectionController.Processor.get_solution(processor)

    if solution != %{} do
      :logger.info(Map.keys(solution) |> Enum.join(" "))
      pid = self()

      tasks =
        for {group, group_map} <- solution,
            not IntersectionController.TrafficModel.associated_running?(
              group_map.associated,
              associated_running
            ) do
          Task.Supervisor.async(
            task_supervisor,
            fn ->
              IntersectionController.TrafficHandler.handle_traffic_group(
                message_handler,
                task_supervisor,
                processor,
                pid,
                group,
                group_map
              )
            end
          )
        end

      Task.yield_many(tasks, :infinity)
      loop(teamnr, message_handler, task_supervisor, processor, associated_running)
    else
      Logger.info("Waiting for simulator for team nr. #{teamnr}")
      loop(teamnr, message_handler, task_supervisor, processor, associated_running)
    end
  end
end
