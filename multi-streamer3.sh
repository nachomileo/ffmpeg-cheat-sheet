#! /bin/bash
#
# RTMP Push over ffmpeg
# Multistream v3
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

ffmpeg  -i "$SOURCE" \
		-filter_complex "[0:0]yadif=0:0,split=4[v1][v2][v3][v4];[v1]scale=1280:720[v1o];[v2]scale=800:450[v2o];[v3]scale=640:360[v3o];[v4]scale=320:180[v4o];[0:1]
asplit=4[a1][a2][a3][a4]" \
		-map "[v1o]" -map "[a1"] -pix_fmt yuv420p  \
		-r 25 -c:v libx264 -preset veryfast -x264opts keyint=50:min-keyint=50  \
		-crf 18 -maxrate 3372k -bufsize 7000k -profile:v high -aspect 16:9  \
		-c:a libvo_aacenc -b:a 128k -ac 2 \
		-f flv "$RTMP_URL?$AUTH/$STREAM1" \
		-map "[v2o]" -map "[a2"] -pix_fmt yuv420p\
		-r 25 -c:v libx264 -preset veryfast -x264opts keyint=50:min-keyint=50 \
		-crf 18 -maxrate 2372k -bufsize 5000k -profile:v main -aspect 16:9 \
		-c:a libvo_aacenc -b:a 128k -ac 2\
		-f flv "$RTMP_URL?$AUTH/$STREAM2" \
		-map "[v3o]" -map "[a3"] -pix_fmt yuv420p\
		-r 25 -c:v libx264 -preset veryfast -x264opts keyint=50:min-keyint=50 \
		-crf 18 -maxrate 1404k -bufsize 3000k -profile:v main -aspect 16:9 \
		-c:a libvo_aacenc -b:a 96k -ac 2 \
		-f flv "$RTMP_URL?$AUTH/$STREAM3" \
		-map "[v4o]" -map "[a4"] -pix_fmt yuv420p\
		-r 10 -c:v libx264 -preset veryfast -x264opts keyint=20:min-keyint=20 \
		-crf 18 -maxrate 252k -bufsize 500k -profile:v baseline -aspect 16:9 \
		-c:a libvo_aacenc -b:a 48k -ac 2 \
		-f flv "$RTMP_URL?$AUTH/$STREAM4" \