#!/bin/bash

SCRIPT_DIR=$(dirname $(which ${0}))
GEOMETRY_BASE64=$(${SCRIPT_DIR}/create-obs-geometry.sh 1280 720)
GEOMETRY_ESCAPED=$(echo ${GEOMETRY_BASE64} | perl -pe 's/\//\\\//g and s/\+/\\\+/g')

sed -E -i.tmp "s/SaveProjectors=false/SaveProjectors=true/g" ~/Library/Application\ Support/obs-studio/global.ini

perl -0777 -i.tmp -pe "s/\"saved_projectors\": \[[^\]]*\]/\"saved_projectors\": [{\"geometry\":\"${GEOMETRY_ESCAPED}\",\"monitor\":-1,\"type\":2}]/gms" ~/Library/Application\ Support/obs-studio/basic/scenes/Untitled.json
