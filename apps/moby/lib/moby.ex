defmodule Moby do
  @moduledoc """
  Implements a clone of the card game "Love Letter" by Z-Man Games.
  """

  alias Moby.{GameState, Types}

  defdelegate test, to: Moby.Test

  # TODO: fix or remove the manual test
  def new_game(_arg), do: :noop

  @doc """
  Start a game in the server, without any players.
  """
  @spec create_game() :: pid
  def create_game() do
    {:ok, pid} = Moby.Application.create_game()
    pid
  end

  @doc """
  Create a new Player in the game.
  """
  @spec join_game(pid, String.t()) :: :ok | :error
  def join_game(game_pid, player_name) do
    GenServer.call(game_pid, {:join_game, player_name})
    |> case do
      {:ok, players} ->
        IO.puts("Players: #{Enum.join(players, ", ")}")
        :ok

      {:error, message} ->
        IO.puts(message)
        :error
    end
  end

  @doc """
  Start a game in the server, using the players that have joined.
  """
  @spec start_game(pid) :: :ok
  def start_game(game_pid) do
    GenServer.call(game_pid, {:start_game})
    :ok
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
