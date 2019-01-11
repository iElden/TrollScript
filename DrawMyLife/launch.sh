cd ~/TrollScript/DrawMyLife
if ls ~/.trolled > /dev/null 2>/dev/null
then exit
fi
touch ~/.trolled
python3 drawmylife &
mv ~/.bashrcbackup ~/.bashrc
