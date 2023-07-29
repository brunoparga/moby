defmodule Moby.KingTest do
  use ExUnit.Case, async: true

  alias Moby.{Action, GameState, Player}

  describe "play/1" do
    test "exchange hands with another player" do
      joe = %Player{name: "Joe", current_cards: [:princess, :king]}
      ann = %Player{name: "Ann", current_cards: [:countess]}

      move = %{played_card: :king, target: "Ann"}

      game =
        %GameState{players: [joe, ann], deck: ~w[prince guard prince handmaid
        handmaid baron baron priest guard guard guard guard]a, removed_card: :priest}
        |> GameState.set_move(move)
        |> Action.execute_current({Action, :play_card, [:king]})

      actual = Moby.King.play(game)

      expected_joe = %Player{joe | current_cards: [:countess], played_cards: [:king]}
      expected_ann = %Player{ann | current_cards: [:princess]}
      expected = %GameState{game | players: [expected_joe, expected_ann]}

      assert actual == expected
    end
  end
end
