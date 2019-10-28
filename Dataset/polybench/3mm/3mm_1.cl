/**
 * 3mm.cl: This file is part of the PolyBench/GPU 1.0 test suite.
 *
 *
 * Contact: Scott Grauer-Gray <sgrauerg@gmail.com>
 * Will Killian <killian@udel.edu>
 * Louis-Noel Pouchet <pouchet@cse.ohio-state.edu>
 * Web address: http://www.cse.ohio-state.edu/~pouchet/software/polybench/GPU
 */

#if defined(cl_khr_fp64)  // Khronos extension available?
#pragma OPENCL EXTENSION cl_khr_fp64 : enable
#elif defined(cl_amd_fp64)  // AMD extension available?
#pragma OPENCL EXTENSION cl_amd_fp64 : enable
#endif

typedef float DATA_TYPE;

__kernel void mm3_kernel1(__global DATA_TYPE *A, __global DATA_TYPE *B, __global DATA_TYPE *E, int ni, int nj, int nk)
{
	int j = get_global_id(0);
	int i = get_global_id(1);

	if ((i < ni) && (j < nj))
	{
		int k;
		E[i*nj + j] = 0;
		for(k=0; k < nk; k++)
		{
			E[i * nj + j] += A[i * nk + k] * B[k * nj + j];
		}
	}
}