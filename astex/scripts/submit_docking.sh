#!/usr/bin/env bash

if [[ -z $ROOT_DIR || -z $MCANDOCK_LOCATION ]]
then
    echo "You must define \$ROOT_DIR and \$MCANDOCK_LOCATION."
    echo "Be sure to *export* these variables!"
    exit
fi

command_name=$1
shift

top_p=$1
shift

number=$1
shift

export CANDOCK_top_percent=$top_p

my_depend=`qsub $ROOT_DIR/scripts/$command_name $@`

for i in `seq 2 $number`
do
    my_depend=`qsub $ROOT_DIR/scripts/$command_name -W depend=after:$my_depend $@`
done
