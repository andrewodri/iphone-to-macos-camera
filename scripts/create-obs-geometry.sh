#!/bin/bash

if [[ "${1}" = "--help" || -z "${2}" ]]
then
  echo -e 'Example usage:\n  ./create-obs-geometry.sh [PROJECTOR_WIDTH] [PROJECTOR_HEIGHT]'
  exit 0
fi

MAIN_SCREEN_RESOLUTION=$(system_profiler -json SPDisplaysDataType 2>/dev/null | python -c "import sys,json;d=next(i for i in json.load(sys.stdin)['SPDisplaysDataType'][0]['spdisplays_ndrvs'] if 'spdisplays_main' in i);print d['_spdisplays_pixels']")

################################################################################
# This script will generate a base64 encoded byte array that can be used for 
# to define precisely sized OBS windowed projectors. Useful for screen capture 
# applications, as well as reducing quality and performance degradation from
# scaling. Tested on OBS 24.0.7.
#
# See https://github.com/qt/qtbase/blob/1c80d056e4f45b4ee7c4863cd792e83c889513c5/src/widgets/kernel/qwidget.cpp#L7166
# for the original C++ implementation.
################################################################################

MAGIC_NUMBER=01D9D0CB
MAJOR_VERSION=3
MINOR_VERSION=0

WINDOW_X=0
WINDOW_Y=0
WINDOW_WIDTH=${1}
WINDOW_HEIGHT=${2}

FRAME_LEFT=$(( $WINDOW_X + 0 ))
FRAME_TOP=$(( $WINDOW_Y + 0 ))
FRAME_RIGHT=$(( $FRAME_LEFT + $WINDOW_WIDTH - 1 ))
FRAME_BOTTOM=$(( $FRAME_TOP + $WINDOW_HEIGHT - 1 ))

NORMAL_LEFT=$(( $WINDOW_X + 0 ))
NORMAL_TOP=$(( $WINDOW_Y + 22 ))
NORMAL_RIGHT=$(( $NORMAL_LEFT + $WINDOW_WIDTH - 1 ))
NORMAL_BOTTOM=$(( $NORMAL_TOP + $WINDOW_HEIGHT - 1 ))

SCREEN_NUMBER=0
IS_MAXIMIZED=0
IS_FULLSCREEN=0

SCREEN_WIDTH=${MAIN_SCREEN_RESOLUTION%% x *}

GEOMETRY_LEFT=$(( $WINDOW_X + 0 ))
GEOMETRY_TOP=$(( $WINDOW_Y + 22 ))
GEOMETRY_RIGHT=$(( $GEOMETRY_LEFT + $WINDOW_WIDTH - 1 ))
GEOMETRY_BOTTOM=$(( $GEOMETRY_TOP + $WINDOW_HEIGHT - 1 ))

d2h8 () {
  HEX_RESULT="00000000$(echo "obase=16; ${1}" | bc)"
  echo "${HEX_RESULT: -8}"
}

d2h4 () {
  HEX_RESULT="0000$(echo "obase=16; ${1}" | bc)"
  echo "${HEX_RESULT: -4}"
}

GEOMETRY_HEX=$(echo "${MAGIC_NUMBER}
$(d2h4 ${MAJOR_VERSION})
$(d2h4 ${MINOR_VERSION})
$(d2h8 ${FRAME_LEFT})
$(d2h8 ${FRAME_TOP})
$(d2h8 ${FRAME_RIGHT})
$(d2h8 ${FRAME_BOTTOM})
$(d2h8 ${NORMAL_LEFT})
$(d2h8 ${NORMAL_TOP})
$(d2h8 ${NORMAL_RIGHT})
$(d2h8 ${NORMAL_BOTTOM})
$(d2h4 ${SCREEN_NUMBER})
$(d2h4 ${IS_MAXIMIZED})
$(d2h4 ${IS_FULLSCREEN})
$(d2h8 ${SCREEN_WIDTH})
$(d2h8 ${NORMAL_LEFT})
$(d2h8 ${NORMAL_TOP})
$(d2h8 ${NORMAL_RIGHT})
$(d2h8 ${NORMAL_BOTTOM})")

GEOMETRY_BASE64=$(echo ${GEOMETRY_HEX} | xxd -r -p | base64)

echo "${GEOMETRY_BASE64}"
