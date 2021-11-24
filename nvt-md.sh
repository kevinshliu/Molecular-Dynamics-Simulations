#!/bin/bash
  
#SBATCH --time=36:00:00
#SBATCH --nodes=40
#SBATCH --ntasks-per-node=32
#SBATCH --constraint=haswell
#SBATCH --qos=regular
#SBATCH --account=m906
#SBATCH --job-name=full-nvt-md

module load gromacs/2020.2.hsw

echo "Start at `date`"

# prepare executables for NVT equilibration for 5 instances

for ((i=1;i<=5;i+=1))
do
cd $i
srun -n 1 gmx_sp grompp -f ../nvt.mdp -c emin.gro -r emin.gro -n ../full.ndx -p ../full.top -o nvt.tpr > grompp-nvt.log &
cd ../
done

wait

# run GROMACS NVT equilibration

srun -n 1280 mdrun_mpi_sp -deffnm nvt -maxh 36.00 -cpi -multidir 1 2 3 4 5 &

wait

# prepare executables for NPT equilibration for 5 instances

for ((i=1;i<=5;i+=1))
do
cd $i
srun -n 1 gmx_sp grompp -f ../npt.mdp -c nvt.gro -r nvt.gro -n ../full.ndx -p ../full.top -t nvt.cpt -o npt.tpr > grompp-npt.log &
cd ../
done

wait

# run GROMACS NPT equilibration

srun -n 1280 mdrun_mpi_sp -deffnm npt -maxh 36.00 -cpi -multidir 1 2 3 4 5 &

wait

# prepare executables for MD production for 5 instances

for ((i=1;i<=5;i+=1))
do
cd $i
srun -n 1 gmx_sp grompp -f ../md.mdp -c npt.gro -n ../full.ndx -p ../full.top -t npt.cpt -o md.tpr > grompp-md.log &
cd ../
done

wait

# run GROMACS MD production

srun -n 1280 mdrun_mpi_sp -deffnm md -maxh 36.00 -cpi -multidir 1 2 3 4 5 &

wait

echo "End at `date`"

