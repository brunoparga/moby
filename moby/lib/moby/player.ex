defmodule Moby.Player do
  @moduledoc """
  Represents a Love Letter player.
  """

  alias Moby.{Game, Victory}

  defstruct name: "", current_cards: [], played_cards: [], active?: true
  # TODO: include score key in the struct, once many-round play is implemented

  def move(game, :princess) do
    update_current(game, &lose/2)
  end

  def move(game, played_card) do
    update_current(game, &play_card/2, played_card)
  end

  def move(game, :king, target) do
    target_player = find(game, target)
    update_current(game, &play_card/2, :king)
    |> Moby.King.play(target_player)
  end

  def next(game = %Game{deck: []}), do: Victory.round_over(game)

  def next(game) do
    [drawn_card | new_deck] = game.deck

    update_current(game, &draw_card/2, drawn_card)
    |> Map.put(:deck, new_deck)
    |> Moby.Countess.check()
  end

  def update_current(game, function, args \\ nil) do
    hd(game.players) |> update(game, function, args)
  end

  defp find(game, player_name) do
    Enum.find(game.players, fn x -> x.name == player_name end)
  end

  def update(player, game, function, args \\ nil) do
    players = build_new_players(player, game.players, function, args)
    %Game{game | players: players}
  end

  defp build_new_players(player, players, function, args) do
    index = find_index(players, player)
    List.update_at(players, index, fn _ -> function.(player, args) end)
  end

  defp find_index(players, player) do
    Enum.find_index(players, fn x -> x == player end)
  end

  defp play_card(player, played_card) do
    player
    |> remove_from_hand(played_card)
    |> add_to_discarded(played_card)
  end

  defp draw_card(player, drawn_card) do
    Map.put(player, :current_cards, player.current_cards ++ [drawn_card])
  end

  defp lose(player, _) do
    Map.put(player, :active?, false)
  end

  defp remove_from_hand(player, card) do
    Map.put(player, :current_cards, player.current_cards |> List.delete(card))
  end

  defp add_to_discarded(player, card) do
    Map.put(player, :played_cards, player.played_cards ++ [card])
  end
end
