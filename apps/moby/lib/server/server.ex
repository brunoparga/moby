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
    {:reply, game, game}
  end

  def handle_call({:state_for_player, player_name}, _from, game) do
    # TODO: get the player from the `from` parameter, so this call
    # cannot be spoofed by other players.
    player = Moby.Player.find(game, player_name)
    {:reply, Moby.GameState.state(game, player), game}
  end

  def handle_call({:state_for_player_one}, _from, game) do
    {:reply, Moby.GameState.state(game, hd(game.players)), game}
  end

  def handle_call({:make_move, move}, _from, game) do
    game = GameFlow.make_move(game, move)
    {:reply, game, game}
  end
end
