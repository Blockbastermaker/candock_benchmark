#!/usr/bin/env bash
#PBS -l nodes=1:ppn=1
#PBS -l walltime=4:00:00
#PBS -l naccesspolicy=singleuser
#PBS -v ROOT_DIR,MCANDOCK_LOCATION
#PBS -d .

if [[ -z $ROOT_DIR || -z $MCANDOCK_LOCATION ]]
then
    echo "You must define \$ROOT_DIR and \$MCANDOCK_LOCATION."
    echo "Be sure to *export* these variables!"
    exit
fi

top_percent=(0.005 0.01 0.02 0.05 0.10 0.20 0.50 1.00)

for m in `cat $ROOT_DIR/core.lst`
do

   for i in "${top_percent[@]}"; do

       if [[ -e ${m}_pocket/$i/model.lst ]]
       then
           continue
       fi 

       if [[ ! -d ${m}_pocket/$i/ ]]
       then
           echo "$m $i was not run!"
           continue
       fi

       if [[ ! -s ${m}_pocket/$i/${m}_ligand.pdb ]]
       then
           echo "$m $i does not exist"
           continue
       fi

       echo "$m $i"
       grep CONFIGUATION ${m}_pocket/$i/${m}_ligand.pdb | awk '{print $8}' > ${m}_pocket/$i/model.lst
   done;
done

