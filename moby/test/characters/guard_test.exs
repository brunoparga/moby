defmodule Moby.GuardTest do
  use ExUnit.Case

  alias Moby.{Action, GameState, Player}

  describe "play/1" do
    test "target player has the guessed card and loses" do
      joe = %Player{name: "Joe", current_cards: [:guard, :princess]}
      ann = %Player{name: "Ann", current_cards: [:baron]}

      move = %{played_card: :guard, target: "Ann", named_card: :baron}

      game =
        %GameState{players: [joe, ann], deck: ~w[countess king prince prince handmaid
        handmaid baron priest guard guard guard guard]a, removed_card: :priest}
        |> GameState.set_move(move)
        |> Action.execute_current({Action, :play_card, [:guard]})

      actual = Moby.Guard.play(game)

      expected_joe = %Player{joe | current_cards: [:princess], played_cards: [:guard]}
      expected_ann = %Player{ann | current_cards: [:baron], active?: false}
      expected = %GameState{game | players: [expected_joe, expected_ann]}

      assert actual == expected
    end

    test "target player has other card; nothing happens" do
      joe = %Player{name: "Joe", current_cards: [:guard, :baron]}
      ann = %Player{name: "Ann", current_cards: [:princess]}

      move = %{played_card: :guard, target: "Ann", named_card: :baron}

      game =
        %GameState{players: [joe, ann], deck: ~w[countess king prince prince handmaid
        handmaid baron priest guard guard guard guard]a, removed_card: :priest}
        |> GameState.set_move(move)
        |> Action.execute_current({Action, :play_card, [:guard]})

      actual = Moby.Guard.play(game)

      expected_joe = %Player{joe | current_cards: [:baron], played_cards: [:guard]}
      expected = %GameState{game | players: [expected_joe, ann]}

      assert actual == expected
    end
  end
end
