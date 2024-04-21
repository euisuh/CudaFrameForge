from moviepy.editor import VideoFileClip
import os

def extract_frames(input_video_path, output_gif_path, start_time, end_time, fps=10):
    # Load the video clip
    video_clip = VideoFileClip(input_video_path)

    # Set start and end times
    start_seconds = sum(int(x) * 60 ** i for i, x in enumerate(reversed(start_time.split(":"))))
    end_seconds = sum(int(x) * 60 ** i for i, x in enumerate(reversed(end_time.split(":"))))

    # Extract subclip
    subclip = video_clip.subclip(start_seconds, end_seconds)

    # Write frames as GIF
    subclip.write_gif(output_gif_path, fps=fps)

    # Close the video clip
    video_clip.close()

if __name__ == "__main__":
    # Define input and output paths
    input_video_path = "data/feel-the-rhythm-seoul-compress.mp4"
    output_gif_path = "data/output.gif"

    # Define start and end time (format: MM:SS)
    start_time = "00:34"
    end_time = "00:41"

    # Extract frames and save as GIF
    extract_frames(input_video_path, output_gif_path, start_time, end_time)

    # Check if the GIF is generated
    if os.path.exists(output_gif_path):
        print("GIF created successfully!")
    else:
        print("Failed to create GIF.")
