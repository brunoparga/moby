defmodule Moby.Test do
  @moduledoc """
  Automate running the game.
  """

  import Moby.Types

  @doc """
  Starts a game and keeps prompting the player for a move, which is executed.
  """
  def test do
    Moby.new_game(["Fonk", "Tunts", "Blargh", "Zoid"])
    |> play_game()
  end

  defp play_game(game) do
    Moby.state_for_player_one(game)
    |> IO.inspect()

    card = get_card("Choose a card: ")

    cond do
      card == :guard ->
        target = get_target()
        play_guard(game, target)

      card in targeted_cards() ->
        Moby.make_move(game, %{played_card: card, target: get_target()})

      card in nontargeted_cards() ->
        Moby.make_move(game, %{played_card: card})
    end

    play_game(game)
  end

  defp play_guard(game, target) do
    named_card = get_card("Choose a non-Guard card: ")

    if named_card == :guard do
      IO.puts("You cannot guess the Guard. Choose another card: ")
      play_guard(game, target)
    else
      Moby.make_move(game, %{played_card: :guard, target: target, named_card: named_card})
    end
  end

  defp get_target() do
    IO.gets("Choose target player: ") |> String.trim()
  end

  defp get_card(prompt) do
    card = IO.gets(prompt) |> String.trim() |> String.to_atom()
    if card in valid_cards(), do: card, else: get_card("Invalid card. " <> prompt)
  end
end
