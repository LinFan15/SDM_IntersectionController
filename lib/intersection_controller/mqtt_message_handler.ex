defmodule IntersectionController.MQTTMessageHandler do
  use GenServer

  require Logger

  def start_link(opts) do
    processor = Keyword.fetch!(opts, :processor)
    client_id = Keyword.fetch!(opts, :clientid)
    teamnr = Keyword.fetch!(opts, :teamnr)
    GenServer.start_link(__MODULE__, {processor, client_id, teamnr}, opts)
  end

  def connected(server) do
    GenServer.cast(server, {:connected})
  end

  def onconnect(server) do
    GenServer.cast(server, {:onconnect})
  end

  def ondisconnect(server) do
    GenServer.cast(server, {:ondisconnect})
  end

  def set_sensor(server, user_type, group_id, component_id, state) do
    GenServer.cast(server, {:sensor, user_type, group_id, component_id, state})
  end

  def publish(server, messages) do
    GenServer.call(server, {:publish, messages})
  end

  def stop(server) do
    GenServer.stop(server)
  end

  def init({processor, client_id, teamnr}) do
    {:ok, {processor, client_id, teamnr}}
  end

  def handle_cast({:connected}, {processor, client_id, teamnr}) do
    Tortoise.publish(client_id, "#{teamnr}/features/lifecycle/controller/onconnect", "", qos: 1)
    {:noreply, {processor, client_id, teamnr}}
  end

  def handle_cast({:onconnect}, {processor, client_id, teamnr}) do
    groups = IntersectionController.Processor.reset_and_get_initial_state(processor)

    for {group, state} <- groups do
      Tortoise.publish(client_id, "#{teamnr}#{group}", state, qos: 1)
    end

    {:noreply, {processor, client_id, teamnr}}
  end

  def handle_cast({:ondisconnect}, {processor, client_id, teamnr}) do
    IntersectionController.Processor.reset_and_get_initial_state(processor)

    {:noreply, {processor, client_id, teamnr}}
  end

  def handle_cast(
        {:sensor, user_type, group_id, component_id, state},
        {processor, client_id, teamnr}
      ) do
    state = state == "1"

    IntersectionController.Processor.set_sensor(
      processor,
      "/#{user_type}/#{group_id}",
      "/sensor/#{component_id}",
      state
    )

    {:noreply, {processor, client_id, teamnr}}
  end

  def handle_call({:publish, messages}, _from, {processor, client_id, teamnr}) do
    for {topic, payload} <- messages do
      Tortoise.publish(client_id, "#{teamnr}#{topic}", "#{payload}", qos: 1)
    end

    {:reply, :ok, {processor, client_id, teamnr}}
  end

  def handle_info(_msg, state) do
    {:noreply, state}
  end
end
