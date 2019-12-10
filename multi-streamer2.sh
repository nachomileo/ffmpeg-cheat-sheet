#! /bin/bash
#
# RTMP Push over ffmpeg
# Multistream v2
# Made by Nacho Mileo / LSD Live

FPS="30" # FPS
QUAL="medium" # Preset
RTMP_URL="rtmp://..."  # URL
AUTH="rtmpauth=USER:PASS" # Use rtmpauth=USER:PASS
SOURCE="bbb.mp4" # Source 
STREAM1="lsdtest3_1" # Stream
STREAM2="lsdtest3_2" # Stream
STREAM3="lsdtest3_3" # Stream
STREAM4="lsdtest3_4" # Stream


ffmpeg  -report -rtbufsize 256M \
		-i "$SOURCE" \
		-codec:v libx264 -s:v 640x360 -pix_fmt:v yuv420p -threads 4 -bufsize:v 1000k -g:v 50 -preset:v veryfast \
		-profile:v baseline -level:v 3.1 -b:v 200k -maxrate:v 1100k -codec:a libmp3lame -b:a 96k -strict -2 \
		-f flv "$RTMP_URL?$AUTH/$STREAM1" \
		-codec:v libx264 -s:v 854x480 -pix_fmt:v yuv420p -threads 4 -bufsize:v 1000k -g:v 50 -preset:v veryfast \
		-profile:v baseline -level:v 3.1 -b:v 800k -maxrate:v 1100k -codec:a libmp3lame -b:a 96k -strict -2 \
		-f flv "$RTMP_URL?$AUTH/$STREAM2" \
		-codec:v libx264 -s:v 1280x720 -pix_fmt:v yuv420p -threads 4 -bufsize:v 1000k -g:v 50 -preset:v veryfast \
		-profile:v baseline -level:v 3.1 -b:v 1200k -maxrate:v 1100k -codec:a libmp3lame -b:a 96k -strict -2 \
		-f flv "$RTMP_URL?$AUTH/$STREAM3" \
		-codec:v libx264 -s:v 1280x720 -pix_fmt:v yuv420p -threads 4 -bufsize:v 1000k -g:v 50 -preset:v veryfast \
		-profile:v baseline -level:v 3.1 -b:v 1800k -maxrate:v 1100k -codec:a libmp3lame -b:a 96k -strict -2 \
		-f flv "$RTMP_URL?$AUTH/$STREAM4"