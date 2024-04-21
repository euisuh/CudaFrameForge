# CudaFrameForge

This repository contains the project submission by **Euisuh Jeong** for the CUDA at Scale for the Enterprise course. The project focuses on implementing edge detection in a video, using Scharr as an example, which can be applied as part of a lane detection algorithm.

## Input and Output Examples

| Input | Output |
|-------|--------|
| ![inputFrame](data/input.gif) | ![outputFrame](data/output.gif) |

You can view the full output video [here](https://youtu.be/Grudv6hwyBQ), and the original input video [here](https://youtu.be/3P1CnWI62Ik?si=-uQfjWsPdYBz41q6).

## Project Overview

The program takes a video file as input and produces an output video file. It performs the following steps:

- Reads each frame of the input video using OpenCV.
- Extracts the green channel of each frame.
- Applies Scharr edge detection to detect edges.
- Generates a grayscale frame by copying the new green channel onto each RGB channel.
- Writes the grayscale frame to the output file.

For memory allocation, the program utilizes 2D memory functions, which offer improved performance especially when padding is necessary.

## Building and Testing

The program has been developed and tested on WSL (Windows Subsystem for Linux), using Ubuntu 18.04. Follow these steps:

1. **Build**: Use the command `make build` to build the program.

2. **Run**: Supply the input and output video file paths as arguments. Options include:
   - Execute `./run.sh`.
   - Use `make run ARGS="data/video.mp4 data/out.mp4"`.
   - Directly execute `./venturi_processor data/video.mp4 data/out.mp4`.
