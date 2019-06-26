defmodule IntersectionController.MQTTHandler do
  @moduledoc """
  Implementation of Tortoise.Handler behaviour for IntersectionController.
  """
  require Logger

  use Tortoise.Handler

  def init([teamnr, message_handler]) do
    :logger.info("Started MQTT client for team nr. #{teamnr}")
    {:ok, [teamnr, message_handler]}
  end

  def connection(:up, [teamnr, message_handler]) do
    :logger.info("MQTT Client for team nr. #{teamnr} connected to broker.")
    IntersectionController.MQTTMessageHandler.connected(message_handler)
    {:ok, [teamnr, message_handler]}
  end

  def connection(:down, [teamnr, message_handler]) do
    :logger.warning("MQTT Client for team nr. #{teamnr} lost connection.")
    {:ok, [teamnr, message_handler]}
  end

  def subscription(:up, topic_filter, [teamnr, message_handler]) do
    :logger.info("MQTT Client for team nr. #{teamnr} subscribed to #{topic_filter}")
    {:ok, [teamnr, message_handler]}
  end

  def subscription({:warn, [requested: req_qos, accepted: qos]}, topic_filter, [
        teamnr,
        message_handler
      ]) do
    :logger.warning(
      "MQTT Client for team nr. #{teamnr} subscribed to #{topic_filter} with QoS level #{qos}, requested QoS level #{
        req_qos
      }"
    )

    {:ok, [teamnr, message_handler]}
  end

  def subscription({:error, _reason}, topic_filter, [teamnr, message_handler]) do
    :logger.error("MQTT Client for team nr. #{teamnr} could not subscribe to #{topic_filter}")
    {:ok, [teamnr, message_handler]}
  end

  def subscription(:down, topic_filter, [teamnr, message_handler]) do
    :logger.info("MQTT Client for team nr. #{teamnr} unsubscribed from #{topic_filter}")
    {:ok, [teamnr, message_handler]}
  end

  def handle_message([teamnr, user_type, group_id, "sensor", component_id], payload, [
        _team_nr,
        message_handler
      ]) do
    :logger.info(
      "Simulator for team nr. #{teamnr} changed state of #{user_type}/#{group_id}/sensor/#{
        component_id
      } to #{payload}"
    )

    IntersectionController.MQTTMessageHandler.set_sensor(
      message_handler,
      user_type,
      group_id,
      component_id,
      payload
    )

    {:ok, [teamnr, message_handler]}
  end

  def handle_message(
        [teamnr, "features", "lifecycle", "simulator", "onconnect"],
        _payload,
        [_team_nr, message_handler]
      ) do
    :logger.info("Simulator for team nr. #{teamnr} connected.")

    IntersectionController.MQTTMessageHandler.onconnect(message_handler)

    {:ok, [teamnr, message_handler]}
  end

  def handle_message(
        [teamnr, "features", "lifecycle", "simulator", "ondisconnect"],
        _payload,
        [_team_nr, message_handler]
      ) do
    :logger.warning("Simulator for team nr. #{teamnr} disconnected.")

    IntersectionController.MQTTMessageHandler.ondisconnect(message_handler)

    {:ok, [teamnr, message_handler]}
  end

  def terminate(_reason, [teamnr, _message_handler]) do
    :logger.info("Stopped MQTT Client for team nr. #{teamnr}")
    :ok
  end
end
