setxkbmap ru
notify-send -u critical -i ~/TrollScript/Russia/russia.jpg "Votre ordinateur est maintenant NOTRE ordinateur"
ffplay -nodisp russia.mp3 1>&2 2> /dev/null &
while true
do
    amixer set Master 100% &
    sleep 1
done

