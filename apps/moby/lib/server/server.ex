defmodule Moby.Server do
  @moduledoc """
  Serve a Love Letter game. Calls divide into three groups:
  - creating, joining and starting a game;
  - making moves;
  - reading the state of the game.
  """

  use GenServer

  def start_link(_args) do
    GenServer.start_link(__MODULE__, nil)
  end

  def init(_args) do
    {:ok, []}
  end

  def handle_call({:join_game, player_name}, {pid, _ref}, players) when length(players) < 4 do
    new_state = players ++ [{player_name, pid}]
    players = Enum.map(new_state, fn {name, _pid} -> name end)
    {:reply, {:ok, players}, new_state}
  end

  def handle_call({:join_game, _player_name}, _from, players) do
    {:reply, {:error, "This game is full.", players}, players}
  end

  def handle_call({:start_game}, _from, players) do
    game = Moby.GameState.initialize(players)
    {:reply, game, game}
  end

  def handle_call({:make_move, move}, _from, game) do
    game = Moby.GameFlow.make_move(game, move)
    {:reply, game, game}
  end

  def handle_call({:game_state}, _from, game) do
    {:reply, game, game}
  end

  def handle_call({:state_for_player, player_name}, _from, game) do
    # TODO: get the player from the `from` parameter, so this call
    # cannot be spoofed by other players.
    player = Moby.Player.find(game, player_name)
    {:reply, Moby.Display.state_for_player(game, player), game}
  end

  def handle_call({:state_for_player_one}, _from, game) do
    {:reply, Moby.Display.state_for_player(game, hd(game.players)), game}
  end
end
