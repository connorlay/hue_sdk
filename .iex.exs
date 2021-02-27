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
  case HueSDK.Bridge.read_from_disk() do
    [bridge] -> bridge
    [] -> nil
  end
