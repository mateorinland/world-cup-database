#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo $($PSQL "TRUNCATE TABLE games, teams;")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $YEAR != "year" ]]
  then
    # get winner team's team_id
    TEAM_ID_1=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    
    # if winner not found
    if [[ -z $TEAM_ID_1 ]]
    then
      # insert team
      INSERT_TEAM_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")

      # get new team_id
      TEAM_ID_1=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    fi

    # get opponent team's team_id
    TEAM_ID_2=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")

    # if opponent not found
    if [[ -z $TEAM_ID_2 ]]
    then
      # insert team
      INSERT_TEAM_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")

      # get new team_id
      TEAM_ID_2=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    fi

    #insert games info
    echo $($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $TEAM_ID_1, $TEAM_ID_2, $WINNER_GOALS, $OPPONENT_GOALS)")
  fi
done
