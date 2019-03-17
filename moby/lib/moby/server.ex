defmodule Moby.Server do
  use GenServer

  def start_link() do
    GenServer.start_link(__MODULE__, nil)
  end

  def init(_) do
    {:ok, Moby.Play.new_game()}
  end

  def handle_call({:game_state}, _from, game) do
    # Initially this shows the entire state to both players
    # (to be split later)
    {:reply, Moby.Game.state(game), game}
  end

  def handle_call({:make_move, move}, _from, game) do
    # Initially this doesn't take a player as an argument
    # (figure that out later)
    game = Moby.Play.make_move(game, move)
    {:reply, game, game}
  end
end
