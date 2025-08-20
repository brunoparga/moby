defmodule Moby do
  @moduledoc """
  Implements a clone of the card game "Love Letter" by Z-Man Games.
  """

  alias Moby.{GameState, Types}

  defdelegate test, to: Moby.Test

  @doc """
  Start a game in the server, return the corresponding pid.
  The game is started with two default players.
  """
  @spec new_game() :: pid
  def new_game() do
    new_game(["Joe", "Ann"])
  end

  @doc """
  Start a game in the server, return the corresponding pid.
  """
  @spec new_game(list(String.t())) :: pid
  def new_game(player_names) when length(player_names) in [2, 3, 4] do
    {:ok, pid} = Moby.Application.start_game(player_names)
    pid
  end

  def new_game(_wrong_number_of_players) do
    raise "Love Letter can only be played with 2, 3 or 4 players"
  end

  @doc """
  Returns the state of the game.
  """
  @spec game_state(pid) :: GameState.t()
  def game_state(game_pid) do
    GenServer.call(game_pid, {:game_state})
  end

  @doc """
  Returns the state of the game for the first player.
  """
  @spec state_for_player_one(pid) :: Types.discreet_game()
  def state_for_player_one(game_pid) do
    GenServer.call(game_pid, {:state_for_player_one})
  end

  @doc """
  Returns the state of the game for the given player.
  TODO: reduce this to arity 1; the GenServer will find the player by their pid.
  """
  @spec state_for_player(pid, String.t()) :: Types.discreet_game()
  def state_for_player(game_pid, player_name) do
    GenServer.call(game_pid, {:state_for_player, player_name})
  end

  @doc """
  Requests a move to the given server. The move has a required key, :played_card,
  and two optional ones: :named_card for the Guard and :target for all cards that
  target a player (King, Prince, Baron, Priest and Guard). Card values are atoms,
  the target name is a string.
  """
  # TODO: validate that the player making the move is the one who's up to play
  @spec make_move(pid, Types.move()) :: GameState.t()
  def make_move(game_pid, move) do
    GenServer.call(game_pid, {:make_move, move})
  end
end
