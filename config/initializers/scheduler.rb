require 'rufus-scheduler'
game_populator = Rufus::Scheduler.singleton
active_checker = Rufus::Scheduler.singleton
test_logger    = Rufus::Scheduler.singleton

games = []

game_populator.cron '00 05 * * *' do
  Game.populate
  games = Game.where.not(state: "POSTGAME")
  active_games = false
end

active_checker.every '1h' do
  if games.any? { |game| game.get_state == "IN PROGRESS" }
    active_games = true
  end
end

logger.every '10s' do
  puts "=============="
  puts "THE TIME IS #{Time.now}"
  puts "=============="
end