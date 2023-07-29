defmodule Moby.HandmaidTest do
  use ExUnit.Case, async: true

  alias Moby.{Action, GameState, Player}

  describe "end_own_protection/1" do
    test "a player loses protection at the beginning of their round" do
      game = %GameState{players: [%Player{protected?: true}]}

      actual = Moby.Handmaid.end_own_protection(game)

      expected = %GameState{players: [%Player{protected?: false}]}

      assert actual == expected
    end

    test "an unprotected player remains as such" do
      game = %GameState{players: [%Player{protected?: false}]}

      actual = Moby.Handmaid.end_own_protection(game)

      forbidden = %GameState{players: [%Player{protected?: true}]}

      refute actual == forbidden
    end
  end

  describe "play/1" do
    test "protect player who plays the Handmaid" do
      joe = %Player{name: "Joe", current_cards: [:handmaid, :king]}
      ann = %Player{name: "Ann", current_cards: [:baron]}

      game =
        %GameState{players: [joe, ann], deck: ~w[princess countess prince prince
      handmaid baron guard priest guard guard guard guard]a, removed_card: :priest}
        |> Action.execute_current({Action, :play_card, [:handmaid]})

      actual = Moby.Handmaid.play(game)

      expected_joe = %Player{
        joe
        | current_cards: [:king],
          played_cards: [:handmaid],
          protected?: true
      }

      expected = %GameState{game | players: [expected_joe, ann]}

      assert actual == expected
    end
  end
end
