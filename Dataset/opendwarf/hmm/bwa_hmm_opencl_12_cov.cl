/************************************************************************/
/* OpenCL Kernels for BW Algorithm in Hidden Markov Model               */
/*                                                                      */
/************************************************************************/
#define SDOT_BLOCK_SIZE        (128)
#define SDOT_BLOCK_NUM         (80)

#define MVMUL_BLOCK_SIZE       (128)
#define MVMUL_BLOCK_NUM        (64)
#define TILE_SIZE              (32)


/* Re-estimate B values */
__kernel void est_b_dev( __global float *b_d,         /* dim = nsymbols x nstates */
		__global float *gamma_sum_d, /* lth = nstates */
		int nstates,                 /* number of states */
		int nsymbols, __global int* ocl_kernel_branch_triggered_recorder)                /* number of symbols */
{__local int my_ocl_kernel_branch_triggered_recorder[2];
for (int ocl_kernel_init_i = 0; ocl_kernel_init_i < 2; ++ocl_kernel_init_i) {
    my_ocl_kernel_branch_triggered_recorder[ocl_kernel_init_i] = 0;
}
barrier(CLK_LOCAL_MEM_FENCE | CLK_GLOBAL_MEM_FENCE);

	// unsigned int idx = blockIdx.x * blockDim.x + threadIdx.x;
	unsigned int idx = get_group_id(0) * get_local_size(0) + get_local_id(0);
	// unsigned int idy = blockIdx.y * blockDim.y + threadIdx.y;
	unsigned int idy = get_group_id(1) * get_local_size(1) + get_local_id(1);

	if (idy < nsymbols && idx < nstates)
	{
atomic_or(&my_ocl_kernel_branch_triggered_recorder[0], 1);

		b_d[(idy * nstates) + idx] = b_d[(idy * nstates) + idx] /
			gamma_sum_d[idx];
	}else {

atomic_or(&my_ocl_kernel_branch_triggered_recorder[1], 1);
}

for (int update_recorder_i = 0; update_recorder_i < 2; update_recorder_i++) { 
  atomic_or(&ocl_kernel_branch_triggered_recorder[update_recorder_i], my_ocl_kernel_branch_triggered_recorder[update_recorder_i]); 
}
}
