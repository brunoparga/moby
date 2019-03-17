defmodule Moby.Player do
  @moduledoc """
  Represents a Love Letter player.
  """

  defstruct name: "", current_cards: [], played_cards: []
  # TODO: include score key in the struct, once many-round play is implemented

  def update_card(player, card) do
    player
    |> play(card)
    |> add_discarded(card)
  end

  defp play(player, card) do
    Map.put(player, :current_cards, player.current_cards |> List.delete(card))
  end

  defp add_discarded(player, card) do
    Map.put(player, :played_cards, player.played_cards ++ [card])
  end
end
