class AddMissingIndexes < ActiveRecord::Migration
  def change
  	 add_index "games", ["provider_id", "provider"], name: "index_games_on_provider_id_and_provider"
  	 add_index "credentials", ["user_id"], name: "index_credentials_on_user_id"
	 add_index "teams", ["tournament_id"], name: "index_teams_on_tournament_id"
	 add_index "game_locations", ["user_id"], name: "index_game_locations_on_user_id"

  end
end
