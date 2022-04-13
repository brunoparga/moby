defmodule Moby.Server do
  use GenServer

  alias Moby.GameFlow

  def start_link(player_names) do
    GenServer.start_link(__MODULE__, player_names)
  end

  def init(player_names) do
    {:ok, GameFlow.new_game(player_names)}
  end

  def handle_call({:game_state}, _from, game) do
    # Initially this shows the entire state to both players
    # (to be split later - TODO)
    {:reply, Moby.GameState.state(game), game}
  end

  def handle_call({:make_move, move}, _from, game) do
    game = GameFlow.make_move(game, move)
    {:reply, game, game}
  end
end
