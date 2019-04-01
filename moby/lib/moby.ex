defmodule Moby do
  @moduledoc """
  Implements a clone of the card game "Love Letter" by Z-Man Games.
  """

  alias Moby.GameState

  defdelegate test, to: Moby.Test

  @type move() :: %{
          required(:played_card) => atom,
          optional(:target) => String.t(),
          optional(:named_card) => atom
        }

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
  Requests a move to the given server. The move has a required key, :played_card,
  and two optional ones: :named_card for the Guard and :target for all cards that
  target a player (King, Prince, Baron, Priest and Guard). Card values are atoms,
  the target name is a string.
  """
  # TODO: validate that the player making the move is the one who's up to play
  @spec make_move(pid, move()) :: GameState.t()
  def make_move(game_pid, move) do
    # GenServer.call(game_pid, {:make_move, move})
    # TODO: Uncomment the line above and delete the below - this is just for testing!!!
    GenServer.call(game_pid, {:make_move, move}, 86_400)
  end
end
