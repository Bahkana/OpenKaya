require File.expand_path("test_helper", File.dirname(__FILE__))

test "Score computation and podium, 8 players with large rank difference, the 6d should win the tournament and 5 rounds is enough to sort out all players" do
  test_players = []
  test_players << Player.new(:name=>"Pierre", :rank=>"6d")
  test_players << Player.new(:name=>"Paul", :rank=>"3d")
  test_players << Player.new(:name=>"Jack",  :rank=>"1d")
  test_players << Player.new(:name=>"Simon",  :rank=>"5k")
  test_players << Player.new(:name=>"Marie", :rank=>"8k")
  test_players << Player.new(:name=>"Peter", :rank=>"12k")
  test_players << Player.new(:name=>"Julie", :rank=>"12k")
  test_players << Player.new(:name=>"El Diablo", :rank=>"15k")
  swiss_elim = Organizer.create_tournament("SwissTournament", {:name=>"SwissTournamentTest1", :rounds_count=>5})
  swiss_elim.add_players(test_players);
  swiss_elim.start_round
  mock_results_based_on_rank(swiss_elim)
  swiss_elim.start_round
  mock_results_based_on_rank(swiss_elim)
  begin
    swiss_elim.start_round
    mock_results_based_on_rank(swiss_elim)
  end while swiss_elim.rounds.size < 5
  assert_equal swiss_elim.finished?,true
  assert_equal swiss_elim.podium[0].name, "Pierre"  
  assert_equal swiss_elim.podium[1].name, "Paul"  
  assert_equal swiss_elim.podium[2].name, "Jack"  
end

test "a fixture from a new tournament shouldnt explode :) " do
  swiss = Organizer.create_tournament("SwissTournament", {:name=>"SwissTournamentTest2", :rounds_count=>5})
  swiss.add_players(spawn_player_list(4));
  swiss.start_round
  assert_equal swiss.fixture.size, 4
end
