#! /bin/bash
PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
echo "$($PSQL "DROP TABLE IF EXISTS games"): games"
echo "$($PSQL "DROP TABLE IF EXISTS teams"): teams"

CREATETABLE1="CREATE table IF NOT EXISTS teams ( 
    team_id SERIAL PRIMARY KEY, 
    name VARCHAR(50) NOT NULL);"
echo "$($PSQL "$CREATETABLE1"): teams"

CREATETABLE2="CREATE TABLE IF NOT EXISTS games (
	game_id SERIAL PRIMARY KEY,
	year INT NOT NULL,
	round VARCHAR(50) NOT NULL,
	winner_id INT NOT NULL references teams (team_id),
	opponent_id INT NOT NULL references teams (team_id),
	winner_goals INT NOT NULL,
	opponent_goals INT NOT NULL	
);"
echo "$($PSQL "$CREATETABLE2"): games"
