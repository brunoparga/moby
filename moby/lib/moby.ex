defmodule Moby do
  @moduledoc """
  Implements a clone of the card game "Love Letter" by Z-Man Games.
  """

  alias Moby.GameState

  defdelegate test, to: Moby.Test

  @doc """
  Start a game in the server, return the corresponding pid.
  TODO: change the supervision structure to match Tic-tac-toe
  """
  @spec new_game() :: pid
  def new_game() do
    {:ok, pid} = Supervisor.start_child(Moby.Supervisor, [])
    pid
  end

  @doc """
  Returns the state of the game.
  TODO: make this dependent on the player who calls it.
  """
  @spec game_state(pid) :: GameState.t()
  def game_state(game_pid) do
    GenServer.call(game_pid, {:game_state})
  end

  @doc """
  A call to make_move has three possible formats, depending on the card
  played. The move itself is:
  - :card_atom in the case of the Princess, Countess and Handmaid, which require
    no target.
  - {:card_atom, "target name"} for the King, Prince, Baron and Priest
  - {:guard, "target name", :named_card} for the Guard.
  TODO: make this take a Map, to match the incoming JSON
  """
  @spec make_move(pid, atom | {atom, String.t()} | {:guard, String.t(), atom}) :: GameState.t()
  # TODO: validate that the player making the move is the one who's up to play
  def make_move(game_pid, move) do
    # GenServer.call(game_pid, {:make_move, move})
    # TODO: Uncomment the line above and delete the below - this is just for testing!!!
    GenServer.call(game_pid, {:make_move, move}, 86_400)
  end
end
