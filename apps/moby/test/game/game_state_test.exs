defmodule Moby.GameStateTest do
  use ExUnit.Case, async: true

  alias Moby.{GameState, Player}

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

      assert GameState.state_for_player(game, joe) == game_for_joe
      assert GameState.state_for_player(game, ann) == game_for_ann
    end
  end

  describe "initialize/1" do
    test "starts a new game" do
      actual = GameState.initialize(["Joe", "Ann"])

      # Yoda assertion used for pattern matching on the random cards that were dealt
      assert %GameState{
               players: [
                 %Player{name: "Joe", current_cards: joe_current_cards},
                 %Player{name: "Ann", current_cards: ann_current_cards}
               ],
               deck: deck,
               removed_card: removed_card,
               face_up_cards: face_up_cards
             } = actual

      sorted_deck = ~w[baron baron countess guard guard guard guard guard handmaid
        handmaid king priest priest prince prince princess]a

      actual_cards =
        (joe_current_cards ++
           ann_current_cards ++
           deck ++
           face_up_cards ++
           [removed_card])
        |> Enum.sort()

      assert actual_cards == sorted_deck
    end
  end

  describe "set_move/2" do
    setup do
      game = %GameState{
        players: [
          %Player{name: "Joe", current_cards: [:handmaid, :king]},
          %Player{name: "Ann", current_cards: [:prince]}
        ],
        deck:
          Enum.shuffle(
            ~w[princess countess prince handmaid baron baron priest guard guard guard guard guard]a
          ),
        removed_card: :priest
      }

      [game: game]
    end

    test "accepts a move with a valid non-targeted card", context do
      move = %{played_card: :handmaid}
      expected = %GameState{context[:game] | latest_move: move}

      actual = GameState.set_move(context[:game], move)

      assert actual == expected
    end

    test "accepts a move with a valid targeted card", context do
      game = %GameState{players: [_joe, ann]} = context[:game]
      move = %{played_card: :king, target: "Ann"}
      expected = %GameState{game | latest_move: move, target_player: ann}

      actual = GameState.set_move(game, move)

      assert actual == expected
    end

    test "accepts a move with a valid card but invalid target", context do
      game = %GameState{players: [joe, _ann]} = context[:game]
      move = %{played_card: :king, target: "Joe"}
      expected = %GameState{game | latest_move: move, target_player: joe}

      actual = GameState.set_move(game, move)

      assert actual == expected
    end

    test "accepts even a move with an invalid card", context do
      move = %{played_card: :ace_of_spades}
      expected = %GameState{context[:game] | latest_move: move}

      actual = GameState.set_move(context[:game], move)

      assert actual == expected
    end
  end
end
