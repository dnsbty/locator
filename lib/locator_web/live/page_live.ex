defmodule LocatorWeb.PageLive do
  use LocatorWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, put_connect_info(socket)}
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
