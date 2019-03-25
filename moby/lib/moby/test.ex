defmodule Moby.Test do
  def test do
    Moby.new_game()
    |> make_move()
  end

  defp make_move(pid) do
    Moby.game_state(pid)
    |> IO.inspect
    card = IO.gets("Choose a card: ") |> String.trim() |> String.to_atom()
    Moby.make_move(pid, card)
    make_move(pid)
  end
end
