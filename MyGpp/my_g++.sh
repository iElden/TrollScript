if g++ -Wall -Wextra $@
then
   true
else
    ffplay -autoexit -nodisp boule_noire.mp3 &>/dev/null &
fi
