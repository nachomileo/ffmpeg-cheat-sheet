#! /bin/bash
#
# mp4 Trascoding + m3u8 Creation + Subtitle Integration

# Made by Nacho Mileo

#VIDEO DEFINITIONS

#Bitrate
BR1="800k" # Bitrate1
BR2="2000k" # Bitrate2
BR3="4000k" # Bitrate3

#Sizes
HEIGHT1=480
HEIGHT2=720
HEIGHT3=1080

#FramesPerSecond
FPS="25"


#PROCESS DEFINITIONS

TOTALFILES=2 # Total ammount of videos to be transcoded
BASENAME="JD_" # Basename for all files, despite of their extension
VIDEOEXT=".mp4" # Video Extension

SUBSEXT=".srt" # Subtitles extension
LANG1="ES" # Language 1
LANG2="EN" # Language 2

# Text formatting for clearer terminal notifications
bold=$(tput bold)
normal=$(tput sgr0)
green=$(tput setaf 2)


for (( i = 1; i <= $TOTALFILES; i++ )); do
	echo "${normal}Processing ${bold}video #"$i;

	#Transcode Bitrate #1
	ffmpeg  -hide_banner -loglevel warning \
			-y -i "$BASENAME$i$VIDEOEXT" -c:v libx264 \
			-r 24 -x264opts 'keyint=48:min-keyint=48:no-scenecut' \
			-vf scale=-2:$HEIGHT1 -b:v $BR1 -maxrate $BR1 \
			-movflags faststart -bufsize 8600k \
			-profile:v main -preset fast -an "$i$BASENAME$BR1$VIDEOEXT" &&

	echo "${normal}Bitrate #1 - ${bold}DONE";

	#Transcode Bitrate #2
	ffmpeg  -hide_banner -loglevel warning \
			-y -i "$BASENAME$i$VIDEOEXT" -c:v libx264 \
			-r 24 -x264opts 'keyint=48:min-keyint=48:no-scenecut' \
			-vf scale=-2:$HEIGHT2 -b:v $BR2 -maxrate $BR2 \
			-movflags faststart -bufsize 8600k \
			-profile:v main -preset fast -an "$i$BASENAME$BR2$VIDEOEXT" &&

	echo "${normal}Bitrate #2 - ${bold}DONE";

	#Transcode Bitrate #3
	ffmpeg  -hide_banner -loglevel warning \
			-y -i "$BASENAME$i$VIDEOEXT" -c:v libx264 \
			-r 24 -x264opts 'keyint=48:min-keyint=48:no-scenecut' \
			-vf scale=-2:$HEIGHT3 -b:v $BR3 -maxrate $BR3 \
			-movflags faststart -bufsize 8600k \
			-profile:v main -preset fast -an "$i$BASENAME$BR3$VIDEOEXT" &&

	echo "${normal}Bitrate #3 - ${bold}DONE";

	#Transcode Audio
	ffmpeg  -hide_banner -loglevel warning \
			-y -i "$BASENAME$i$VIDEOEXT" \
			-map 0:1 -vn -c:a aac -b:a 192k -ar 48000 -ac 2 $BASENAME$i.m4a &&

	echo "${normal}Audio track - ${bold}DONE";

	#Convert subtitles to VTT
	ffmpeg  -hide_banner -loglevel warning \
			-y -i "$BASENAME$i$LANG1$SUBSEXT" subs$i_$LANG1.vtt &&

	ffmpeg  -hide_banner -loglevel warning \
			-y -i "$BASENAME$i$LANG2$SUBSEXT" subs$i_$LANG2.vtt &&			

	echo "${normal}SUBTITLES TO VTT - ${bold}DONE";

	#Prepare subtitles for packaging
	MP4Box -add subs$i_$LANG1.vtt:lang=$LANG1 subtitle$i$LANG1$VIDEOEXT;

	MP4Box -add subs$i_$LANG2.vtt:lang=$LANG2 subtitle$i$LANG2$VIDEOEXT;

	echo "${normal}SUBTITLES PREPARATION - ${bold}DONE";

	#HLS Packaging
	MP4Box  -dash 4000 -frag 4000 -rap \
			-segment-name 'segment_$RepresentationID$_' -fps $FPS \
			$i$BASENAME$BR1$VIDEOEXT#video:id=$HEIGHT1 \
			$i$BASENAME$BR2$VIDEOEXT#video:id=$HEIGHT2 \
			$i$BASENAME$BR3$VIDEOEXT#video:id=$HEIGHT3 \
			$BASENAME$i.m4a#audio:id=Spanish:role=main \
			subtitle$i$LANG1$VIDEOEXT:role=subtitle \
			subtitle$i$LANG2$VIDEOEXT:role=subtitle \
			-out hls$i/playlist.m3u8

	echo "${green}${bold}HLS VIDEO #$i - ${bold}COMPLETED";

	#DASH Packaging
	MP4Box  -dash 4000 -frag 4000 -rap \
			-segment-name 'segment_$RepresentationID$_' -fps $FPS \
			$i$BASENAME$BR1$VIDEOEXT#video:id=$HEIGHT1 \
			$i$BASENAME$BR2$VIDEOEXT#video:id=$HEIGHT2 \
			$i$BASENAME$BR3$VIDEOEXT#video:id=$HEIGHT3 \
			$BASENAME$i.m4a#audio:id=Spanish:role=main \
			subtitle$i$LANG1$VIDEOEXT:role=subtitle \
			subtitle$i$LANG2$VIDEOEXT:role=subtitle \
			-out dash$i/playlist.mpd

	echo "${green}${bold}DASH VIDEO #$i - ${bold}COMPLETED";
	echo "${green}${bold}VIDEO #$i - ${bold}COMPLETED";

done


# NOTES
# =====
# * The use of "-hide_banner -loglevel warning" makes the terminal more readable, but can be removed.
# * I'm using 3 renditions and 2 subtitles, but it can be adjusted
# * MP4Box is available for download via Homebrew: brew install gpac