#!/bin/bash

. /home/giz/media_station/refresh_ctrl_num.sh
/home/giz/media_station/amixer.sh $*  -c $simple_ctrls

