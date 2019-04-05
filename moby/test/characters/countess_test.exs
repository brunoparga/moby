defmodule Moby.CountessTest do
  use ExUnit.Case

  alias Moby.{GameState, Player}

  describe "check/1" do
    test "a player with countess/king or countess/prince must play countess" do
      joe = %Player{name: "Joe", current_cards: [:countess, :king]}
      ann = %Player{name: "Ann", current_cards: [:guard]}

      game = %GameState{players: [joe, ann], deck: ~w[princess prince prince handmaid
        handmaid baron baron priest guard guard guard guard]a, removed_card: :priest}

      actual = Moby.Countess.check(game)

      expected_joe = %Player{joe | current_cards: [:king], played_cards: [:countess]}
      expected_ann = %Player{ann | current_cards: [:guard, :princess]}
      expected = %GameState{game | players: [expected_ann, expected_joe], deck: tl(game.deck)}

      assert actual == expected
    end

    test "a player with the countess and any other card isn't forced to play her" do
      joe = %Player{name: "Joe", current_cards: [:countess, :priest]}
      ann = %Player{name: "Ann", current_cards: [:guard]}

      game = %GameState{players: [joe, ann], deck: ~w[princess prince prince handmaid
        handmaid baron baron priest guard guard guard guard]a, removed_card: :king}

      actual = Moby.Countess.check(game)

      assert actual == game
    end

    test "a player without the countess cannot play her" do
      joe = %Player{name: "Joe", current_cards: [:princess, :priest]}
      ann = %Player{name: "Ann", current_cards: [:guard]}

      game =
        %GameState{players: [joe, ann], deck: ~w[countess prince prince handmaid
        handmaid baron baron priest guard guard guard guard]a, removed_card: :king}
        |> Moby.Countess.check()

      refute :countess in hd(game.players).played_cards
    end
  end
end
