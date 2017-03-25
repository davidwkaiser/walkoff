require 'mlb_gameday'

class Game < ApplicationRecord
  def potential_walkoff?
    api = MLBGameday::API.new
    game = api.game(self.gid)
    inning = game.inning
    score_diff = game.score.first - game.score.last
    num_runners = game.runners.compact.count

    inning.first >=9 && inning.last == "bottom" && score_diff < num_runners + 1
  end

  def self.get_state(game)
    if game.started?
      if game.in_progress?
        "IN PROGRESS"
      else
        "POSTGAME"
      end
    else
      "PREGAME"
    end
  end

  def self.populate
    api = MLBGameday::API.new
    games = api.find_games
    games.map do |game|
      Game.create(gid: game.gid, state: get_state(game))
    end
  end
end
