ueberzug layer --parser bash 0< <(
while "true" 
  do
    declare -Ap add_command=([action]="add" [identifier]="example0" [scaler]="contain" [synchronously_draw]=true [path]=${1} [width]=${2} [height]=${3} [x]=${4} [y]=${5})
    sleep 0.1
  done

  # declare -Ap remove_command=([action]="remove" [identifier]="example0") # Remove image
)
