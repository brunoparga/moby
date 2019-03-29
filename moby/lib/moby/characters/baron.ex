defmodule Moby.Baron do
  alias Moby.{Action, GameState, Victory}

  @spec play(GameState.t(), String.t()) :: GameState.t()
  def play(game, target_name) do
    [hd(game.players), Moby.Player.find(game, target_name)]
    |> Enum.map(&Victory.player_score/1)
    |> check_winner(game)
  end

  defp check_winner([{self, self_score} | [{target, target_score}]], game) do
    cond do
      self_score > target_score ->
        lose(game, target)

      self_score < target_score ->
        lose(game, self)

      self_score == target_score ->
        game
    end
  end

  defp lose(game, player) do
    Action.execute(game, player, {Action, :lose, []})
  end
end
