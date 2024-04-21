#include "venturi_processor.h"

void enhanceVideoFrame(cv::Mat &inputMat, cv::VideoWriter &videoStream) {
    int matType = inputMat.type();
    int matStep = inputMat.step;
    inputMat.convertTo(inputMat, CV_32FC3);
    Npp32f *gpuInputMat, *gpuProcessedResult;
    size_t stride;

    // Memory allocation on GPU and transfer of input matrix
    cudaMallocPitch(&gpuInputMat, &stride, 3 * inputMat.cols * sizeof(Npp32f), inputMat.rows);
    cudaMemcpy2D(gpuInputMat, stride, inputMat.ptr(), inputMat.step, 3 * inputMat.cols * sizeof(Npp32f), inputMat.rows, cudaMemcpyHostToDevice);

    // Set up buffers for channel separation
    Npp32f* gpuGreenFilterOutput;
    size_t filterStride;
    cudaMallocPitch(&gpuProcessedResult, &filterStride, inputMat.cols * sizeof(Npp32f), inputMat.rows);
    cudaMallocPitch(&gpuGreenFilterOutput, &filterStride, inputMat.cols * sizeof(Npp32f), inputMat.rows);

    NppiSize roi;
    roi.width = inputMat.cols;
    roi.height = inputMat.rows;

    // Channel isolation (green)
    nppiCopy_32f_C3C1R(gpuInputMat + 1, stride, gpuGreenFilterOutput, filterStride, roi);

    // Apply Scharr horizontal filter for edge detection
    nppiFilterScharrHoriz_32f_C1R(gpuGreenFilterOutput, filterStride, gpuProcessedResult, filterStride, roi);

    // Prepare the matrix for final output
    cv::Mat channelMat(inputMat.rows, inputMat.cols, CV_32FC1);
    cv::Mat grayMat(inputMat.rows, inputMat.cols, matType);

    cudaMemcpy2D(channelMat.ptr(), channelMat.step, gpuProcessedResult, filterStride, inputMat.cols * sizeof(Npp32f), inputMat.rows, cudaMemcpyDeviceToHost);
    channelMat.convertTo(channelMat, CV_8UC1);
    cv::cvtColor(channelMat, grayMat, cv::COLOR_GRAY2BGR);

    // Output the frame into the video stream
    videoStream.write(grayMat);

    // Release GPU resources
    cudaFree(gpuInputMat);
    cudaFree(gpuProcessedResult);
}

__host__ int main(int argc, char** argv) {
    std::cout << "Initializing Video Processing by Venturi Systems\n";

    if (argc != 3) {
        std::cerr << "Error: Expected two arguments, received " << argc - 1 << ". Please provide a source and destination video path.\n";
        return EXIT_FAILURE;
    }

    cv::VideoCapture captureDevice(argv[1]);
    if (!captureDevice.isOpened()) {
        std::cerr << "Failed to open the source video file.\n";
        return EXIT_FAILURE;
    }

    int captureWidth = static_cast<int>(captureDevice.get(cv::CAP_PROP_FRAME_WIDTH));
    int captureHeight = static_cast<int>(captureDevice.get(cv::CAP_PROP_FRAME_HEIGHT));
    double frameRate = captureDevice.get(cv::CAP_PROP_FPS);

    cv::VideoWriter outputStream(argv[2], cv::VideoWriter::fourcc('M', 'P', '4', 'V'), frameRate, cv::Size(captureWidth, captureHeight));
    if (!outputStream.isOpened()) {
        std::cerr << "Unable to create the output video file with the specified codec.\n";
        return EXIT_FAILURE;
    }

    cv::Mat frameBuffer;
    int frameCount = 0;
    while (captureDevice.read(frameBuffer)) {
        std::cout << "Enhancing Frame: " << frameCount << "\n";
        frameCount++;

        enhanceVideoFrame(frameBuffer, outputStream);
    }

    return EXIT_SUCCESS;
}
