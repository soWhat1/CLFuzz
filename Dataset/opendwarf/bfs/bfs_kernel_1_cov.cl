typedef struct
{
	int starting;
	int no_of_edges;
}Node;

__kernel void kernel1(__global const Node* g_graph_nodes,
		__global int* g_graph_edges,
		__global int* g_graph_mask,
		__global int* g_updating_graph_mask,
		__global int* g_graph_visited,
		__global int* g_cost,
		int no_of_nodes, __global int* ocl_kernel_branch_triggered_recorder, __global int* ocl_kernel_loop_recorder)
{__local int my_ocl_kernel_branch_triggered_recorder[4];
for (int ocl_kernel_init_i = 0; ocl_kernel_init_i < 4; ++ocl_kernel_init_i) {
    my_ocl_kernel_branch_triggered_recorder[ocl_kernel_init_i] = 0;
}
__local int my_ocl_kernel_loop_recorder[1];
for (int ocl_kernel_init_i = 0; ocl_kernel_init_i < 1; ++ocl_kernel_init_i) {
    my_ocl_kernel_loop_recorder[ocl_kernel_init_i] = 0;
}
int private_ocl_kernel_loop_iter_counter[1];
bool private_ocl_kernel_loop_boundary_not_reached[1];
barrier(CLK_LOCAL_MEM_FENCE | CLK_GLOBAL_MEM_FENCE);

	unsigned int tid = get_global_id(0);

	if(tid < no_of_nodes && g_graph_mask[tid] != 0)
	{
atomic_or(&my_ocl_kernel_branch_triggered_recorder[0], 1);

		g_graph_mask[tid] = 0;
		int max = (g_graph_nodes[tid].no_of_edges + g_graph_nodes[tid].starting);
		private_ocl_kernel_loop_iter_counter[0] = 0;
private_ocl_kernel_loop_boundary_not_reached[0] = true;
for(int i = g_graph_nodes[tid].starting; i < max || (private_ocl_kernel_loop_boundary_not_reached[0] = false); i++)
		{
private_ocl_kernel_loop_iter_counter[0]++;

			int id = g_graph_edges[i];
			if(!g_graph_visited[id])
			{
atomic_or(&my_ocl_kernel_branch_triggered_recorder[2], 1);

				g_cost[id] = g_cost[tid] + 1;
				g_updating_graph_mask[id] = 1;
			}
else {

atomic_or(&my_ocl_kernel_branch_triggered_recorder[3], 1);
}
		}
if (private_ocl_kernel_loop_iter_counter[0] == 0) {
    atomic_or(&my_ocl_kernel_loop_recorder[0], 1);
}if (private_ocl_kernel_loop_iter_counter[0] == 1) {
    atomic_or(&my_ocl_kernel_loop_recorder[0], 2);
}if (private_ocl_kernel_loop_iter_counter[0] > 1) {
    atomic_or(&my_ocl_kernel_loop_recorder[0], 4);
}if (!private_ocl_kernel_loop_boundary_not_reached[0]) {
    atomic_or(&my_ocl_kernel_loop_recorder[0], 8);
}
	}
else {

atomic_or(&my_ocl_kernel_branch_triggered_recorder[1], 1);
}
for (int update_recorder_i = 0; update_recorder_i < 4; update_recorder_i++) { 
  atomic_or(&ocl_kernel_branch_triggered_recorder[update_recorder_i], my_ocl_kernel_branch_triggered_recorder[update_recorder_i]); 
}
for (int update_recorder_i = 0; update_recorder_i < 1; update_recorder_i++) { 
  atomic_or(&ocl_kernel_loop_recorder[update_recorder_i], my_ocl_kernel_loop_recorder[update_recorder_i]); 
}
}
