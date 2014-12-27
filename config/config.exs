# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

config :estatsd,
  carbon_port: 2003,
  carbon_host: nil,
  port: 8125,
  debug: false,
  mode: :udp
