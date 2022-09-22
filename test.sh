
declare -g screen_counter=0

function Screen::width {
    tput cols
}

function Screen::height {
    tput lines
}

function Screen::new {
    let screen_counter+=1
    tput smcup 1>&2
}

function Screen::popup {
    local -a message=( "$@" )
    local line_length="`Array::max_length "${message[@]}"`"
    local line_count="${#message[@]}"
    local offset_x="$(( `Screen::width` / 2 - line_length / 2 ))"
    local offset_y="$(( `Screen::height` / 2 - ( line_count + 1 ) / 2 ))"

    Screen::new

    for ((i=0; i < ${#message[@]}; i++)); do
        echo "${message[$i]}" 1>&2
    done
}

function Array::max_length {
    local -a items=( "$@" )
    local max=0

    for i in "${items[@]}"; do
        if (( ${#i} > max )); then
            max=${#i}
        fi
    done

    echo $max
}

Screen::popup 'Searching hosts'
