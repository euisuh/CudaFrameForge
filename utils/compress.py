import subprocess
import os

def compress_video(input_video_path, output_video_path):
    # Check if input file exists
    if not os.path.exists(input_video_path):
        print("Input video file not found.")
        return

    # Execute ffmpeg command to compress video
    command = f'ffmpeg -i "{input_video_path}" -c:v libx264 -crf 18 -preset slow -c:a copy "{output_video_path}"'
    subprocess.run(command, shell=True)

    # Check if output file exists
    if os.path.exists(output_video_path):
        print("Video compression successful!")
    else:
        print("Failed to compress video.")

if __name__ == "__main__":
    # Define input and output paths
    input_video_path = "data/feel-the-rhythm-seoul-out.mp4"
    output_video_path = "data/out_compress.mp4"

    # Compress video
    compress_video(input_video_path, output_video_path)
