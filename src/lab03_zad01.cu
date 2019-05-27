#include "cuda_runtime.h"
#include "device_launch_parameters.h"

#include <array>
#include <iostream>
#include "CudaUtils.h"
#include <thrust/host_vector.h>
#include <thrust/device_vector.h>
#include "util/StringConcat.h"

int main() {

    thrust::host_vector<int> src(std::vector<int> { 10, 25, 4, -2, 15, 35, 27, 99, 1 });
    thrust::device_vector<int> devSrc = src;
    thrust::device_vector<int> devRes(devSrc.size());

    thrust::exclusive_scan(devSrc.begin(), devSrc.end(), devRes.begin(), 0, thrust::maximum<int>());

    thrust::host_vector<int> res = devRes;

    // Wait for the kernel to complete and check for errors
    checkCuda(cudaPeekAtLastError());
    checkCuda(cudaDeviceSynchronize());

    // Print the results
    for (int col = 0; col < res.size(); ++col) {
        std::cout << res[col] << std::endl;
    }
}