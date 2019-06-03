defmodule IntersectionController.TrafficHandler do
  def handle_traffic_group(message_handler, task_supervisor, processor, from, group, group_map) do
    if Map.size(group_map.associated) == 0 do
      messages = IntersectionController.TrafficModel.messages_from_group(group, group_map, :end)
      IntersectionController.MQTTMessageHandler.publish(message_handler, messages)
      Process.sleep(group_map.duration.end)

      messages =
        IntersectionController.TrafficModel.messages_from_group(group, group_map, :transition)

      IntersectionController.MQTTMessageHandler.publish(message_handler, messages)
      Process.sleep(group_map.duration.transition)

      messages =
        IntersectionController.TrafficModel.messages_from_group(group, group_map, :initial)

      IntersectionController.MQTTMessageHandler.publish(message_handler, messages)
      Process.sleep(group_map.duration.initial)
    else
      associated_started =
        for {associated_group, associated_map} <- group_map.associated do
          if String.contains?(associated_group, "bridge") do
            Task.Supervisor.start_child(task_supervisor, fn ->
              handle_bridge(message_handler, processor, from, associated_group, associated_map)
            end)

            associated_group
          end
        end

      send(from, {:associated_started, associated_started})
    end
  end

  defp handle_bridge(message_handler, processor, from, group, group_map) do
    lights =
      group_map.items
      |> Map.keys()
      |> Enum.filter(fn item -> String.contains?(item, "light") end)

    messages =
      for light <- lights do
        type = Map.fetch!(group_map.items, light).type

        state = IntersectionController.TrafficModel.get_traffic_light_state(type, :end)

        {"#{group}#{light}", state}
      end

    IntersectionController.MQTTMessageHandler.publish(message_handler, messages)
    Process.sleep(group_map.duration.light)

    type = Map.fetch!(group_map.items, "/gate/1").type
    state = IntersectionController.TrafficModel.get_traffic_light_state(type, :end)
    messages = [{"#{group}/gate/1", state}]
    IntersectionController.MQTTMessageHandler.publish(message_handler, messages)
    Process.sleep(group_map.duration.gate)

    wait_for_sensor(processor, "#{group}/sensor/1", false)

    type = Map.fetch!(group_map.items, "/gate/2").type
    state = IntersectionController.TrafficModel.get_traffic_light_state(type, :end)
    messages = [{"#{group}/gate/2", state}]
    IntersectionController.MQTTMessageHandler.publish(message_handler, messages)
    Process.sleep(group_map.duration.gate)

    decks =
      group_map.items
      |> Map.keys()
      |> Enum.filter(fn item -> String.contains?(item, "deck") end)

    messages =
      for deck <- decks do
        type = Map.fetch!(group_map.items, deck).type

        state = IntersectionController.TrafficModel.get_traffic_light_state(type, :end)

        {"#{group}#{deck}", state}
      end

    IntersectionController.MQTTMessageHandler.publish(message_handler, messages)
    Process.sleep(group_map.duration.deck)

    state = IntersectionController.Processor.get_sensor(processor, "/vessel/1/sensor/1")

    if state do
      new_state = IntersectionController.TrafficModel.get_traffic_light_state("RTG", :end)
      messages = [{"/vessel/1/light/1", new_state}]
      IntersectionController.MQTTMessageHandler.publish(message_handler, messages)
      wait_for_sensor(processor, "/vessel/1/sensor/1", false)
      wait_for_sensor(processor, "/vessel/3/sensor/1", false)
      new_state = IntersectionController.TrafficModel.get_traffic_light_state("RTG", :initial)
      messages = [{"/vessel/1/light/1", new_state}]
      IntersectionController.MQTTMessageHandler.publish(message_handler, messages)
    end

    state = IntersectionController.Processor.get_sensor(processor, "/vessel/2/sensor/1")

    if state do
      new_state = IntersectionController.TrafficModel.get_traffic_light_state("RTG", :end)
      messages = [{"/vessel/2/light/1", new_state}]
      IntersectionController.MQTTMessageHandler.publish(message_handler, messages)
      wait_for_sensor(processor, "/vessel/2/sensor/1", false)
      wait_for_sensor(processor, "/vessel/3/sensor/1", false)
      new_state = IntersectionController.TrafficModel.get_traffic_light_state("RTG", :initial)
      messages = [{"/vessel/2/light/1", new_state}]
      IntersectionController.MQTTMessageHandler.publish(message_handler, messages)
    end

    messages =
      for deck <- decks do
        type = Map.fetch!(group_map.items, deck).type

        state = IntersectionController.TrafficModel.get_traffic_light_state(type, :initial)

        {"#{group}#{deck}", state}
      end

    IntersectionController.MQTTMessageHandler.publish(message_handler, messages)
    Process.sleep(group_map.duration.deck)

    gates =
      group_map.items
      |> Map.keys()
      |> Enum.filter(fn item -> String.contains?(item, "gate") end)

    messages =
      for gate <- gates do
        type = Map.fetch!(group_map.items, gate).type

        state = IntersectionController.TrafficModel.get_traffic_light_state(type, :initial)

        {"#{group}#{gate}", state}
      end

    IntersectionController.MQTTMessageHandler.publish(message_handler, messages)
    Process.sleep(group_map.duration.gate)

    messages =
      for light <- lights do
        type = Map.fetch!(group_map.items, light).type

        state = IntersectionController.TrafficModel.get_traffic_light_state(type, :end)

        {"#{group}#{light}", state}
      end

    IntersectionController.MQTTMessageHandler.publish(message_handler, messages)
    Process.sleep(group_map.duration.after)

    send(from, {:associated_stopped, group})
  end

  def wait_for_sensor(processor, sensor, state) do
    if IntersectionController.Processor.get_sensor(processor, sensor) == state do
      {:ok}
    else
      Process.sleep(100)
      wait_for_sensor(processor, sensor, state)
    end
  end
end
