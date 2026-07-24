COMPILER ?= nvcc
SOURCES := $(wildcard src/*.cu)
HEADERS := $(wildcard src/*.h)
CPPFLAGS := -Isrc
NVCCFLAGS := --std c++14
CXXFLAGS ?= $(shell pkg-config --cflags opencv4)
LDFLAGS ?= $(shell pkg-config --libs opencv4)
LDLIBS := -lnppif -lnppidei -lnppc
ARGS ?= data/video.mp4 data/out.mp4

.PHONY: clean build run

build: venturi_processor

venturi_processor: $(SOURCES) $(HEADERS)
	$(COMPILER) $(NVCCFLAGS) $(CPPFLAGS) $(CXXFLAGS) $(SOURCES) -o $@ $(LDFLAGS) $(LDLIBS)

clean:
	rm -f venturi_processor

run:
	./venturi_processor $(ARGS)

all: clean build run
