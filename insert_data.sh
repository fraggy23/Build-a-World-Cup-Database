#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.



echo "hello world"

echo "$($PSQL "DELETE FROM teams WHERE name != '0'")"

##cat games.csv

#win= cut -d, -f3 games.csv|sed '1d';
#lose= cut -d, -f4 games.csv|sed '1d';
#gamevar= sed '1d' games.csv
#echo $gamevar

while read -r line

do
  # Split the line by ',' delimiter
  IFS=',' read -ra values <<< "$line"
  #read -r year,round,winner,opponent,winner_goals,opponent_goals
  N=$[N + 1]
  #echo $line
    if (( N == 1 )); then
      continue
    
    fi

  # Extract the values
  year="${values[0]}"

  round="${values[1]}"
  winner="${values[2]}"
  oppo="${values[3]}"
  wingoal="${values[4]}"
  oppogoal="${values[5]}"


  # Insert the values into the database
  echo "$($PSQL "INSERT INTO teams(name) VALUES ('$winner'), ('$oppo') ON CONFLICT DO NOTHING")"
  
  echo "$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($year, '$round', (SELECT team_id from teams WHERE name = '$winner'), (SELECT team_id from teams WHERE name = '$oppo'), $wingoal, $oppogoal)")"
  

#echo $year $round $winner $oppo $wingoal $oppogoal

done < games.csv

#echo "$($PSQL "INSERT INTO games(year, 'round', winner_id, opponent_id, winner_goals, opponent_goals)")"