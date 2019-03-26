defmodule Moby do
  @moduledoc """
  Implements a clone of the card game "Love Letter" by Z-Man Games.
  """
  defdelegate test, to: Moby.Test

  @doc """
  Start a game in the server, return the corresponding pid.
  TODO: change the supervision structure to match Tic-tac-toe
  """
  def new_game() do
    {:ok, pid} = Supervisor.start_child(Moby.Supervisor, [])
    pid
  end

  @doc """
  Returns the state of the game.
  TODO: make this dependent on the player who calls it.
  """
  def game_state(game_pid) do
    GenServer.call(game_pid, {:game_state})
  end

  @doc """
  Makes a move and returns the new game state. The caller must properly format
  the request (see handler for more information).
  """
  def make_move(game_pid, move) do
    GenServer.call(game_pid, {:make_move, move})
  end
end
