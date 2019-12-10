#! /bin/bash
#
# RTMP Push over ffmpeg - ONE QUALITY - NonAuth

# Made by Nacho Mileo / LSD Live

VBR="500k" # Bitrate
FPS="30" # FPS
QUAL="medium" # Preset
RTMP_URL="rtmp://..."  # URL

SOURCE="FaceTime HD Camera" # Source | Use "ffmpeg -list_devices true -f dshow -i dummy" to get the proper device ID
Stream="stream1" # Streamname

ffmpeg \
	-re \
	-enable-librtmp \
	-f avfoundation \
	-r $FPS \
    -i "$SOURCE" -deinterlace \
    -vcodec libx264 -pix_fmt yuv420p -preset $QUAL -g $(($FPS * 2)) -b:v $VBR \
    -acodec libmp3lame -ar 44100 -threads 6 -qscale 3 -b:a 712000 -bufsize 512k \
    -f flv "$RTMP_URL/$STREAM" live=true