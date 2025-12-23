stdout=$(amixer -c1 2>&1) && [[ $stdout =~ "Speaker" ]] && simple_ctrls='1' && export simple_ctrls='1' && return 0
stdout=$(amixer -c2 2>&1) && [[ $stdout =~ "Speaker" ]] && simple_ctrls='2' && export simple_ctrls='2'

