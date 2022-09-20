# process substitution example:

# process substitution example:
# ueberzug layer --parser bash 0< <(
# 	declare -Ap add_command=( [action]="add" [identifier]="example0" [x]="${3}" [y]="${4}" [draw]=true [synchronously_draw]=true [scaler]=fit_contain [scaling_position_x]=0.1 [scaling_position_y]=0.1 [width]="${1}" [height]="${2}" [path]="${5}")
# 
# 	sleep 5
# 	declare -Ap remove_command=([action]="remove" [identifier]="example0")
# 	sleep 5
# )

# process substitution example:
ueberzug layer --parser bash 0< <(
while "true" 
  do
    declare -Ap add_command=([action]="add" [identifier]="example0" [x]="0" [y]="0" [path]=~/plugins/imagine.nvim/images/200\ x\ 200.png)

    sleep 1
  done

  # declare -Ap remove_command=([action]="remove" [identifier]="example0") # Remove image
)
