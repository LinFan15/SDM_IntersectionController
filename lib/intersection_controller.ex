defmodule IntersectionController do
  @moduledoc """
  Initializes and runs the main application loop for every registered simulator.
  """
  require Logger

  @doc """
  Initializes the application.
  """
  @spec initialize(list(integer), list(String.t()), map) :: list({:ok, pid})
  def initialize(group_numbers, topics, traffic_model) do
    # Start a new TeamSupervisor for every registered simulator.
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

  @doc """
  The main application loop. There is a seperate instance of this function running for every registered simulator.
  """
  @spec loop(integer, atom, atom, atom, list(String.t())) :: no_return
  def loop(teamnr, message_handler, task_supervisor, processor, associated_running) do
    # Process associated group lifecycle messages from the handle_traffic_group function.
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

    # Solution will be empty when there are no traffic groups left in the queue in the Processor process.
    if solution != %{} do
      :logger.info(Map.keys(solution) |> Enum.join(" "))
      pid = self()

      # Start a new process to handle each traffic group.
      # Ignore traffic group if any of it's associated groups are still running.
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

      # Wait for all spawned processes to finish.
      Task.yield_many(tasks, :infinity)
      loop(teamnr, message_handler, task_supervisor, processor, associated_running)
    else
      Logger.info("Waiting for simulator for team nr. #{teamnr}")
      loop(teamnr, message_handler, task_supervisor, processor, associated_running)
    end
  end
end
