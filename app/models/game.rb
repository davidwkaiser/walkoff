require 'mlb_gameday'

class Game < ApplicationRecord
  def potential_walkoff?
    Game.potential_walkoff?(MLBGameday::API.new.game(self.gid))
  end

  def self.potential_walkoff?(game)
    inning = game.inning
    score_diff = game.score.first - game.score.last
    num_runners = game.runners.compact.count

    inning.first >=9 && inning.last == "bottom" && score_diff < num_runners + 1
  end

  def self.get_state(game)
    if game.started?
      if game.in_progress?
        if self.potential_walkoff?(game)
          "POTENTIAL WALKOFF"
        else
          "IN PROGRESS"
        end
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
