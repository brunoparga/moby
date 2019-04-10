defmodule Moby.GameFlowTest do
  use ExUnit.Case

  import Moby.GameFlow

  alias Moby.{GameState, Player}

  describe "new_game/0" do
    # This is just a composition of GameState.initialize/0 and Countess.check/1.
    # Please refer to the tests for those functions.
  end

  describe "make_move/2" do
    # This is just a composition of GameState.set_move/2 and Validate.validate/1.
    # Please refer to the tests for those functions.
  end

  describe "move_is_valid/1" do
    # This is just a composition of Dispatch.move/1 and Victory.check/1.
    # Please refer to the tests for those functions.
  end

  describe "continue/1" do
    test "a game with an empty deck exits" do
      game = %GameState{
        players: [
          %Player{name: "Banana", current_cards: [:princess]},
          %Player{current_cards: [:guard]}
        ],
        deck: []
      }

      assert catch_exit(continue(game)) == :normal
    end

    test "a game with cards left in the deck continues" do
      game = %GameState{
        players: [
          %Player{name: "Ann", current_cards: [:princess], played_cards: [:king]},
          %Player{name: "Joe", current_cards: [:baron], played_cards: [:guard]}
        ],
        deck: ~w[countess prince prince handmaid handmaid baron priest guard guard guard guard]a,
        removed_card: :priest,
        latest_move: %{played_card: :king, target: "Joe"},
        target_player: %Player{name: "Joe", current_cards: [:baron], played_cards: [:guard]}
      }

      expected = %GameState{
        game
        | players: [
            %Player{name: "Joe", current_cards: [:baron, :countess], played_cards: [:guard]},
            %Player{name: "Ann", current_cards: [:princess], played_cards: [:king]}
          ],
          deck: tl(game.deck),
          latest_move: nil,
          target_player: nil
      }

      actual = continue(game)

      assert actual == expected
    end
  end

  describe "reset_move/1" do
    test "clears the game's latest move and target player fields" do
      game = expected = GameState.initialize()
      temp = GameState.set_move(game, %{played_card: :priest, target: "Ann"})

      actual = reset_move(temp)

      assert actual == expected
    end
  end
end
