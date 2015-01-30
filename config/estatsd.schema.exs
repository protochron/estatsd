[
  mappings: [
    "estatsd.carbon_port": [
      doc: "The port that carbon is listening on",
      to: "estatsd.carbon_port",
      datatype: :integer,
      default: 2003
    ],
    "estatsd.carbon_host": [
      doc: "The URL of the carbon node",
      to: "estatsd.carbon_host",
      datatype: :binary,
      default: "127.0.0.1"
    ],
    "estatsd.port": [
      doc: "The port to receive metrics",
      to: "estatsd.port",
      datatype: :integer,
      default: 8125
    ],
    "estatsd.debug": [
      doc: "Enable debug mode",
      to: "estatsd.debug",
      datatype: :boolean,
      default: false
    ],
    "estatsd.mode": [
      doc: "The mode to send stats over (tcp or udp)",
      to: "estatsd.mode",
      datatype: :atom,
      default: :udp
    ],
    "estatsd.graphite.percentiles": [
      doc: "The percentiles to keep track of for timers",
      to: "estatsd.graphite.percentiles",
      datatype: [list: :integer],
      default: [90], 
    ],
    "estatsd.server_mode": [
      doc: "The mode to run the server under (tcp or udp)",
      to: "estatsd.mode",
      datatype: :atom,
      default: :udp
    ],
    "estatsd.flush_interval": [
      doc: "The rate in milliseconds to flush to each backend",
      to: "estatsd.flush_interval",
      datatype: :integer,
      default: 1000
    ],
    "estatsd.graphite.global_prefix": [
      doc: "Global prefix to use when sending stats to Graphite",
      to: "estatsd.graphite.global_prefix",
      datatype: :string,
      default: "stats"
    ],
    "estatsd.graphite.prefix_counter": [
      doc: "Graphite prefix for counter metrics",
      to: "estatsd.graphite.prefix_counter",
      datatype: :string,
      default: "counters"
    ],
    "estatsd.graphite.prefix_timer": [
      doc: "Graphite prefix for timer metrics",
      to: "estatsd.graphite.prefix_timer",
      datatype: :string,
      default: "timers"
    ],
    "estatsd.graphite.prefix_gauges": [
      doc: "Graphite prefix for gauges metrics",
      to: "estatsd.graphite.prefix_gauges",
      datatype: :string,
      default: "gauges"
    ],
    "estatsd.graphite.prefix_set": [
      doc: "Graphite prefix for set metrics",
      to: "estatsd.graphite.prefix_set",
      datatype: :string,
      default: "sets"
    ],
  ],
  translations: [
  ]
]
