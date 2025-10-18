script=$(realpath $0)
script_path=$(dirname "$script")
source ${script_path}/common.sh

#script_path=$(dirname $(realpath "$0"))
#script_path=$(dirname $(realpath "${BASH_SOURCE[0]}"))

#script_path=$(dirname $(realpath $0))

component=catalogue

func_nodejs

