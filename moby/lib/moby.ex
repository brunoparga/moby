defmodule Moby do
  @moduledoc """
  Implements a clone of the card game "Love Letter" by Z-Man Games.
  """

  def new_game() do
    {:ok, pid} = Supervisor.start_child(Moby.Supervisor, [])
    pid
  end

  def game_state(game_pid) do
    GenServer.call(game_pid, {:game_state})
  end

  def make_move(game_pid, card) do
    # TODO: Move must include the card played and any options
    # (target player and named card for Guard)
    # (target player for Priest, Baron, Prince and King)
    GenServer.call(game_pid, {:make_move, card})
  end
end
