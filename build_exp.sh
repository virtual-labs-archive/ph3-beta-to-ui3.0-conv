#!/bin/bash

echo "number of arguments =  $#"
if [ "$#" -ne 12 ]; then
    echo "Usage: ./script.sh <url> 
        <ename> <location> <broad-area> 
        <display-lab-name> <lab-name> 
        <borad-area-link> <lab-link>"
    exit 1
fi

url=$1
tag=$2
EXP_SHORT_NAME=$3
EXP_NAME=$4
location=$5
BROAD_AREA=$6
DISPLAY_LAB_NAME=$7
LAB_NAME=$8
COLLEGE_NAME=$9
PHASE=${10}
BROAD_AREA_LINK=${11}
LAB_LINK=${12}


rm -rf exprepos
rm -rf expbuilds

mkdir -p exprepos
mkdir -p expbuilds


##### Clone repository
cd exprepos; git clone $url; cd ../

basename=$(basename $url)
reponame=${basename%.*}

## switch to the given tag
cd exprepos/$reponame; git fetch --all; git checkout $tag; cd ../../

template=ui3template

## conversion
mkdir -p expbuilds/$EXP_SHORT_NAME
cp -r $template/* expbuilds/$EXP_SHORT_NAME

find expbuilds/$EXP_SHORT_NAME/*.html -maxdepth 1 -type f -exec sed -i "s/{{BROAD_AREA}}/$BROAD_AREA/g" {} +
find expbuilds/$EXP_SHORT_NAME/*.html -maxdepth 1 -type f -exec sed -i "s/{{LAB_NAME}}/$DISPLAY_LAB_NAME/g" {} +
find expbuilds/$EXP_SHORT_NAME/*.html -maxdepth 1 -type f -exec sed -i "s/{{COLLEGE_NAME}}/$COLLEGE_NAME/g" {} +
find expbuilds/$EXP_SHORT_NAME/*.html -maxdepth 1 -type f -exec sed -i "s/{{PHASE}}/$PHASE/g" {} +
find expbuilds/$EXP_SHORT_NAME/*.html -maxdepth 1 -type f -exec sed -i "s/{{EXP_NAME}}/$EXP_NAME/g" {} +
find expbuilds/$EXP_SHORT_NAME/*.html -maxdepth 1 -type f -exec sed -i "s/{{EXP_SHORT_NAME}}/$EXP_SHORT_NAME/g" {} +
find expbuilds/$EXP_SHORT_NAME/*.html -maxdepth 1 -type f -exec sed -i "s,{{BA_LINK}},$BROAD_AREA_LINK,g" {} +
find expbuilds/$EXP_SHORT_NAME/*.html -maxdepth 1 -type f -exec sed -i "s,{{LAB_LINK}},$LAB_LINK,g" {} +

cp -r exprepos/$reponame expbuilds/$EXP_SHORT_NAME
mv expbuilds/$EXP_SHORT_NAME/$reponame expbuilds/$EXP_SHORT_NAME/round-template

cp fixpointer.py expbuilds/$EXP_SHORT_NAME/round-template/experiment/simulation/
cd expbuilds/$EXP_SHORT_NAME/round-template/experiment/simulation/
python fixpointer.py
cp -r images ../../../
cd ..
cp -r images/* ../../images/

exit 0
