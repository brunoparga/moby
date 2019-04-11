defmodule Moby.VictoryTest do
  use ExUnit.Case, async: true

  import Moby.Victory

  alias Moby.{GameState, Player}

  describe "check/1" do
    # TODO: decide what to do about the two paths through this function that call won/1.
    test "lets the game continue when more than one player is active" do
      game = %GameState{
        players: [
          %Player{
            name: "Joe",
            current_cards: [:princess],
            played_cards: [:priest],
            active?: true
          },
          %Player{name: "Ann", current_cards: [:guard], played_cards: [], active?: true}
        ],
        deck:
          ~w[countess king prince prince handmaid handmaid baron baron guard guard guard guard]a,
        removed_card: :priest,
        latest_move: %{played_card: :priest, target: "Ann"},
        target_player: %Player{name: "Ann", current_cards: [:guard]}
      }

      expected = %GameState{
        players: [
          %Player{
            active?: true,
            current_cards: [:guard, :countess],
            name: "Ann",
            played_cards: [],
            protected?: false
          },
          %Player{
            active?: true,
            current_cards: [:princess],
            name: "Joe",
            played_cards: [:priest],
            protected?: false
          }
        ],
        deck: tl(game.deck),
        removed_card: :priest,
        latest_move: nil,
        target_player: nil
      }

      actual = Moby.GameFlow.continue(game)

      assert actual == expected
    end
  end

  describe "won/1" do
    test "exits when called on a game with a winner" do
      game = GameState.initialize()
      game = Map.put(game, :winner, hd(tl(game.players)))

      catch_exit(won(game) == :normal)
    end

    test "fails when called on a game without a winner" do
      game = GameState.initialize()

      catch_error(won(game))
    end
  end

  describe "round_over/1" do
    # TODO: How to test this if won/1 exits?
  end

  describe "score_player/1" do
    test "scores the Princess" do
      player = %Player{current_cards: [:princess]}
      expected = {player, 8}

      actual = score_player(player)

      assert actual == expected
    end

    test "scores the Countess" do
      player = %Player{current_cards: [:countess]}
      expected = {player, 7}

      actual = score_player(player)

      assert actual == expected
    end

    test "scores the King" do
      player = %Player{current_cards: [:king]}
      expected = {player, 6}

      actual = score_player(player)

      assert actual == expected
    end

    test "scores the Prince" do
      player = %Player{current_cards: [:prince]}
      expected = {player, 5}

      actual = score_player(player)

      assert actual == expected
    end

    test "scores the Handmaid" do
      player = %Player{current_cards: [:handmaid]}
      expected = {player, 4}

      actual = score_player(player)

      assert actual == expected
    end

    test "scores the Baron" do
      player = %Player{current_cards: [:baron]}
      expected = {player, 3}

      actual = score_player(player)

      assert actual == expected
    end

    test "scores the Priest" do
      player = %Player{current_cards: [:priest]}
      expected = {player, 2}

      actual = score_player(player)

      assert actual == expected
    end

    test "scores the Guard" do
      player = %Player{current_cards: [:guard]}
      expected = {player, 1}

      actual = score_player(player)

      assert actual == expected
    end
  end
end
