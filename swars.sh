#!/bin/bash

# Important note:  This was tested on a Mac.  Certain commands will behave differently if run on Linux - in particular:  sed $'s/,/\\\n/g'
# If this will be run on Linux, the \\\n should be replaced with \n

# The goal of this script is to search the Star Wars API to identify the full name, birth year, and species of a character and warn if 
# the name searched is not a character listed in the API.

# Caveat Emptor:  I was unable to test this on Linux.  While I am confident in the change to the sed calls, it has not been tested at this time.

echo Pick the name of a Star Wars character
read peeps

curl -s https://swapi.co/api/people/?search=$peeps | grep -iq $peeps

if [ $? = 0 ]   
then
	echo The characters full name and birth year are
	# If running this script on a Mac, uncomment this line:
	curl -s https://swapi.co/api/people/?search=$peeps | sed $'s/,/\\\n/g' | sed $'s/{/\\\n/g' | grep -E "name|birth_year" | cut -d'"' -f4 
	# If running this script on Linux, uncomment this line:
	#curl -s https://swapi.co/api/people/?search=$peeps | sed $'s/,/\n/g' | sed $'s/{/\n/g' | grep -E "name|birth_year" | cut -d'"' -f4 

	echo The character is a:
	# If running this script on a Mac, uncomment this line:
	curl -s https://swapi.co/api/people/?search=$peeps | sed $'s/,/\\\n/g' | sed $'s/{/\\\n/g' | grep species | cut -d'"' -f4 | while read line; do curl -s $line | sed $'s/{/\\\n/g' | sed $'s/,/\\\n/g' | grep name | cut -d'"' -f4; done
	# If running this script on Linux, uncomment this line:
	#curl -s https://swapi.co/api/people/?search=$peeps | sed $'s/,/\n/g' | sed $'s/{/\n/g' | grep species | cut -d'"' -f4 | while read line; do curl -s $line | sed $'s/{/\n/g' | sed $'s/,/\n/g' | grep name | cut -d'"' -f4; done

else
	echo That name is not listed as a Star Wars Character

fi
