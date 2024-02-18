curl -sL https://deb.nodesource.com/setup_20.x -o nodejs.sh
bash nodejs.sh
apt install nodejs -y
apt install build-essential -y
rm nodejs.sh
npm i -g npm
