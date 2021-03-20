alias HueSDK.API.{
  Capabilities,
  Configuration,
  Groups,
  Lights,
  Resourcelinks,
  Rules,
  Scenes,
  Schedules,
  Sensors
}

bridge =
  case HueSDK.Bridge.__read_from_disk__() do
    [bridge] -> bridge
    [] -> nil
  end
