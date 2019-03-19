defmodule Moby.Server do
  use GenServer

  alias Moby.{Game, Play}

  def start_link() do
    GenServer.start_link(__MODULE__, nil)
  end

  def init(_) do
    {:ok, Play.new_game()}
  end

  def handle_call({:game_state}, _from, game) do
    # Initially this shows the entire state to both players
    # (to be split later - TODO)
    {:reply, Game.state(game), game}
  end

  def handle_call({:make_move, card}, _from, game) do
    # Initially this doesn't take a player as an argument
    # (figure that out later - TODO)
    game = Play.make_move(game, card)
    {:reply, game, game}
  end
end
