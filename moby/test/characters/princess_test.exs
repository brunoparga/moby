defmodule Moby.PrincessTest do
  use ExUnit.Case, async: true

  alias Moby.{Action, GameState, Player}

  describe "play/1" do
    test "spontaneously playing the Princess renders the player inactive" do
      joe = %Player{name: "Joe", current_cards: [:princess, :king]}
      ann = %Player{name: "Ann", current_cards: [:guard]}

      move = %{played_card: :princess}

      game =
        %GameState{players: [joe, ann], deck: ~w[prince countess prince handmaid handmaid
        baron baron priest guard guard guard guard]a, removed_card: :priest}
        |> GameState.set_move(move)

      actual = Action.execute_current(game, {Action, :play_card, [:princess]})

      expected_joe = %Player{
        joe
        | current_cards: [:king],
          played_cards: [:princess],
          active?: false
      }

      expected = %GameState{game | players: [expected_joe, ann]}

      assert actual == expected
    end

    test "being forced to play the Princess renders the player inactive" do
      joe = %Player{name: "Joe", current_cards: [:prince, :king]}
      ann = %Player{name: "Ann", current_cards: [:princess]}

      move = %{played_card: :prince, target: "Ann"}

      game =
        %GameState{players: [joe, ann], deck: ~w[countess prince handmaid handmaid
        baron baron priest guard guard guard guard]a, removed_card: :priest}
        |> GameState.set_move(move)
        |> Action.execute_current({Action, :play_card, [:prince]})

      actual = Moby.Prince.play(game)

      expected_joe = %Player{joe | current_cards: [:king], played_cards: [:prince]}
      expected_ann = %Player{ann | current_cards: [], played_cards: [:princess], active?: false}

      expected = %GameState{game | players: [expected_joe, expected_ann]}

      assert actual == expected
    end
  end
end
