# ffmpeg-cheat-sheet
Cheat sheet with FFMPEG commands

Download FFmpeg: https://www.ffmpeg.org/download.html
Full documentation: https://www.ffmpeg.org/ffmpeg.html

## Install in Mac
Homebrew: [`/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"`]
Then run [`brew install ffmpeg`]


## Basic conversion

````
ffmpeg -i in.mp4 out.avi
````

## Get file info

````
ffmpeg -i video.mp4
````

If you don’t want to see the FFmpeg banner and other details, but only the media file information, use -hide_banner flag like below.

````
ffmpeg -i video.mp4 -hide_banner
````

## Converting video files to audio files

````
ffmpeg -i in.mp4 -vn out.mp3
````
Also, you can use various audio transcoding options to the output file as shown below.

````
ffmpeg -i in.mp4 -vn -ar 44100 -ac 2 -ab 320 -f mp3 out.mp3
````

## Split audio/video files into multiple parts

````
ffmpeg -i in.mp4 -t 00:00:30 -c copy part1.mp4 -ss 00:00:30 -codec copy part2.mp4
````

##  Add subtitles to a video file

````
ffmpeg -i in.mp4 -i subtitle.srt -map 0 -map 1 -c copy -c:v libx264 -crf 23 -preset veryfast out.mp4
````


## List Capture Devices

````
ffmpeg -list_devices true -f dshow -i dummy
````

Check Video Support
````
ffmpeg -list_options true -f dshow -i video="Decklink Video Capture"
````


## Download "Transport Stream" video streams

1. Locate the playlist file, e.g. using Chrome > F12 > Network > Filter: m3u8
2. Download and concatenate the video fragments:

````
ffmpeg -i "path_to_playlist.m3u8" -c copy -bsf:a aac_adtstoasc out.mp4
````

If you get a "Protocol 'https not on whitelist 'file,crypto'!" error, add the `protocol_whitelist` option:

````
ffmpeg -protocol_whitelist "file,http,https,tcp,tls" -i "path_to_playlist.m3u8" -c copy -bsf:a aac_adtstoasc out.mp4
````


## Extract the frames from a video

To extract all frames from between 1 and 5 seconds, and also between 11 and 15 seconds:

````
ffmpeg -i in.mp4 -vf select='between(t,1,5)+between(t,11,15)' -vsync 0 out%d.png
````

To extract one frame per second only:

````
ffmpeg -i in.mp4 -fps=1 -vsync 0 out%d.png
````


## STREAM A FILE TO FMS AS IF IT WERE LIVE

````
ffmpeg -re -i localFile.mp4 -c copy -f flv rtmp://server/live/streamName
````

## Create a video slideshow from images

Parameters: `-r` marks the image framerate (inverse time of each image); `-vf fps=25` marks the true framerate of the output.

````
ffmpeg -r 1/5 -i img%03d.png -c:v libx264 -vf fps=25 -pix_fmt yuv420p out.mp4
````


## Check Keyframes of a Stream

````
ffprobe -loglevel error -skip_frame nokey -select_streams v:0 -show_entries frame=pkt_pts_time -of csv=print_section=0 "path_to_playlist.m3u8" 
````
