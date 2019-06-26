defmodule IntersectionController.Processor do
  @moduledoc """
  Manages traffic state.
  """

  use GenServer
  require Logger

  def start_link(opts) do
    traffic_model = Keyword.fetch!(opts, :traffic_model)
    GenServer.start_link(__MODULE__, traffic_model, opts)
  end

  def set_sensor(server, group, sensor, state) do
    GenServer.call(server, {:set_sensor, group, sensor, state})
  end

  def get_sensor(server, sensor) do
    GenServer.call(server, {:get_sensor, sensor})
  end

  def reset_and_get_initial_state(server) do
    traffic_model = GenServer.call(server, {:initial_state})

    for {group_name, group} <- traffic_model do
      IntersectionController.TrafficModel.messages_from_group(group_name, group, :initial)
    end
    |> List.flatten()
  end

  def get_solution(server) do
    GenServer.call(server, {:solution})
  end

  def stop(server) do
    GenServer.stop(server)
  end

  def init(traffic_model) do
    sensors = %{}
    queue = :queue.new()
    {:ok, {traffic_model, sensors, queue}}
  end

  @spec handle_call(
          {:set_sensor, String.t(), String.t(), boolean},
          {pid, any},
          {map, map, :queue.queue()}
        ) ::
          {:reply, :ok, {map, map, :queue.queue()}}
  def handle_call({:set_sensor, group, sensor, state}, _from, {traffic_model, sensors, queue}) do
    sensor_states =
      Map.put_new(sensors, group, %{})
      |> Map.fetch!(group)
      |> Map.put(sensor, state)

    sensors = Map.put(sensors, group, sensor_states)

    # Add received sensor to queue if it's been turned on and isn't present in the queue yet.
    queue =
      if state and Map.has_key?(traffic_model, group) and not :queue.member(group, queue) and
           not String.contains?(group, "bridge") do
        :queue.in(group, queue)
      else
        queue
      end

    {:reply, :ok, {traffic_model, sensors, queue}}
  end

  @spec handle_call(
          {:get_sensor, String.t()},
          {pid, any},
          {map, map, :queue.queue()}
        ) ::
          {:reply, boolean, {map, map, :queue.queue()}}
  def handle_call({:get_sensor, sensor}, _from, {traffic_model, sensors, queue}) do
    activated = IntersectionController.TrafficModel.sensor_activated?(sensors, sensor)
    {:reply, activated, {traffic_model, sensors, queue}}
  end

  @spec handle_call(
          {:initial_state},
          {pid, any},
          {map, map, :queue.queue()}
        ) ::
          {:reply, map, {map, map, :queue.queue()}}
  def handle_call({:initial_state}, _from, {traffic_model, _sensors, _queue}) do
    # Empty all interal state and pass the traffic model to the client, so it can generate MQTT messages from it.
    sensors = %{}
    queue = :queue.new()
    {:reply, traffic_model, {traffic_model, sensors, queue}}
  end

  @spec handle_call(
          {:solution},
          {pid, any},
          {map, map, :queue.queue()}
        ) ::
          {:reply, map, {map, map, :queue.queue()}}
  def handle_call({:solution}, _from, {traffic_model, sensors, queue}) do
    {solution, queue} =
      IntersectionController.TrafficModel.get_solution(queue, sensors, traffic_model, [], [], %{})

    {:reply, solution, {traffic_model, sensors, queue}}
  end

  @spec handle_info(any, tuple) :: {:noreply, tuple}
  def handle_info(_msg, state) do
    {:noreply, state}
  end
end
