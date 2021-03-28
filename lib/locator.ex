defmodule Locator do
  def locate("127.0.0.1"), do: {0, 0}

  def locate(ip_address) do
    case GeoIP.lookup(ip_address) do
      {:ok, %{latitude: lat, longitude: lng}} -> {lat, lng}
      _ -> {0, 0}
    end
  end
end
