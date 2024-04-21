import cv2
import numpy as np
import argparse

def edge_detection(input_video_path, output_video_path):
    cap = cv2.VideoCapture(input_video_path)

    # Define the codec and create VideoWriter object
    fourcc = cv2.VideoWriter_fourcc(*'mp4v')
    out = cv2.VideoWriter(output_video_path, fourcc, 20.0, (int(cap.get(3)), int(cap.get(4))), isColor=False)

    while cap.isOpened():
        ret, frame = cap.read()
        if not ret:
            break

        gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)        # Convert the frame to grayscale
        edges = cv2.Scharr(gray, cv2.CV_64F, 1, 0)        # Apply Scharr edge detection
        edges = np.uint8(np.absolute(edges))
        out.write(edges)

    cap.release()
    out.release()
    cv2.destroyAllWindows()

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Video Edge Detection')
    parser.add_argument('input_video', type=str, help='Input video file path')
    parser.add_argument('output_video', type=str, help='Output video file path')
    args = parser.parse_args()

    edge_detection(args.input_video, args.output_video)
