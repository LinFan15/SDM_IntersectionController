defmodule IntersectionController.TrafficModel do
  require Logger

  def get_traffic_light_state(direction, intended_state)

  def get_traffic_light_state("RTG", :initial) do
    0
  end

  def get_traffic_light_state("RTG", :transition) do
    1
  end

  def get_traffic_light_state("RTG", :end) do
    2
  end

  def get_traffic_light_state("GTR", :initial) do
    2
  end

  def get_traffic_light_state("GTR", :transition) do
    1
  end

  def get_traffic_light_state("GTR", :end) do
    0
  end

  def get_traffic_light_state("GR", :initial) do
    0
  end

  def get_traffic_light_state("GR", :end) do
    1
  end

  def get_traffic_light_state("RG", :initial) do
    1
  end

  def get_traffic_light_state("RG", :end) do
    0
  end

  def sensor_activated?(sensors, sensor) do
    group =
      sensor
      |> String.split("/", parts: 4)
      |> Enum.slice(0, 3)
      |> Enum.join("/")

    sensor = String.slice(sensor, String.length(group), 9)

    if Map.has_key?(sensors, group) do
      group_map = Map.fetch!(sensors, group)

      if Map.has_key?(group_map, sensor) do
        Map.fetch!(group_map, sensor)
      else
        false
      end
    else
      false
    end
  end

  def group_exception?(traffic_model, sensors, group) do
    group_map = Map.fetch!(traffic_model, group)

    if tuple_size(group_map.exception) == 0 do
      false
    else
      Tuple.to_list(group_map.exception)
      |> Enum.map(fn sensor -> sensor_activated?(sensors, sensor) end)
      |> Enum.any?(fn x -> x end)
    end
  end

  def expand_associated_groups(associated_groups, traffic_model) do
    associated_list = Tuple.to_list(associated_groups)

    for group <- associated_list, into: %{} do
      group_map = Map.fetch!(traffic_model, group)
      items = group_map.items
      duration = group_map.duration
      {group, %{:items => items, :duration => duration}}
    end
  end

  def associated_running?(group_associated, running_associated) do
    Map.keys(group_associated)
    |> Enum.any?(fn group -> group in running_associated end)
  end

  def messages_from_group(group, group_map, state) do
    for {item_name, type_map} <- group_map.items do
      actual_state =
        IntersectionController.TrafficModel.get_traffic_light_state(type_map.type, state)

      {"#{group}#{item_name}", actual_state}
    end
    |> List.flatten()
  end

  def get_solution(queue, sensors, traffic_model, put_back, excluded, current_solution)

  def get_solution(queue, sensors, traffic_model, put_back, [], current_solution)
      when map_size(current_solution) == 0 do
    if :queue.is_empty(queue) do
      {%{}, queue}
    else
      {{:value, group}, queue} = :queue.out(queue)

      if Map.fetch!(sensors, group) |> Map.values() |> Enum.any?(fn x -> x end) do
        if not group_exception?(traffic_model, sensors, group) do
          group_map = Map.fetch!(traffic_model, group)

          items = group_map.items
          duration = group_map.duration

          associated =
            if tuple_size(group_map.associated) > 0 do
              expand_associated_groups(group_map.associated, traffic_model)
            else
              %{}
            end

          current_solution = %{
            group => %{:items => items, :duration => duration, :associated => associated}
          }

          excluded = Tuple.to_list(group_map.excluded)
          get_solution(queue, sensors, traffic_model, put_back, excluded, current_solution)
        else
          put_back = put_back ++ [group]
          get_solution(queue, sensors, traffic_model, put_back, [], %{})
        end
      else
        get_solution(queue, sensors, traffic_model, put_back, [], %{})
      end
    end
  end

  def get_solution(queue, sensors, traffic_model, put_back, excluded, current_solution)
      when map_size(current_solution) > 0 do
    if :queue.is_empty(queue) do
      queue = :queue.from_list(put_back)
      :logger.warning(inspect(queue))
      {current_solution, queue}
    else
      {{:value, group}, queue} = :queue.out(queue)

      if Map.fetch!(sensors, group) |> Map.values() |> Enum.any?(fn x -> x end) do
        if not group_exception?(traffic_model, sensors, group) and
             not Enum.member?(excluded, group) do
          group_map = Map.fetch!(traffic_model, group)

          items = group_map.items
          duration = group_map.duration

          associated =
            if tuple_size(group_map.associated) > 0 do
              expand_associated_groups(group_map.associated, traffic_model)
            else
              %{}
            end

          current_solution =
            Map.put(current_solution, group, %{
              :items => items,
              :duration => duration,
              :associated => associated
            })

          excluded = excluded ++ Tuple.to_list(group_map.excluded)

          get_solution(queue, sensors, traffic_model, put_back, excluded, current_solution)
        else
          put_back = put_back ++ [group]
          get_solution(queue, sensors, traffic_model, put_back, excluded, current_solution)
        end
      else
        get_solution(queue, sensors, traffic_model, put_back, excluded, current_solution)
      end
    end
  end
end
