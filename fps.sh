#!/bin/bash
# check fps
#
# --- Input --- 
#
dir_nas_media='/srv/5fda0d53-e782-4f16-9775-20a361ff6e15'
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
  fps=$(ffprobe -v 0 -of csv=p=0 -select_streams v:0 -show_entries stream=r_frame_rate,width,height "${datei}")
  echo "${datei}: ${fps}" >> ${path_fps}
fi
done

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
    fps=$(ffprobe -v 0 -of csv=p=0 -select_streams v:0 -show_entries stream=r_frame_rate,width,height "${datei}")
    echo "${datei}: ${fps}" >> ${path_fps}
  fi
  done
  cd ..
fi
done
# -------------------
# fps Kinder

#
echo ' '
echo ' '
echo "Kinder - Hauptordner"
cd ${dir_nas_media}/TVSendungen_Kinder
echo '

Kinder Hauptordner
' >> ${path_fps}
#
for datei in *
do
if [[ $datei =~ .*\.(mp4|mkv) ]]; then
  fps=$(ffprobe -v 0 -of csv=p=0 -select_streams v:0 -show_entries stream=r_frame_rate,width,height "${datei}")
  echo "${datei}: ${fps}" >> ${path_fps}
fi
done
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
    fps=$(ffprobe -v 0 -of csv=p=0 -select_streams v:0 -show_entries stream=r_frame_rate,width,height "${datei}")
    echo "${datei}: ${fps}" >> ${path_fps}
  fi
  done
  cd ..
fi
done
# ------------------
# Stell die Liste der TVSendungen online
echo 'done'
