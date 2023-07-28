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
    # TODO: currently it is assumed that the player up to play calls this function.
    # I need to see if this assumption is correct.
    # The structure of the "from" parameter is:
    # from: {#PID<0.99.0>, [:alias | #Reference<0.0.12675.2801004649.2553610241.152459>]}
    # but I might just go with the name (the pid can (will??) change)
    {:reply, Moby.GameState.state(game), game}
  end

  def handle_call({:make_move, move}, _from, game) do
    game = GameFlow.make_move(game, move)
    {:reply, game, game}
  end
end
