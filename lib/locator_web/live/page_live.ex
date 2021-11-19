defmodule LocatorWeb.PageLive do
  use LocatorWeb, :live_view
  alias Locator.Presence

  @allowed_headers ["x-forwarded-for"]

  @impl true
  def mount(_params, _session, socket) do
    send(self(), :get_location)
    socket = socket |> put_connect_info() |> assign(latitude: nil, longitude: nil)
    LocatorWeb.Endpoint.subscribe("users")
    {:ok, socket}
  end

  @impl true
  def handle_info(:get_location, socket) do
    ip_address = socket.assigns.ip_address
    {lat, lng} = Locator.locate(ip_address)

    socket =
      socket
      |> assign(latitude: lat, longitude: lng)
      |> push_event("user-location", %{latitude: lat, longitude: lng})

    Presence.track_user(ip_address, {lat, lng})

    {:noreply, socket}
  end

  def handle_info(%{event: "presence_diff", payload: %{joins: joins}}, socket) do
    new_users = for {_ip, %{metas: [meta | _]}} <- joins, do: meta
    {:noreply, push_event(socket, "new-users", %{new_users: new_users})}
  end

  def handle_info(_, socket), do: {:noreply, socket}

  defp put_connect_info(socket = %{connected?: false}) do
    assign(socket, ip_address: nil)
  end

  defp put_connect_info(socket) do
    connect_info = get_connect_info(socket)

    if peer_ip = connect_info[:peer_data][:address] do
      x_headers = connect_info[:x_headers] || [] |> IO.inspect(label: "x heders")
      proxies = [Application.get_env(:locator, :public_ipv4)] |> IO.inspect(label: "proxies")
      remote_ip = RemoteIp.from(x_headers, headers: @allowed_headers, proxies: proxies)
      ip_string = (remote_ip || peer_ip) |> :inet.ntoa() |> to_string()
      assign(socket, ip_address: ip_string)
    else
      assign(socket, ip_address: nil)
    end
  end
end
