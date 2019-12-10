#! /bin/bash
#
# RTMP Push over ffmpeg

# Made by Nacho Mileo / LSD Live

VBR="2500k" # Bitrate
FPS="30" # FPS
QUAL="medium" # Preset
RTMP_URL="rtmp://192.168.1.89/ABC"  # URL
AUTH="" # Use ?rtmpauth=USER:PASS
SOURCE="bbb.mp4" # Source 
STREAM="def" # Stream

ffmpeg  -re \
		-r $FPS \
		-i "$SOURCE" -deinterlace \
		-vcodec libx264 -pix_fmt yuv420p -preset medium \
		-g $(($FPS * 2)) -b:v $VBR -acodec libmp3lame -ar 44100 -threads 6 -q:a 3 -b:a 712000 -bufsize 512k \
		-f flv "$RTMP_URL$AUTH/$STREAM"