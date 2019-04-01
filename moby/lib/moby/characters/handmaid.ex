defmodule Moby.Handmaid do
  alias Moby.{GameState, Player}

  @spec end_own_protection(GameState.t()) :: GameState.t()
  def end_own_protection(game) do
    if hd(game.players).protected?, do: end_protection(game), else: game
  end

  @spec play(GameState.t()) :: GameState.t()
  def play(game) do
    Moby.Action.execute_current(game, {__MODULE__, :protect, []})
  end

  @spec end_protection(GameState.t()) :: GameState.t()
  defp end_protection(game) do
    Moby.Action.execute_current(game, {__MODULE__, :unprotect, []})
  end

  @spec protect(Player.t()) :: Player.t()
  def protect(player) do
    Map.put(player, :protected?, true)
  end

  @spec unprotect(Player.t()) :: Player.t()
  def unprotect(player) do
    Map.put(player, :protected?, false)
  end
end
