#include<stdio.h>
#include<cuda.h>
#define height 4
#define width 4

// Device code
__global__ void kernel(int* d_A, int pitch)
{
    for (int c = 0; c < height; ++c) {
        for (int r = 0; r < width; ++r) {
             int* row = (int*)((char*)d_A + r * pitch);
             row[c] = row[c]*row[c];
        }
    }
}

//Host Code
int main()
{
    int* d_A;
    size_t pitch;
    int *A;
    int rows = height;
    int cols = width;
    A = (int *)malloc(rows*cols*sizeof(int));
    for (int i = 0; i < rows*cols; i++) A[i] = i;
    cudaMallocPitch((void**)&d_A, &pitch, width * sizeof(int), height);
    cudaMemcpy2D(d_A, pitch, A, sizeof(int)*cols, sizeof(int)*cols, rows, cudaMemcpyHostToDevice);
    kernel<<<100, 32>>>(d_A, pitch);
    cudaDeviceSynchronize();
    for(int i=0;i<rows*cols;i++)
        printf("%d %d\n",A[i],d_A[i]);
    return 0;
}



