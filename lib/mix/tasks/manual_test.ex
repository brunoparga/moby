defmodule Mix.Tasks.ManualTest do
  @moduledoc """
  Run the manual test, where one can play as both players in the terminal.
  The full state of the game is shown.
  """
  use Mix.Task

  @shortdoc "Plays Love Letter in the terminal"
  def run(_args) do
    Mix.Task.run("app.start")
    IO.puts(rules())
    Moby.test()
  end

  defp rules() do
    """
    ==========
    Welcome to MobyLetty, a clone of Love Letter.

    Each player starts the game with one card. When it is their turn, a player
    draws another card and must play one of the two in their hand. The goal is
    to either eliminate the other player or to have the highest-valued card when
    the deck runs out.

    The cards are as follows. The first number is their point value, the one at
    the end is how many of them are in the deck.

    8: Princess - player is eliminated if discarded.                                 (1)
    7: Countess - must be discarded if in the hand with the King or Prince.          (1)
    6: King     - exchange hands with another player.                                (1)
    5: Prince   - target player must discard.                                        (2)
    4: Handmaid - one-round protection from being targeted.                          (2)
    3: Baron    - compare hands, lowest value is eliminated.                         (2)
    2: Priest   - see target player's hand (but for now, the full game state shown)  (2)
    1: Guard    - guess what's in the target player's hand and they're out.          (5)
    ==========
    """
  end
end
