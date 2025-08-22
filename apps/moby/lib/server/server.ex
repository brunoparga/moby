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

  def handle_call(:start_game, _from, players) do
    game = Moby.GameState.initialize(players)
    {:reply, game, game}
  end

  def handle_call({:make_move, move}, {pid, _ref}, game) when pid == hd(game.players).pid do
    game = Moby.GameFlow.make_move(game, move)
    {:reply, game, game}
  end

  def handle_call({:make_move, _move}, _from, game) do
    {:reply, {:error, "Not your turn."}, game}
  end

  def handle_call(:game_state, _from, game) do
    {:reply, game, game}
  end

  def handle_call(:my_game, {pid, _ref}, game) do
    player = Enum.find(game.players, fn player -> player.pid == pid end)
    {:reply, Moby.Display.state_for_player(game, player), game}
  end
end
