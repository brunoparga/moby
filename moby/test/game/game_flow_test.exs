defmodule Moby.GameFlowTest do
  use ExUnit.Case

  alias Moby.Player

  describe "new_game/0" do
    test "starts a new game" do
      actual = Moby.GameFlow.new_game()

      assert %Moby.GameState{
        players: [
          %Player{
            name: "Joe",
            current_cards: joe_current_cards,
            played_cards: joe_played_cards,
            active?: true,
            protected?: false
          },
          %Player{
            name: "Ann",
            current_cards: ann_current_cards,
            played_cards: [],
            active?: true,
            protected?: false
          }
        ],
        deck: deck,
        removed_card: removed_card,
        winner: nil,
        latest_move: nil,
        target_player: nil
      } = actual

      sorted_deck = ~w[baron baron countess guard guard guard guard guard handmaid
        handmaid king priest priest prince prince princess]a

      actual_cards =
        joe_current_cards ++
        joe_played_cards ++
        ann_current_cards ++
        deck ++
        [removed_card]
        |> Enum.sort

        assert actual_cards == sorted_deck
    end
  end
end
