#!/bin/bash
# check fps
#
# --- Input --- 
#
dir_nas_media='/srv/557832cf-e69b-43d9-a5da-a7051df9b990'
path_fps='/srv/dev-disk-by-uuid-6416d6e7-a248-4554-9d15-d5643a6b8a67/ssddata/omv_scripts/tv/fps.txt'
#
# -------------
# check required tools
if ! command -v ffprobe &> /dev/null
then
    echo "ffprobe could not be found. Will exit now"
    exit
fi
#
if ! command -v ffmpegthumbnailer &> /dev/null
then
    echo "ffmpegthumbnailer could not be found. Will exit now"
    exit
fi
#
if ! command -v montage &> /dev/null
then
    echo "montage could not be found. Will exit now"
    exit
fi
#
if [ ! -f "$simplepush_id_file" ]; then
    echo "simplepush_id_file does not exist. Push Notification will not work."
    sleep 10
fi
#
# ------------
# fps Eltern
echo ' '
echo "Eltern - Hauptordner"
set -e
cd ${dir_nas_media}/TVSendungen
set +e
echo 'Eltern Hauptordner
' > ${path_fps}
#
for datei in *
do
if [[ $datei =~ .*\.(mp4|mkv) ]]; then
  fps=$(ffprobe -v 0 -of csv=p=0 -select_streams v:0 -show_entries stream=r_frame_rate "${datei}")
  echo "${datei}: ${fps}" >> ${path_fps}
fi

#
for verzeichnis in *
do
if test -d "${verzeichnis}"; then
  echo "Eltern - ${verzeichnis}"
  cd "${verzeichnis}"
  echo " " >> ${path_fps}
  echo "${verzeichnis}" >> ${path_fps}
  for datei in *
  do
  if [[ $datei =~ .*\.(mp4|mkv) ]]; then
    fps=$(ffprobe -v 0 -of csv=p=0 -select_streams v:0 -show_entries stream=r_frame_rate "${datei}")
    echo "${datei}: ${fps}" >> ${path_fps}
  fi
# -------------------
# fps Kinder

#
echo ' '
echo ' '
echo "Kinder - Hauptordner"
cd ${dir_nas_media}/TVSendungen_Kinder
echo '

Kinder Hauptordner
' > ${path_fps}
#
for datei in *
do
if [[ $datei =~ .*\.(mp4|mkv) ]]; then
  fps=$(ffprobe -v 0 -of csv=p=0 -select_streams v:0 -show_entries stream=r_frame_rate "${datei}")
  echo "${datei}: ${fps}" >> ${path_fps}
fi
#
for verzeichnis in *
do
if test -d "${verzeichnis}"; then
  echo "Kinder - ${verzeichnis}"
  cd "${verzeichnis}"
  echo " " >> ${path_fps}
  echo "${verzeichnis}" >> ${path_fps}
  for datei in *
  do
  if [[ $datei =~ .*\.(mp4|mkv) ]]; then
    fps=$(ffprobe -v 0 -of csv=p=0 -select_streams v:0 -show_entries stream=r_frame_rate "${datei}")
    echo "${datei}: ${fps}" >> ${path_fps}
  fi
# ------------------
# Stell die Liste der TVSendungen online
echo 'done'
