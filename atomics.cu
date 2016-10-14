#include <stdio.h>

__global__ void square( int * d_in){
    int totalSum;
	if (threadIdx.x == 0) totalSum = 0;
    __syncthreads();

    int localVal = d_in[threadIdx.x];
    atomicAdd(&totalSum, 1);
    __syncthreads();
}

int main(int argc, char ** argv) {
	const int ARRAY_SIZE = 64;
	const int ARRAY_BYTES = ARRAY_SIZE * sizeof(float);

	// generate the input array on the host
	int h_in[ARRAY_SIZE];
	for (int i = 0; i < ARRAY_SIZE; i++) {
		h_in[i] = i;
	}
	int * d_in;
	cudaMalloc((void**) &d_in, ARRAY_BYTES);
//	cudaMalloc((void*) &totalSum, sizeof(float));
	cudaMemcpy(d_in, h_in, ARRAY_BYTES, cudaMemcpyHostToDevice);
	square<<<1, ARRAY_SIZE>>>(d_in);
//	cudaMemcpy(ans, totalSum, sizeof(float), cudaMemcpyDeviceToHost);
//    printf("%f\n",ans);
	cudaFree(d_in);

	return 0;
}
