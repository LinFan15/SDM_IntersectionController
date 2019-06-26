# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

# This configuration is loaded before any dependency and is restricted
# to this project. If another project depends on this project, this
# file won't be loaded nor affect the parent project. For this reason,
# if you want to provide default values for your application for
# third-party users, it should be done in your "mix.exs" file.

# You can configure your application as:
#
#     config :intersection_controller, key: :value
#
# and access this configuration in your application as:
#
#     Application.get_env(:intersection_controller, :key)
#
# You can also configure a third-party app:
#
#     config :logger, level: :info
#

# It is also possible to import configuration files, relative to this
# directory. For example, you can emulate configuration per environment
# by uncommenting the line below and defining dev.exs, test.exs and such.
# Configuration from the imported file will override the ones defined
# here (which is why it is important to import them last).
#
#     import_config "#{Mix.env()}.exs"

# Team numbers of simulators which should be managed by this controller.
config :intersection_controller, :team_numbers, [1, 2, 3, 4, 5]

# Topics the controller should subscribe to for every simulator
config :intersection_controller, :topics, [
  "/features/lifecycle/simulator/+",
  "/+/+/sensor/+"
]

# Elixir representation of the intersection that should be managed
import_config("traffic_model.exs")
