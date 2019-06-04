use Mix.Config

config :intersection_controller, :traffic_model, %{
  "/motor_vehicle/1" => %{
    :items => %{
      "/light/1" => %{
        :type => "RTG"
      }
    },
    :duration => %{
      :initial => 1000,
      :transition => 4000,
      :end => 6000
    },
    :excluded => {
      "/foot/1",
      "/cycle/1",
      "/cycle/4",
      "/foot/8",
      "/motor_vehicle/5",
      "/motor_vehicle/8"
    },
    :associated => {},
    :exception => {}
  },
  "/motor_vehicle/2" => %{
    :items => %{
      "/light/1" => %{
        :type => "RTG"
      }
    },
    :duration => %{
      :initial => 1000,
      :transition => 4000,
      :end => 6000
    },
    :excluded => {
      "/foot/1",
      "/cycle/1",
      "/cycle/3",
      "/foot/6",
      "/motor_vehicle/5",
      "/motor_vehicle/6",
      "/motor_vehicle/8",
      "/motor_vehicle/9",
      "/motor_vehicle/10",
      "/motor_vehicle/11",
      "/motor_vehicle/12"
    },
    :associated => {},
    :exception => {}
  },
  "/motor_vehicle/3" => %{
    :items => %{
      "/light/1" => %{
        :type => "RTG"
      }
    },
    :duration => %{
      :initial => 1000,
      :transition => 4000,
      :end => 6000
    },
    :excluded => {
      "/foot/1",
      "/cycle/1",
      "/cycle/2",
      "/foot/4",
      "/motor_vehicle/5",
      "/motor_vehicle/6",
      "/motor_vehicle/7",
      "/motor_vehicle/8",
      "/motor_vehicle/10",
      "/motor_vehicle/11"
    },
    :associated => {},
    :exception => {
      "/motor_vehicle/14/sensor/1"
    }
  },
  "/motor_vehicle/4" => %{
    :items => %{
      "/light/1" => %{
        :type => "RTG"
      }
    },
    :duration => %{
      :initial => 1000,
      :transition => 4000,
      :end => 6000
    },
    :excluded => {
      "/foot/3",
      "/cycle/2",
      "/cycle/1",
      "/foot/2",
      "/motor_vehicle/8",
      "/motor_vehicle/11"
    },
    :associated => {},
    :exception => {}
  },
  "/motor_vehicle/5" => %{
    :items => %{
      "/light/1" => %{
        :type => "RTG"
      },
      "/light/2" => %{
        :type => "RTG"
      }
    },
    :duration => %{
      :initial => 1000,
      :transition => 4000,
      :end => 6000
    },
    :excluded => {
      "/foot/3",
      "/cycle/2",
      "/cycle/4",
      "/foot/8",
      "/motor_vehicle/1",
      "/motor_vehicle/2",
      "/motor_vehicle/3",
      "/motor_vehicle/8",
      "/motor_vehicle/11"
    },
    :associated => {},
    :exception => {}
  },
  "/motor_vehicle/6" => %{
    :items => %{
      "/light/1" => %{
        :type => "RTG"
      }
    },
    :duration => %{
      :initial => 1000,
      :transition => 4000,
      :end => 6000
    },
    :excluded => {
      "/foot/3",
      "/cycle/2",
      "/cycle/3",
      "/foot/6",
      "/motor_vehicle/2",
      "/motor_vehicle/3",
      "/motor_vehicle/8",
      "/motor_vehicle/9",
      "/motor_vehicle/10",
      "/motor_vehicle/12"
    },
    :associated => {},
    :exception => {}
  },
  "/motor_vehicle/7" => %{
    :items => %{
      "/light/1" => %{
        :type => "RTG"
      },
      "/light/2" => %{
        :type => "RTG"
      }
    },
    :duration => %{
      :initial => 1000,
      :transition => 4000,
      :end => 6000
    },
    :excluded => {
      "/foot/5",
      "/cycle/3",
      "/cycle/2",
      "/foot/4",
      "/motor_vehicle/3",
      "/motor_vehicle/10",
      "/motor_vehicle/12"
    },
    :associated => {},
    :exception => {
      "/motor_vehicle/14/sensor/1"
    }
  },
  "/motor_vehicle/8" => %{
    :items => %{
      "/light/1" => %{
        :type => "RTG"
      }
    },
    :duration => %{
      :initial => 1000,
      :transition => 4000,
      :end => 6000
    },
    :excluded => {
      "/foot/5",
      "/cycle/3",
      "/cycle/1",
      "/foot/2",
      "/cycle/4",
      "/foot/8",
      "/motor_vehicle/1",
      "/motor_vehicle/2",
      "/motor_vehicle/3",
      "/motor_vehicle/4",
      "/motor_vehicle/5",
      "/motor_vehicle/6",
      "/motor_vehicle/10",
      "/motor_vehicle/11",
      "/motor_vehicle/12"
    },
    :associated => {},
    :exception => {}
  },
  "/motor_vehicle/9" => %{
    :items => %{
      "/light/1" => %{
        :type => "RTG"
      }
    },
    :duration => %{
      :initial => 1000,
      :transition => 4000,
      :end => 6000
    },
    :excluded => {
      "/foot/7",
      "/cycle/4",
      "/cycle/3",
      "/foot/6",
      "/motor_vehicle/2",
      "/motor_vehicle/6",
      "/motor_vehicle/12"
    },
    :associated => {},
    :exception => {}
  },
  "/motor_vehicle/10" => %{
    :items => %{
      "/light/1" => %{
        :type => "RTG"
      },
      "/light/2" => %{
        :type => "RTG"
      }
    },
    :duration => %{
      :initial => 1000,
      :transition => 4000,
      :end => 6000
    },
    :excluded => {
      "/foot/7",
      "/cycle/4",
      "/cycle/2",
      "/foot/4",
      "/motor_vehicle/2",
      "/motor_vehicle/3",
      "/motor_vehicle/6",
      "/motor_vehicle/7",
      "/motor_vehicle/8"
    },
    :associated => {},
    :exception => {
      "/motor_vehicle/14/sensor/1"
    }
  },
  "/motor_vehicle/11" => %{
    :items => %{
      "/light/1" => %{
        :type => "RTG"
      }
    },
    :duration => %{
      :initial => 1000,
      :transition => 4000,
      :end => 6000
    },
    :excluded => {
      "/foot/7",
      "/cycle/4",
      "/cycle/1",
      "/foot/2",
      "/motor_vehicle/2",
      "/motor_vehicle/3",
      "/motor_vehicle/4",
      "/motor_vehicle/5",
      "/motor_vehicle/8"
    },
    :associated => {},
    :exception => {}
  },
  "/motor_vehicle/12" => %{
    :items => %{
      "/light/1" => %{
        :type => "RTG"
      }
    },
    :duration => %{
      :initial => 1000,
      :transition => 4000,
      :end => 6000
    },
    :excluded => {
      "/motor_vehicle/2",
      "/motor_vehicle/6",
      "/motor_vehicle/7",
      "/motor_vehicle/8",
      "/motor_vehicle/9"
    },
    :associated => {},
    :exception => {}
  },
  "/cycle/1" => %{
    :items => %{
      "/light/1" => %{
        :type => "RTG"
      }
    },
    :duration => %{
      :initial => 1000,
      :transition => 2000,
      :end => 8000
    },
    :excluded => {
      "/motor_vehicle/1",
      "/motor_vehicle/2",
      "/motor_vehicle/3",
      "/motor_vehicle/4",
      "/motor_vehicle/8",
      "/motor_vehicle/11"
    },
    :associated => {},
    :exception => {}
  },
  "/cycle/2" => %{
    :items => %{
      "/light/1" => %{
        :type => "RTG"
      }
    },
    :duration => %{
      :initial => 1000,
      :transition => 2000,
      :end => 8000
    },
    :excluded => {
      "/motor_vehicle/3",
      "/motor_vehicle/4",
      "/motor_vehicle/5",
      "/motor_vehicle/6",
      "/motor_vehicle/7",
      "/motor_vehicle/10"
    },
    :associated => {},
    :exception => {}
  },
  "/cycle/3" => %{
    :items => %{
      "/light/1" => %{
        :type => "RTG"
      }
    },
    :duration => %{
      :initial => 1000,
      :transition => 2000,
      :end => 8000
    },
    :excluded => {
      "/motor_vehicle/2",
      "/motor_vehicle/6",
      "/motor_vehicle/7",
      "/motor_vehicle/8",
      "/motor_vehicle/9"
    },
    :associated => {},
    :exception => {}
  },
  "/cycle/4" => %{
    :items => %{
      "/light/1" => %{
        :type => "RTG"
      }
    },
    :duration => %{
      :initial => 1000,
      :transition => 2000,
      :end => 8000
    },
    :excluded => {
      "/motor_vehicle/1",
      "/motor_vehicle/5",
      "/motor_vehicle/8",
      "/motor_vehicle/9",
      "/motor_vehicle/10",
      "/motor_vehicle/11"
    },
    :associated => {},
    :exception => {}
  },
  "/foot/1" => %{
    :items => %{
      "/light/1" => %{
        :type => "RTG"
      },
      "/light/2" => %{
        :type => "RTG"
      }
    },
    :duration => %{
      :initial => 1000,
      :transition => 6000,
      :end => 6000
    },
    :excluded => {
      "/motor_vehicle/1",
      "/motor_vehicle/2",
      "/motor_vehicle/3"
    },
    :associated => {},
    :exception => {}
  },
  "/foot/2" => %{
    :items => %{
      "/light/1" => %{
        :type => "RTG"
      },
      "/light/2" => %{
        :type => "RTG"
      }
    },
    :duration => %{
      :initial => 1000,
      :transition => 6000,
      :end => 6000
    },
    :excluded => {
      "/motor_vehicle/4",
      "/motor_vehicle/8",
      "/motor_vehicle/11"
    },
    :associated => {},
    :exception => {}
  },
  "/foot/3" => %{
    :items => %{
      "/light/1" => %{
        :type => "RTG"
      },
      "/light/2" => %{
        :type => "RTG"
      }
    },
    :duration => %{
      :initial => 1000,
      :transition => 6000,
      :end => 6000
    },
    :excluded => {
      "/motor_vehicle/4",
      "/motor_vehicle/5",
      "/motor_vehicle/6"
    },
    :associated => {},
    :exception => {}
  },
  "/foot/4" => %{
    :items => %{
      "/light/1" => %{
        :type => "RTG"
      },
      "/light/2" => %{
        :type => "RTG"
      }
    },
    :duration => %{
      :initial => 1000,
      :transition => 6000,
      :end => 6000
    },
    :excluded => {
      "/motor_vehicle/3",
      "/motor_vehicle/7",
      "/motor_vehicle/10"
    },
    :associated => {},
    :exception => {}
  },
  "/foot/5" => %{
    :items => %{
      "/light/1" => %{
        :type => "RTG"
      },
      "/light/2" => %{
        :type => "RTG"
      }
    },
    :duration => %{
      :initial => 1000,
      :transition => 6000,
      :end => 6000
    },
    :excluded => {
      "/motor_vehicle/7",
      "/motor_vehicle/8"
    },
    :associated => {},
    :exception => {}
  },
  "/foot/6" => %{
    :items => %{
      "/light/1" => %{
        :type => "RTG"
      },
      "/light/2" => %{
        :type => "RTG"
      }
    },
    :duration => %{
      :initial => 1000,
      :transition => 6000,
      :end => 6000
    },
    :excluded => {
      "/motor_vehicle/2",
      "/motor_vehicle/6",
      "/motor_vehicle/9"
    },
    :associated => {},
    :exception => {}
  },
  "/foot/7" => %{
    :items => %{
      "/light/1" => %{
        :type => "RTG"
      },
      "/light/2" => %{
        :type => "RTG"
      }
    },
    :duration => %{
      :initial => 1000,
      :transition => 6000,
      :end => 6000
    },
    :excluded => {
      "/motor_vehicle/9",
      "/motor_vehicle/10",
      "/motor_vehicle/11"
    },
    :associated => {},
    :exception => {}
  },
  "/foot/8" => %{
    :items => %{
      "/light/1" => %{
        :type => "RTG"
      },
      "/light/2" => %{
        :type => "RTG"
      }
    },
    :duration => %{
      :initial => 1000,
      :transition => 6000,
      :end => 6000
    },
    :excluded => {
      "/motor_vehicle/1",
      "/motor_vehicle/5",
      "/motor_vehicle/8"
    },
    :associated => {},
    :exception => {}
  },
  "/vessel/1" => %{
    :items => %{
      "/light/1" => %{
        :type => "RTG"
      }
    },
    :duration => %{
      :initial => 0,
      :transition => 0,
      :end => 10_000
    },
    :excluded => {},
    :associated => {
      "/bridge/1"
    },
    :exception => {}
  },
  "/vessel/2" => %{
    :items => %{
      "/light/1" => %{
        :type => "RTG"
      }
    },
    :duration => %{
      :initial => 0,
      :transition => 0,
      :end => 10_000
    },
    :excluded => {},
    :associated => {
      "/bridge/1"
    },
    :exception => {}
  },
  "/bridge/1" => %{
    :items => %{
      "/light/1" => %{
        :type => "GTR"
      },
      "/gate/1" => %{
        :type => "GR"
      },
      "/gate/2" => %{
        :type => "GR"
      },
      "/deck/1" => %{
        :type => "RG"
      }
    },
    :duration => %{
      :deck => 10_000,
      :gate => 4000,
      :light => 6000,
      :after => 30_000
    },
    :excluded => {},
    :associated => {},
    :exception => {}
  }
}
