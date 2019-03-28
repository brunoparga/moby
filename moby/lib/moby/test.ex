defmodule Moby.Test do
  @moduledoc """
  Automate running the game.
  """

  @doc """
  Starts a game and keeps prompting the player for a move, which is executed.
  """
  def test do
    Moby.new_game()
    |> make_move()
  end

  defp make_move(pid) do
    Moby.game_state(pid)
    |> IO.inspect()

    card = IO.gets("Choose a card: ") |> String.trim() |> String.to_atom()

    cond do
      card in ~w[princess countess handmaid]a ->
        Moby.make_move(pid, card)

      card in ~w[king prince baron priest]a ->
        target = IO.gets("Choose target player: ") |> String.trim()
        Moby.make_move(pid, {card, target})

      card == :guard ->
        target = IO.gets("Choose target player: ") |> String.trim()
        named_card = IO.gets("Choose a non-Guard card: ") |> String.trim() |> String.to_atom()
        Moby.make_move(pid, :guard)
    end

    make_move(pid)
  end
end
