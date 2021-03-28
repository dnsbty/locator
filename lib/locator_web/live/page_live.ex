defmodule LocatorWeb.PageLive do
  use LocatorWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    send(self(), :get_location)
    socket = socket |> put_connect_info() |> assign(latitude: nil, longitude: nil)
    {:ok, socket}
  end

  @impl true
  def handle_info(:get_location, socket) do
    {lat, lng} = Locator.locate(socket.assigns.ip_address)

    socket =
      socket
      |> assign(latitude: lat, longitude: lng)
      |> push_event("user-location", %{latitude: lat, longitude: lng})

    {:noreply, socket}
  end

  defp put_connect_info(socket = %{connected?: false}) do
    assign(socket, ip_address: nil)
  end

  defp put_connect_info(socket) do
    connect_info = get_connect_info(socket)
    ip_tuple = connect_info[:peer_data][:address]
    ip_string = ip_tuple |> :inet.ntoa() |> to_string()
    assign(socket, ip_address: ip_string)
  end
end
