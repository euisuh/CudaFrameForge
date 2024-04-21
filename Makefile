IDIR=./src/
COMPILER=nvcc
LIBRARIES += -lcudart -lcuda
LIBRARIES += -lopencv_core -lopencv_imgproc -lopencv_highgui -lopencv_videoio
LIBRARIES += -lnppisu_static -lnppif_static -lnppc_static -lculibos
LIBRARIES += -lnppicc -lnppidei -lnppif -lnppig -lnppim -lnppist -lnppisu -lnppitc -lcudart

COMPILER_FLAGS=-I$(IDIR) -I/usr/include/opencv4 -I/usr/local/cuda/include -I/usr/local/cuda/lib64 -I/home/coder/lib/cub/ -I/home/coder/lib/cuda-samples/Common $(LIBRARIES) --std c++14
CXXFLAGS = `pkg-config --cflags opencv4`
LDFLAGS = `pkg-config --libs opencv4`

#INCLUDES += -I../Common/UtilNPP
ARGS="data/video.mp4 data/out.mp4"

.PHONY: clean build run

build: *.cu *.h
	$(COMPILER) $(COMPILER_FLAGS) *.cu -o venturi_processor

clean:
	rm -f venturi_processor

run:
	./venturi_processor $(ARGS)

all: clean build run