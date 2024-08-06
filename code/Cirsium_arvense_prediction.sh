#!/bin/bash
#SBATCH --job-name=Cirsium_predict
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --partition=alpha
#SBATCH --cpus-per-task=12
#SBATCH --time=0-00:01:00 # d-hh:mm:ss
#SBATCH --gres=gpu:1
#SBATCH --mem=20G # Memory per node
#SBATCH --output=%j.out # Standard output and error log

cd /data/horse/ws/caba235b-my_environment 
module load release/23.10 GCC/11.3.0 OpenMPI/4.1.4
module load Python/3.10.4
module load SciPy-bundle/2022.05 NCCL/2.12.12-CUDA-11.7.0 magma/2.6.2-CUDA-11.7.0
source environment/bin/activate
cd /home/h9/caba235b/scripts
python Cirsium_arvense_prediction.py       

   
