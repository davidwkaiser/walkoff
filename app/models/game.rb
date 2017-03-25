class Game < ApplicationRecord
  def potential_walkoff?
    Game.potential_walkoff?(MLBGameday::API.new.game(self.gid))
  end

  def get_state
    Game.get_state(MLBGameday::API.new.game(self.gid))
  end

  def self.send_tweet(gid, game_over)
    game = MLBGameday::API.new.game(gid)

    if game_over
      if game.score.last > game.score.first
        # HOME TEAM LOST
      elsif game.score.last < game.score.first
        # HOME TEAM WALKED OFF
        tweet = "WE HAVE A WALKOFF! The #{game.home_team.name} just beat the #{game.away_team.name} #{game.score.first} - #{game.score.last}! #{Game.gameday_url(gid)}"
        $twitter.update(tweet)
      else
        #TIE
      end
    else
      #POTENTIAL WALKOFF
      tweet = "Potential Walkoff! The #{game.home_team.name} could walkoff the #{game.away_team.name} any minute! It's #{game.score.first} - #{game.score.last}, #{bottom game.inning.first}  #{Game.gameday_url(gid)}"
      $twitter.update(tweet)
    end
  end

  def self.gameday_url(gid)
    "http://m.mlb.com/gameday/#{gid}/#game=#{gid}"
  end

  def self.potential_walkoff?(game)
    inning = game.inning
    score_diff = game.score.last - game.score.first
    num_runners = game.runners.compact.count

    inning.first >=9 && inning.last == "Bottom" && score_diff < num_runners + 1
  end

  def self.get_state(game)
    if game.started?
      if game.in_progress?
        if self.potential_walkoff?(game)
          "POTENTIAL WALKOFF"
        else
          "BORING"
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
