#! /bin/bash
PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

#intake username 
echo -e "\nEnter your username:"
read USERNAME
#if username doesn't exist create/enter record
CONFIRM_USERNAME=$($PSQL "SELECT DISTINCT username FROM games WHERE username = '$USERNAME'")
 if [[ -z $CONFIRM_USERNAME ]]
 then
#play welcome message and take new user to game
 echo -e "\nWelcome, $USERNAME! It looks like this is your first time here."
# if username exists get games_played and best_game
  else
  GAME_COUNT=$($PSQL "SELECT COUNT(game_id) FROM games WHERE username = '$USERNAME'")
  LOWEST_COUNT=$($PSQL "SELECT MIN(count) FROM games WHERE username = '$USERNAME'")
  echo -e "\nWelcome back, $CONFIRM_USERNAME! You have played $GAME_COUNT games, and your best game took $LOWEST_COUNT guesses."

fi
#set random number
TARGET=$(( 1 + $RANDOM % 1000))
echo $TARGET
#set counter
COUNTER=0
echo -e "\nGuess the secret number between 1 and 1000:"
#create while loop
  while true; do 
      read GUESS
# increment counter
    COUNTER=$((COUNTER + 1))
# check if integer
      if [[ ! $GUESS =~ ^[0-9]+$ ]]
        then
          echo -e "That is not an integer, guess again:"
      elif [[ $GUESS -eq $TARGET ]]; then
  #enter into databse if number guessed and break loop
          INSERT_INTO_RECORDS=$($PSQL "INSERT INTO games(username, count) VALUES ('$USERNAME', $COUNTER)") 
          echo -e "You guessed it in $COUNTER tries. The secret number was $TARGET. Nice job!"
          break 
  # if lower that tagrget guess higher
      elif [[ $GUESS -lt $TARGET ]]; then
          echo -e "It's higher than that, guess again:"
  #if higher than number send back to start of loop
      else
          echo -e "It's lower than that, guess again:"
      fi
  done


