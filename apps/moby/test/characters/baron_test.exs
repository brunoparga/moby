defmodule Moby.BaronTest do
  use ExUnit.Case, async: true

  alias Moby.{Action, GameState, Player}

  describe "play/1" do
    test "when target player has a lower card" do
      joe = %Player{name: "Joe", current_cards: [:baron, :prince]}
      ann = %Player{name: "Ann", current_cards: [:guard]}

      move = %{played_card: :baron, target: "Ann"}

      game =
        %GameState{players: [joe, ann], deck: ~w[princess countess king prince handmaid
        handmaid baron priest guard guard guard guard]a, removed_card: :priest}
        |> GameState.set_move(move)
        |> Action.execute_current({Action, :play_card, [:baron]})

      actual = Moby.Baron.play(game)

      expected_joe = %Player{joe | current_cards: [:prince], played_cards: [:baron]}
      expected_ann = %Player{ann | current_cards: [], played_cards: [:guard], active?: false}
      expected = %GameState{game | players: [expected_joe, expected_ann]}

      assert actual == expected
    end

    test "when target player has a higher card" do
      joe = %Player{name: "Joe", current_cards: [:baron, :prince]}
      ann = %Player{name: "Ann", current_cards: [:princess]}

      move = %{played_card: :baron, target: "Ann"}

      game =
        %GameState{players: [joe, ann], deck: ~w[countess king prince handmaid
        handmaid baron priest guard guard guard guard guard]a, removed_card: :priest}
        |> GameState.set_move(move)
        |> Action.execute_current({Action, :play_card, [:baron]})

      actual = Moby.Baron.play(game)

      expected_joe = %Player{
        joe
        | current_cards: [],
          played_cards: [:baron, :prince],
          active?: false
      }

      expected = %GameState{game | players: [expected_joe, ann]}

      assert actual == expected
    end

    test "when target player has the same card" do
      joe = %Player{name: "Joe", current_cards: [:baron, :prince]}
      ann = %Player{name: "Ann", current_cards: [:prince]}

      move = %{played_card: :baron, target: "Ann"}

      game =
        %GameState{players: [joe, ann], deck: ~w[princess countess prince handmaid
        handmaid baron baron priest guard guard guard guard]a, removed_card: :priest}
        |> GameState.set_move(move)
        |> Action.execute_current({Action, :play_card, [:baron]})

      actual = Moby.Baron.play(game)

      expected_joe = %Player{joe | current_cards: [:prince], played_cards: [:baron]}
      expected = %GameState{game | players: [expected_joe, ann]}

      assert actual == expected
    end
  end
end
