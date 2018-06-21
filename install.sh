if [ $# != 2 ]
then
    echo "Usage Invalide : ./install.sh {programme} {alias}"
    exit
fi

echo -ne "Lancement de " $1 "sur l'alias" $2
cp ~/.bashrc ~/.bashrcbackup
echo "alias $2=\"$1\"" >> ~/.bashrc
source ~/.bashrc
