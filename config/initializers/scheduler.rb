require 'rufus-scheduler'
game_populator = Rufus::Scheduler.singleton
active_checker = Rufus::Scheduler.singleton
tweet_manager  = Rufus::Scheduler.singleton


games = Game.where.not(state: "POSTGAME")
active_games = true

game_populator.cron '00 05 * * *' do
  Game.populate
  games = Game.where.not(state: "POSTGAME")
end

active_checker.every '1h' do
  if games.any? { |game| game.get_state == ("BORING" || "POTENTIAL WALKOFF") }
    active_games = true
  else
    active_games = false
  end
end


tweet_manager.every '30s' do
  if active_games
    games.each do |game|
      api_state = game.get_state
      if api_state != game.state
        if api_state == "POTENTIAL WALKOFF"
          Game.send_tweet(game.gid, false)
        elsif api_state == "POSTGAME" && game.state == "POTENTIAL WALKOFF"
          Game.send_tweet(game.gid, true)
        end

        game.update(state: api_state)
      end
    end
  end
end
