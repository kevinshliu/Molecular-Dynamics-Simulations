#!/bin/bash
  
#SBATCH --time=36:00:00
#SBATCH --nodes=40
#SBATCH --ntasks-per-node=32
#SBATCH --constraint=haswell
#SBATCH --qos=regular
#SBATCH --account=m906
#SBATCH --job-name=full-md

module load gromacs/2020.2.hsw

echo "Start at `date`"

# continue GROMACS MD production

srun -n 1280 mdrun_mpi_sp -deffnm md -maxh 36.00 -cpi -multidir 1 2 3 4 5 &

wait

echo "End at `date`"

