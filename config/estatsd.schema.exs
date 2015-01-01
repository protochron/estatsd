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
    "estatsd.server_mode": [
      doc: "The mode to run the server under (tcp or udp)",
      to: "estatsd.mode",
      datatype: :atom,
      default: :udp
    ]
  ],
  translations: [
  ]
]
