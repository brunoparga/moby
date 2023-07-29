defmodule Moby.ValidateTest do
  use ExUnit.Case, async: true

  alias Moby.{GameState, Player, Validate}

  describe "validate/1" do
    test "a valid game is allowed to proceed" do
      joe = %Player{name: "Joe", current_cards: [:handmaid, :king]}

      ann = %Player{name: "Ann", current_cards: [:prince]}

      game =
        %GameState{
          players: [joe, ann],
          deck:
            ~w[princess countess prince handmaid baron baron priest guard guard guard guard guard]a,
          removed_card: :priest
        }
        |> GameState.set_move(%{played_card: :handmaid})

      expected_joe = %Player{
        joe
        | current_cards: [:king],
          played_cards: [:handmaid],
          protected?: true
      }

      expected_ann = %Player{ann | current_cards: [:prince, :princess]}

      expected = %GameState{
        game
        | players: [expected_ann, expected_joe],
          deck: tl(game.deck),
          latest_move: nil
      }

      actual = Validate.validate(game)

      assert actual == expected
    end

    test "an invalid game (named card is Guard) is reset" do
      joe = %Player{name: "Joe", current_cards: [:handmaid, :guard]}

      ann = %Player{name: "Ann", current_cards: [:prince]}

      game =
        %GameState{
          players: [joe, ann],
          deck:
            ~w[princess countess king prince handmaid baron baron priest guard guard guard guard]a,
          removed_card: :priest
        }
        |> GameState.set_move(%{played_card: :guard, target: "Ann", named_card: :guard})

      expected = %GameState{game | latest_move: nil, target_player: nil}

      actual = Validate.validate(game)

      assert actual == expected
    end

    test "an invalid game (player doesn't have the card) is reset" do
      joe = %Player{name: "Joe", current_cards: [:handmaid, :guard]}

      ann = %Player{name: "Ann", current_cards: [:prince]}

      game =
        %GameState{
          players: [joe, ann],
          deck:
            ~w[princess countess king prince handmaid baron baron priest guard guard guard guard]a,
          removed_card: :priest
        }
        |> GameState.set_move(%{played_card: :princess})

      expected = %GameState{game | latest_move: nil, target_player: nil}

      actual = Validate.validate(game)

      assert actual == expected
    end

    test "an invalid game (target is out of the round) is reset" do
      joe = %Player{name: "Joe", current_cards: [:handmaid, :baron]}

      ann = %Player{name: "Ann", active?: false}

      game =
        %GameState{
          players: [joe, ann],
          deck:
            ~w[princess countess king prince handmaid baron priest guard guard guard guard guard]a,
          removed_card: :priest
        }
        |> GameState.set_move(%{played_card: :baron, target: "Ann"})

      expected = %GameState{game | latest_move: nil, target_player: nil}

      actual = Validate.validate(game)

      assert actual == expected
    end

    test "an invalid game (violates Lonely Prince constraint) is reset" do
      joe = %Player{name: "Joe", current_cards: [:princess, :prince]}

      ann = %Player{name: "Ann", current_cards: [:prince], protected?: true}

      game =
        %GameState{
          players: [joe, ann],
          deck:
            ~w[countess king prince handmaid handmaid baron priest guard guard guard guard guard]a,
          removed_card: :priest
        }
        |> GameState.set_move(%{played_card: :prince, target: "Ann"})

      expected = %GameState{game | latest_move: nil, target_player: nil}

      actual = Validate.validate(game)

      assert actual == expected
    end
  end
end
