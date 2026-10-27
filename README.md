# CudaFrameForge

[![Static checks](https://github.com/euisuh/CudaFrameForge/actions/workflows/static-checks.yml/badge.svg)](https://github.com/euisuh/CudaFrameForge/actions/workflows/static-checks.yml)

CudaFrameForge is a CUDA C++ video-processing pipeline that applies horizontal
Scharr edge detection to video frames. It combines OpenCV for video I/O with the
CUDA Runtime API and NVIDIA Performance Primitives (NPP) for GPU memory
management, channel extraction, and filtering.

Euisuh Jeong built this project as a submission for the *CUDA at Scale for the
Enterprise* course. The repository demonstrates practical computer-vision
pipeline design, pitched GPU memory, 2D host/device transfers, and frame-by-frame
video encoding.

## Demo

| Input | GPU-processed output |
| --- | --- |
| [![Input video excerpt](data/input.gif)](https://youtu.be/3P1CnWI62Ik) | [![Scharr edge output](data/output.gif)](https://youtu.be/Grudv6hwyBQ) |

The output highlights horizontal intensity changes from the input frame's green
channel. Full videos: [input](https://youtu.be/3P1CnWI62Ik) and
[output](https://youtu.be/Grudv6hwyBQ).

The repository history contains several earlier versions of the demo GIFs, so a full clone is much larger than the checkout (about 120 MB on GitHub versus about 18 MB of current GIFs); `--depth 1` avoids it.

No throughput, latency, or speedup claims are included because the repository
does not contain a reproducible benchmark.

## Architecture

```text
Input video
    │
    ▼
OpenCV VideoCapture ──► BGR frame converted to 32-bit float
    │
    ▼
cudaMallocPitch + cudaMemcpy2D ──► pitched GPU buffer
    │
    ▼
NPP C3→C1 copy ──► green channel ──► horizontal Scharr filter
    │
    ▼
cudaMemcpy2D ──► 8-bit grayscale ──► OpenCV VideoWriter
```

Each frame is decoded on the CPU, copied to pitched device memory, processed
with `nppiCopy_32f_C3C1R` and `nppiFilterScharrHoriz_32f_C1R`, copied back, and
encoded as an MP4V video frame.

## Requirements

- NVIDIA GPU with a CUDA-capable driver
- CUDA Toolkit with `nvcc` and NPP
- OpenCV 4 development libraries discoverable through `pkg-config`
- GNU Make and a C++14-compatible CUDA toolchain

Example package setup on Ubuntu (CUDA Toolkit installation varies by GPU,
driver, and distribution):

```bash
sudo apt-get update
sudo apt-get install build-essential pkg-config libopencv-dev
nvcc --version
pkg-config --modversion opencv4
```

## Build and run

```bash
git clone --depth 1 https://github.com/euisuh/CudaFrameForge.git
cd CudaFrameForge
make build
```

Process any local video:

```bash
./venturi_processor /path/to/input.mp4 /path/to/output.mp4
```

Equivalent Make and wrapper commands:

```bash
make run ARGS="/path/to/input.mp4 /path/to/output.mp4"
./run.sh /path/to/input.mp4 /path/to/output.mp4
```

Expected console output begins with:

```text
Initializing Video Processing by Venturi Systems
Enhancing Frame: 0
Enhancing Frame: 1
```

The destination is an MP4V-encoded grayscale video with the source dimensions
and frame rate. Run `make clean` to remove the compiled executable.

## Project structure

```text
.
├── src/
│   ├── venturi_processor.cu  # CUDA/OpenCV processing pipeline and CLI
│   └── venturi_processor.h   # OpenCV, CUDA Runtime, and NPP includes
├── data/
│   ├── input.gif             # Input demo excerpt
│   └── output.gif            # Processed demo excerpt
├── utils/
│   ├── venturi.py            # CPU/OpenCV reference implementation
│   ├── compress.py           # ffmpeg-based video compression helper
│   └── createGif.py          # MoviePy demo GIF generator
├── Makefile
└── run.sh
```

## Author contribution

Euisuh Jeong authored the CUDA/NPP frame-processing implementation, OpenCV
video pipeline, build/run tooling, CPU reference script, and demo-media
utilities in this repository.

## Limitations

- CUDA/NPP processing requires NVIDIA hardware and is not exercised by the
  GPU-free GitHub Actions check.
- GPU buffers are allocated per frame; the implementation favors clarity over
  allocation reuse and asynchronous execution.
- The filter uses only the green channel and horizontal Scharr response; it
  does not combine horizontal and vertical gradients.
- Output depends on local MP4V codec support.
- CUDA and NPP errors are not yet surfaced through explicit status checks.
- Demo GIFs are illustrative; they are not benchmark artifacts.

## License

MIT, see [LICENSE](LICENSE).
