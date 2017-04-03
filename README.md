# README

This is an app created for #BaseballHackDay on 25 March 2017  
When a baseball game is in a potential walkoff situation,   
our app will send out a tweet via the Twitter account @walkoffbot.  
This way you can stay informed about all the season's most exciting games!  

Contributors:  
@chagan  
@davidwkaiser   
@h12  
@tejaykodali  

Tech Stack:  
Rails  
MLB Gameday API  
Twitter API  


DEPLOYMENT NOTE: When we deployed to Heroku, we kept getting errors related to the schedulers, it would try to run and populate the Game items BEFORE we could run the DB migrations. To make this work, we needed to comment out line 7 in scheduler.rb so that it would not start and push, then run the migrations, then restore line 7 and push again. Then it all worked. 

Also, since the cron runs at 5 am, when we deployed it at 3 pm, we needed to populate the games manually via Heroku's Rails Console:

  Game.populate  
  games = Game.where.not(state: "POSTGAME")  
  
Twitter login credentials need to be manually entered into Heroku via the Rails console.   

What remains to be determined is the extent to which Heroku remains active so that the crons work. We suspect Heroku spins down if we're not hitting the server to look at the index.html page. The question is, is that true and if so, how quickly does it spin down? 

Some research confirmed that it will spin down after 30 minutes of inactivity. Currently looking into either an inexpensive hobby plan on Heroku or a free plan elsewhere, perhaps AWS. 
