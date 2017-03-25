require 'mlb_gameday'

class Game < ApplicationRecord

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
