setxkbmap ru
notify-send -u critical -i ~/TrollScript/Russia/russia.jpg "Votre ordinateur est maintenant NOTRE ordinateur"
ffplay -nodisp -autoexit russia.mp3 1>&2 2> /dev/null&
while true
do
    amixer set Master 100% > /dev/null
    sleep 0.5
done

