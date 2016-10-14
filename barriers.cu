#include <stdio.h>
#include <cuda.h>
__global__ void dkernel(unsigned *vector, unsigned vectorsize) {
 unsigned id = blockIdx.x * blockDim.x + threadIdx.x;
    vector[id] = id;
    __syncthreads();//barrier here
 
 if(id< vectorsize-1 && vector[id+1]!=id+1)
    printf("Incorrect\n");
    
}
#define BLOCKSIZE 1024


int main(int nn, char *str[]) {
    unsigned N = 1024;
    unsigned *vector, *hvector;
    cudaMalloc(&vector, N * sizeof(unsigned));
    hvector = (unsigned *)malloc(N * sizeof(unsigned));
    unsigned nblocks = ceil((float)N / BLOCKSIZE);
    printf("nblocks = %d\n", nblocks);
    dkernel<<<nblocks, BLOCKSIZE>>>(vector, N);
    cudaMemcpy(hvector, vector, N * sizeof(unsigned), cudaMemcpyDeviceToHost);
    for (unsigned ii = 0; ii < N; ++ii) {
    printf("%4d ", hvector[ii]);
    }
    return 0;
}
