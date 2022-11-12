#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
./create.sh
echo $($PSQL "TRUNCATE TABLE teams, games")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS ; 
do
  TEAM1=$($PSQL "SELECT name FROM teams WHERE name='$WINNER'")
  TEAM2=$($PSQL "SELECT name FROM teams WHERE name='$OPPONENT'")
  if [[ $WINNER != "winner" ]]
  then
    if [[ -z $TEAM1 ]]
    then
      INSERT_TEAM1=$($PSQL "INSERT INTO teams (name) VALUES ('$WINNER')")
      if [[ $INSERT_TEAM1 == "INSERT 0 1" ]]
      then
        echo Inserted into teams, $WINNER
      fi
    fi

    if [[ -z $TEAM2 ]]
    then
      INSERT_TEAM2=$($PSQL "INSERT INTO teams (name) VALUES ('$OPPONENT')")
      if [[ $INSERT_TEAM2 == "INSERT 0 1" ]]
      then
        echo Inserted into teams, $OPPONENT
      fi
    fi
  fi  

  WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
  OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")

  if [[ $WINNER_ID != "" && $OPPONENT_ID != "" ]]
  then
    echo $WINNER_ID, $OPPONENT_ID
    INSERT_GAME=$($PSQL "INSERT INTO games (year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES ($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")
    if [[ $INSERT_GAME == "INSERT 0 1" ]]
    then
      echo Inserted into games, $YEAR, $ROUND, $WINNER, $OPPONENT, $WINNER_GOALS, $OPPONENT_GOALS
    fi
  fi
done

