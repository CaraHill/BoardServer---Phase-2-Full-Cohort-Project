before do
   content_type :json
   headers 'Access-Control-Allow-Origin' => '*',
           'Access-Control-Allow-Methods' => ['OPTIONS', 'GET', 'POST']
end

set :protection, false # added this and the above stuff

get '/new_game' do
  Game.delete_all
  Game.create(click_count: 0)
  status 200
end


post '/check' do
  parsed_request = JSON.parse(request.body.read)
  r = parsed_request['coords']['row'].to_i
  c = parsed_request['coords']['column'].to_i

  game = Game.all.first

  num = Board.number_at_guess(r,c)

  if(num == -1)
    #send game over
    return "-1"
  else
    game.click_count += 1
    game.save
  end

  #game win?
  if game.click_count == (Board::NUM_EMPTY)
    # work out game time and post to server
    #send game has won
    "9"
  else
    #return the number at that location
    num.to_s
  end

end


