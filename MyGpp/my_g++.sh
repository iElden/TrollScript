DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

if g++ -Wall -Wextra $@
then
   true
else
    VAL=$?
    ffplay -autoexit -nodisp $DIR/boule_noire.mp3 &>/dev/null &
    exit $VAL
fi
