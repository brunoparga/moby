defmodule Moby.DisplayTest do
  use ExUnit.Case, async: true

  alias Moby.{Display, GameState}

  describe "state_for_player/1" do
    test "returns what the current player can see" do
      game = %GameState{players: [joe, ann]} = GameState.initialize(["Joe", "Ann"])

      expected_ann =
        ann
        |> Map.from_struct()
        |> Map.delete(:current_cards)

      game_for_joe =
        game
        |> Map.from_struct()
        |> Map.put(:players, [joe, expected_ann])
        |> Map.drop(~w[winner deck removed_card latest_move target_player]a)
        |> Map.put(:up_to_play?, true)

      expected_joe =
        joe
        |> Map.from_struct()
        |> Map.delete(:current_cards)

      game_for_ann =
        game
        |> Map.from_struct()
        |> Map.put(:players, [expected_joe, ann])
        |> Map.drop(~w[winner deck removed_card latest_move target_player]a)
        |> Map.put(:up_to_play?, false)

      assert Display.state_for_player(game, joe) == game_for_joe
      assert Display.state_for_player(game, ann) == game_for_ann
    end
  end
end
