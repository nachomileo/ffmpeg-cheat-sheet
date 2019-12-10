#! /bin/bash
#
# RTMP Push over ffmpeg

# Made by Nacho Mileo / LSD Live

VBR="500k" # Bitrate
FPS="30" # FPS
QUAL="medium" # Preset
RTMP_URL="rtmp://..."  # URL
AUTH="rtmpauth=USER:PASS" # Use rtmpauth=USER:PASS
SOURCE="bbb.mp4" # Source 
STREAM1="lsdtest1_1" # Stream
STREAM2="lsdtest1_2" # Stream
STREAM3="lsdtest1_3" # Stream
STREAM4="lsdtest1_4" # Stream
CAPTURE="video=Osprey-700 HD Video Device 1:audio=SDI Input 1 (Osprey-700 HD 1)"


ffmpeg  -report -rtbufsize 256M \
		-f dshow \
		-i "$CAPTURE" \
		-codec:v libx264 -s:v 640x360 -pix_fmt:v yuv420p -threads 4 -bufsize:v 1000k -g:v 50 -preset:v veryfast \
		-profile:v baseline -level:v 3.1 -b:v 400k -maxrate:v 1100k -codec:a libmp3lame -b:a 96k -strict -2 \
		-f flv "$RTMP_URL?$AUTH/$STREAM1" \
		-codec:v libx264 -s:v 854x480 -pix_fmt:v yuv420p -threads 4 -bufsize:v 1000k -g:v 50 -preset:v veryfast \
		-profile:v baseline -level:v 3.1 -b:v 800k -maxrate:v 1100k -codec:a libmp3lame -b:a 96k -strict -2 \
		-f flv "$RTMP_URL?$AUTH/$STREAM2" \
		-codec:v libx264 -s:v 1280x720 -pix_fmt:v yuv420p -threads 4 -bufsize:v 1000k -g:v 50 -preset:v veryfast \
		-profile:v baseline -level:v 3.1 -b:v 1200k -maxrate:v 1100k -codec:a libmp3lame -b:a 96k -strict -2 \
		-f flv "$RTMP_URL?$AUTH/$STREAM3"
