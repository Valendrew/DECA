#!/bin/bash
urle() {
    [[ "${1}" ]] || return 1
    local LANG=C i x
    for ((i = 0; i < ${#1}; i++)); do
        x="${1:i:1}"
        [[ "${x}" == [a-zA-Z0-9.~-] ]] && echo -n "${x}" || printf '%%%02X' "'${x}"
    done
    echo
}

# Fetch FLAME data
echo -e "\nBefore you continue, you must register at https://flame.is.tue.mpg.de/ and agree to the FLAME license terms."
read -p "Username (FLAME):" username
read -p "Password (FLAME):" password
username=$(urle $username)
password=$(urle $password)

mkdir -p ./data

# Contains female_model.pkl, generic_model.pkl and male_model.pkl
echo -e "\nDownloading FLAME..."
wget --post-data "username=$username&password=$password" 'https://download.is.tue.mpg.de/download.php?domain=flame&sfile=FLAME2020.zip&resume=1' -O './data/FLAME2020.zip' --no-check-certificate --continue
unzip ./data/FLAME2020.zip -d ./data/FLAME2020
mv ./data/FLAME2020/generic_model.pkl ./data

# Contains FLAME_texture.npz
echo -e "\nDownloading FLAME textures..."
wget --post-data "username=$username&password=$password" 'https://download.is.tue.mpg.de/download.php?domain=flame&resume=1&sfile=TextureSpace.zip' -O './data/FLAME_TextureSpace.zip' --no-check-certificate --continue
unzip ./data/FLAME_TextureSpace.zip -d ./data/FLAME2020
mv ./data/FLAME2020/FLAME_texture.npz ./data

# rm -rf ./models

echo -e "\nDownloading deca_model..."

FILEID=1rp8kdyLPvErw2dTmqtjISRVvQLj6Yzje
FILENAME=./data/deca_model.tar
# wget --load-cookies /tmp/cookies.txt "https://docs.google.com/uc?export=download&confirm=$(wget --quiet --save-cookies /tmp/cookies.txt --keep-session-cookies --no-check-certificate 'https://docs.google.com/uc?export=download&id='${FILEID} -O- | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1\n/p')&id=${FILEID}" -O $FILENAME && rm -rf /tmp/cookies.txt
wget --no-check-certificate "https://drive.usercontent.google.com/download?id=${FILEID}&export=download&authuser=0&confirm=t" -O $FILENAME
