defmodule Moby.Handmaid do
  def end_own_protection(game) do
    if hd(game.players).protected?, do: end_protection(game), else: game
  end

  def check_protected(game, move) when is_atom(move), do: game

  def check_protected(game, {:guard, target, _card}), do: check(game, target)

  def check_protected(game, {_card, target}), do: check(game, target)

  def play(game) do
    Moby.Action.execute_current(game, {__MODULE__, :protect, []})
  end

  defp end_protection(game) do
    Moby.Action.execute_current(game, {__MODULE__, :unprotect, []})
  end

  defp check(game, target) do
    if Moby.Player.find(game, target).protected?, do: set_protected(game), else: game
  end

  def protect(player) do
    Map.put(player, :protected?, true)
  end

  def unprotect(player) do
    Map.put(player, :protected?, false)
  end

  defp set_protected(game) do
    Map.put(game, :target_protected, true)
  end
end
