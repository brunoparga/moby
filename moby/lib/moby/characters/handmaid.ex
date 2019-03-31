defmodule Moby.Handmaid do
  alias Moby.{GameState, Player}

  @spec end_own_protection(GameState.t()) :: GameState.t()
  def end_own_protection(game) do
    if hd(game.players).protected?, do: end_protection(game), else: game
  end

  @spec check_protected(GameState.t(), atom) :: GameState.t()
  def check_protected(game, move) when is_atom(move), do: game

  @spec check_protected(GameState.t(), {atom, String.t(), atom}) :: GameState.t()
  def check_protected(game, {:guard, target, _card}), do: check(game, target)

  @spec check_protected(GameState.t(), {atom, String.t()}) :: GameState.t()
  def check_protected(game, {_card, target}), do: check(game, target)

  @spec play(GameState.t()) :: GameState.t()
  def play(game) do
    Moby.Action.execute_current(game, {__MODULE__, :protect, []})
  end

  @spec end_protection(GameState.t()) :: GameState.t()
  defp end_protection(game) do
    Moby.Action.execute_current(game, {__MODULE__, :unprotect, []})
  end

  @spec check(GameState.t(), String.t()) :: GameState.t()
  defp check(game, target) do
    if Moby.Player.find(game, target).protected?, do: set_protected(game), else: game
  end

  @spec protect(Player.t()) :: Player.t()
  def protect(player) do
    Map.put(player, :protected?, true)
  end

  @spec unprotect(Player.t()) :: Player.t()
  def unprotect(player) do
    Map.put(player, :protected?, false)
  end

  @spec set_protected(GameState.t()) :: GameState.t()
  defp set_protected(game) do
    Map.put(game, :target_protected, true)
  end
end
