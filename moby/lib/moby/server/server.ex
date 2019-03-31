defmodule Moby.Server do
  use GenServer

  alias Moby.{GameState, GameFlow}

  def start_link() do
    GenServer.start_link(__MODULE__, nil)
  end

  def init(_) do
    {:ok, GameFlow.new_game()}
  end

  def handle_call({:game_state}, _from, game) do
    # Initially this shows the entire state to both players
    # (to be split later - TODO)
    {:reply, GameState.state(game), game}
  end

  def handle_call({:make_move, move}, _from, game) do
    game = GameFlow.make_move(game, move)
    {:reply, game, game}
  end
end
