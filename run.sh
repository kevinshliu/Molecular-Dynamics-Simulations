#!/bin/bash
  
ID=$(sbatch --parsable nvt-md.sh)

for ((i=1;i<=5;i+=1))
do
ID=$(sbatch --parsable --dependency=afterany:$ID md.sh)
done

