defmodule Moby.Baron do
  alias Moby.{Action, GameState, Victory}

  @spec play(GameState.t(), String.t()) :: GameState.t()
  def play(game, target_name) do
    [hd(game.players), Moby.Player.find(game, target_name)]
    |> Enum.map(&Victory.player_score/1)
    |> do_winner(game)
  end

  @spec do_winner([{Moby.Player, pos_integer()}], GameState.t()) :: GameState.t()
  defp do_winner([{self, self_score} | [{target, target_score}]], game) do
    cond do
      self_score > target_score ->
        Action.execute(game, target, {Action, :lose, []})

      self_score < target_score ->
        Action.execute(game, self, {Action, :lose, []})

      self_score == target_score ->
        game
    end
  end
end
