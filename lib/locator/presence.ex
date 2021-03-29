defmodule Locator.Presence do
  use Phoenix.Presence,
    otp_app: :locator,
    pubsub_server: Locator.PubSub

  @topic "users"

  @doc """
  List all of the users present
  """
  @spec list :: Phoenix.Presence.presences()
  def list, do: list(@topic)

  @doc """
  Track the presence of a user
  """
  @spec track_user(tuple, {float, float}) :: :ok | {:error, term()}
  def track_user(ip_address, {latitude, longitude}) do
    meta = %{latitude: latitude, longitude: longitude}
    track(self(), @topic, ip_address, meta)
  end
end
