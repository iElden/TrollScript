if [ $# != 2 ]
then
    echo "Usage Invalide : ./install.sh {programme} {alias}"
    exit
fi
rm ~/.trolled
echo -ne "Lancement de " $1 "sur l'alias" $2
cp ~/.bashrc ~/.bashrcbackup
echo "alias $2=\"~/TrollScript/$1;$2\"" >> ~/.bashrc
source ~/.bashrc
