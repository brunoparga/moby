defmodule MobyWeb.GameLive do
  use MobyWeb, :live_view

  def mount(_params, _session, socket) do
    socket = assign(socket, players: ["Fonk", "Tunts"], game_pid: nil)
    {:ok, socket, layout: false}
  end

  def render(assigns) do
    ~H"""
    <h1>Love Letter</h1>
    <p>Players: <%= @players %></p>
    <button phx-click="submit">Submit</button>
    <%= if @game_pid do %>
      <p>Game pid: <%= :erlang.pid_to_list(@game_pid) %></p>
    <% end %>
    """
  end

  def handle_event("submit", _params, socket) do
    game_pid = Moby.new_game(socket.assigns.players)
    {:noreply, assign(socket, :game_pid, game_pid)}
  end
end
