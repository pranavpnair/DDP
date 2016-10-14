#include <stdio.h>
#include <cuda.h>
__global__ void dkernel(unsigned *vector, unsigned vectorsize) {
    unsigned id = blockIdx.x * blockDim.x + threadIdx.x;
    if(id<vectorsize)   
        vector[id]++;  
}

#define BLOCKSIZE 1024


int main(int nn, char *str[]) {
    unsigned long long N = 1024*1024;
    unsigned *vector, *hvector;
    unsigned vec[N];
    for (int i = 0; i < N; i++) {
		vec[i] = i;
	}
	
    cudaMalloc(&vector, N * sizeof(unsigned));
    cudaMemcpy(vector, vec, N * sizeof(unsigned), cudaMemcpyHostToDevice);
    hvector = (unsigned *)malloc(N * sizeof(unsigned));
    unsigned nblocks = ceil((float)N / BLOCKSIZE);
//    printf("nblocks = %d\n", nblocks);
    dkernel<<<nblocks, BLOCKSIZE>>>(vector, N);
    cudaMemcpy(hvector, vector, N * sizeof(unsigned), cudaMemcpyDeviceToHost);
    for (unsigned ii = 0; ii < N; ++ii) {
    printf("%4d ", hvector[ii]);
    }
    return 0;
}
