defmodule Moby.DispatchTest do
  use ExUnit.Case, async: true

  import Moby.Dispatch

  alias Moby.{GameState, Player}

  setup_all do
    game = %GameState{
      players: [%Player{name: "Ann", current_cards: [:priest]}],
      deck: ~w[king prince prince handmaid handmaid baron baron guard guard guard guard]a,
      removed_card: :priest
    }

    [game: game]
  end

  describe "move/1" do
    test "moves the card and inactivates player with the Princess", context do
      joe = %Player{name: "Joe", current_cards: [:countess, :princess]}

      game =
        %GameState{context[:game] | players: [joe | context[:game].players]}
        |> GameState.set_move(%{played_card: :princess})

      expected_joe = %Player{
        joe
        | current_cards: [],
          played_cards: [:princess, :countess],
          active?: false
      }

      expected = %GameState{game | players: [expected_joe | tl(game.players)]}

      assert move(game) == expected
    end

    test "just makes the move with the Countess", context do
      joe = %Player{name: "Joe", current_cards: [:countess, :princess]}

      game =
        %GameState{context[:game] | players: [joe | context[:game].players]}
        |> GameState.set_move(%{played_card: :countess})

      expected_joe = %Player{joe | current_cards: [:princess], played_cards: [:countess]}
      expected = %GameState{game | players: [expected_joe | tl(game.players)]}

      assert move(game) == expected
    end

    test "plays the King and calls the character module", context do
      joe = %Player{name: "Joe", current_cards: [:king, :princess]}

      game =
        %GameState{context[:game] | players: [joe | context[:game].players]}
        |> GameState.set_move(%{played_card: :king, target: "Ann"})

      expected_joe = %Player{joe | current_cards: [:priest], played_cards: [:king]}
      expected_ann = %Player{name: "Ann", current_cards: [:princess]}
      expected = %GameState{game | players: [expected_joe, expected_ann]}

      assert move(game) == expected
    end

    test "plays the Prince and calls the character module", context do
      joe = %Player{name: "Joe", current_cards: [:prince, :princess]}

      game =
        %GameState{context[:game] | players: [joe | context[:game].players]}
        |> GameState.set_move(%{played_card: :prince, target: "Ann"})

      expected_joe = %Player{joe | current_cards: [:princess], played_cards: [:prince]}
      expected_ann = %Player{name: "Ann", current_cards: [:king], played_cards: [:priest]}
      expected = %GameState{game | players: [expected_joe, expected_ann], deck: tl(game.deck)}

      assert move(game) == expected
    end

    test "self-plays the Prince and calls the character module", context do
      joe = %Player{name: "Joe", current_cards: [:prince, :guard]}

      game =
        %GameState{context[:game] | players: [joe | context[:game].players]}
        |> GameState.set_move(%{played_card: :prince, target: "Joe"})

      expected_joe = %Player{joe | current_cards: [:king], played_cards: [:prince, :guard]}

      expected = %GameState{
        game
        | players: [expected_joe | tl(game.players)],
          deck: tl(game.deck)
      }

      assert move(game) == expected
    end

    test "plays the Handmaid and calls the character module", context do
      joe = %Player{name: "Joe", current_cards: [:guard, :handmaid]}

      game =
        %GameState{context[:game] | players: [joe | context[:game].players]}
        |> GameState.set_move(%{played_card: :handmaid})

      expected_joe = %Player{
        joe
        | current_cards: [:guard],
          played_cards: [:handmaid],
          protected?: true
      }

      expected = %GameState{game | players: [expected_joe | tl(game.players)]}

      assert move(game) == expected
    end

    test "plays the Baron (wins) and calls the character module", context do
      joe = %Player{name: "Joe", current_cards: [:baron, :countess]}

      game =
        %GameState{context[:game] | players: [joe | context[:game].players]}
        |> GameState.set_move(%{played_card: :baron, target: "Ann"})

      expected_joe = %Player{joe | current_cards: [:countess], played_cards: [:baron]}

      expected_ann = %Player{
        name: "Ann",
        current_cards: [],
        played_cards: [:priest],
        active?: false
      }

      expected = %GameState{game | players: [expected_joe, expected_ann]}

      assert move(game) == expected
    end

    test "plays the Baron (loses) and calls the character module", context do
      joe = %Player{name: "Joe", current_cards: [:baron, :countess]}
      ann = %Player{name: "Ann", current_cards: [:princess]}

      game =
        %GameState{context[:game] | players: [joe, ann]}
        |> GameState.set_move(%{played_card: :baron, target: "Ann"})

      expected_joe = %Player{
        joe
        | current_cards: [],
          played_cards: [:baron, :countess],
          active?: false
      }

      expected_ann = %Player{name: "Ann", current_cards: [:princess]}
      expected = %GameState{game | players: [expected_joe, expected_ann]}

      assert move(game) == expected
    end

    test "plays the Priest and calls the character module", context do
      # TODO: see if implementing the Priest changes this test
      joe = %Player{name: "Joe", current_cards: [:baron, :priest]}

      game =
        %GameState{context[:game] | players: [joe | context[:game].players]}
        |> GameState.set_move(%{played_card: :priest, target: "Ann"})

      expected_joe = %Player{joe | current_cards: [:baron], played_cards: [:priest]}
      expected = %GameState{game | players: [expected_joe | tl(game.players)]}

      assert move(game) == expected
    end

    test "plays the Guard (hits) and calls the character module", context do
      joe = %Player{name: "Joe", current_cards: [:baron, :guard]}

      game =
        %GameState{context[:game] | players: [joe | context[:game].players]}
        |> GameState.set_move(%{played_card: :guard, target: "Ann", named_card: :priest})

      expected_joe = %Player{joe | current_cards: [:baron], played_cards: [:guard]}

      expected_ann = %Player{
        name: "Ann",
        current_cards: [],
        played_cards: [:priest],
        active?: false
      }

      expected = %GameState{game | players: [expected_joe, expected_ann]}

      assert move(game) == expected
    end

    test "plays the Guard (misses) and calls the character module", context do
      joe = %Player{name: "Joe", current_cards: [:baron, :guard]}

      game =
        %GameState{context[:game] | players: [joe | context[:game].players]}
        |> GameState.set_move(%{played_card: :guard, target: "Ann", named_card: :king})

      expected_joe = %Player{joe | current_cards: [:baron], played_cards: [:guard]}
      expected = %GameState{game | players: [expected_joe | tl(game.players)]}

      assert move(game) == expected
    end
  end
end
