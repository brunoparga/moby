defmodule Moby.Player do
  @moduledoc """
  Represents a Love Letter player.
  """

  defstruct name: "", current_cards: [], played_cards: [], active?: true
  # TODO: include score key in the struct, once many-round play is implemented

  def play_card(player, played_card) do
    player
    |> remove_from_hand(played_card)
    |> add_to_discarded(played_card)
  end

  def draw_card(player, dealt_card) do
    Map.put(player, :current_cards, player.current_cards ++ [dealt_card])
  end

  def lose(player) do
    Map.put(player, :active?, false)
  end

  defp remove_from_hand(player, card) do
    Map.put(player, :current_cards, player.current_cards |> List.delete(card))
  end

  defp add_to_discarded(player, card) do
    Map.put(player, :played_cards, player.played_cards ++ [card])
  end
end
