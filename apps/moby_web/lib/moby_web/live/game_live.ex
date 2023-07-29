defmodule MobyWeb.GameLive do
  use MobyWeb, :live_view

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(game_pid: nil)
      |> assign(players: [])
      |> assign(form: to_form(%{"player" => ""}))

    {:ok, socket}
  end

  def handle_event("add_player", params, socket) do
    players = socket.assigns.players ++ [params["player"]]
    {:noreply, assign(socket, :players, players)}
  end

  def handle_event("submit", _params, socket) do
    game_pid = Moby.new_game(socket.assigns.players)
    {:noreply, assign(socket, :game_pid, game_pid)}
  end
end
