defmodule Moby.PrinceTest do
  use ExUnit.Case

  alias Moby.{Action, GameState, Player}

  describe "play/1" do
    test "target another player" do
      joe = %Player{name: "Joe", current_cards: [:prince, :king]}
      ann = %Player{name: "Ann", current_cards: [:guard]}

      move = %{played_card: :prince, target: "Ann"}

      game = %GameState{players: [joe, ann], deck: ~w[princess countess prince handmaid handmaid
        baron baron priest guard guard guard guard]a, removed_card: :priest}
        |> GameState.set_move(move)
        |> Action.execute_current({Action, :play_card, [:prince]})
        
      actual = Moby.Prince.play(game)

      expected_joe = %Player{joe | current_cards: [:king], played_cards: [:prince]}
      expected_ann = %Player{ann | current_cards: [:princess], played_cards: [:guard]}
      expected = %GameState{game | players: [expected_joe, expected_ann],
                                   deck: ~w[countess prince handmaid handmaid
                                     baron baron priest guard guard guard guard]a}

      assert actual == expected
    end
  end
end
