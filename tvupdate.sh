#!/bin/bash
# create a small website of downloaded video files incl. link
# to directly start them in kodi
#
# --- Input --- 
#
dir_website_temp='/srv/dev-disk-by-uuid-6416d6e7-a248-4554-9d15-d5643a6b8a67/ssddata/omv_scripts/tv/website'
dir_website_online='/srv/dev-disk-by-uuid-6416d6e7-a248-4554-9d15-d5643a6b8a67/ssddata/www/tvsendungen'
dir_nas_media='/srv/5fda0d53-e782-4f16-9775-20a361ff6e15'
user_group_website='nobody.users'
simplepush_id_file='/srv/dev-disk-by-uuid-6416d6e7-a248-4554-9d15-d5643a6b8a67/ssddata/omv_scripts/tv/simplepush-id.txt'
simplepush_id=$(cat "$simplepush_id_file")
ha_token_file='/srv/dev-disk-by-uuid-6416d6e7-a248-4554-9d15-d5643a6b8a67/ssddata/omv_scripts/tv/ha_token.txt'
ha_token=$(cat "$ha_token_file")
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
if [ ! -f "$ha_token_file" ]; then
    echo "ha_token_file does not exist. Will exit now"
fi
#
if [ ! -f "$simplepush_id_file" ]; then
    echo "simplepush_id_file does not exist. Push Notification will not work."
    sleep 10
fi
#
# ------------
# tvu Eltern
saved_durations_file=${dir_website_temp}/saved_durations_eltern.txt
if [ ! -e "$saved_durations_file" ] ; then
    touch "$saved_durations_file"
fi
saved_durations_file_old=${dir_website_temp}/saved_durations_eltern_old.txt
mv ${saved_durations_file} ${saved_durations_file_old}
echo 'saved durations in minutes' > ${saved_durations_file}
#
mv ${dir_website_temp}/tvvorschau ${dir_website_temp}/tvvorschaualt
mkdir ${dir_website_temp}/tvvorschau
echo ' '
echo '--- Schreibe TV-Sendungen Eltern in html-Datei ---'
echo ' '
echo "Eltern - Hauptordner"
set -e
cd ${dir_nas_media}/TVSendungen
set +e
echo '<!doctype html>
<html>
  <header>
    <meta charset="utf-8">
    <title>TV-Sendungen</title>
    <style type="text/css">
      h1 {color:red;font-size:medium;font-family:sans-serif;}
      li {color:black;font-family:sans-serif;line-height:24px;}
      p {color:black;font-family:sans-serif;}
      a {color:inherit;}
      a:link {color:inherit;}
      a:visited {color:inherit;}
    </style>
  </head>
  <body>
    <script language="javascript"> 

    function PostToHA(filepath){
      var url = "http://homeassistant.fritz.box:8123/api/events/play_on_kodi_wz";

      var xhr = new XMLHttpRequest();
      xhr.open("POST", url);
' > ${dir_website_temp}/index.html
echo "      xhr.setRequestHeader(\"Authorization\", \"Bearer ${ha_token}\");" >> ${dir_website_temp}/index.html
echo '      xhr.setRequestHeader("content-type", "application/json");

      xhr.onreadystatechange = function () {
        if (xhr.readyState === 4) {
            console.log(xhr.status);
            console.log(xhr.responseText);
        }};

      var data = `{
        "filepath": "` + filepath + `"
      }`;

      xhr.send(data);
    }
    </script>
    <nobr>
    <h1>Eltern-Hauptordner&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="kinder/index.html" style="color:darkorange;text-decoration:none;border-bottom: 1px solid darkorange;font-weight:bold;">=> Zu den Kindern</a>
    <ul>' >> ${dir_website_temp}/index.html
#
for datei in *
do
if [[ $datei =~ .*\.(mp4|mkv) ]]; then
  min_saved=$(grep "${datei}" "${saved_durations_file_old}" | tail -1 | cut -d: -f2)
  if [ -n "$min_saved" ] && [ "$min_saved" -eq "$min_saved" ] 2>/dev/null; then
    min=$min_saved
  else
    sek=$(ffprobe -show_format "${datei}" | sed -n '/duration/s/.*=//p')
    sekint=${sek%.*}
    min=$(( $sekint /60 ))
  fi
  echo "${datei}:${min}" >> ${saved_durations_file}
  vorschau=$(echo ${datei%.*} | tr -cd '[:alnum:]')
  echo "    <li><a href='javascript:PostToHA(\"/var/media/Toshiba4T/TVSendungen/${datei}\")'><b>${datei%.*}</b></a>&nbsp;&nbsp;<span style=\"color:red\">(${min})</span>&nbsp;&nbsp;(<a href=\"tvvorschau/${vorschau}.html\">Vorschau</a>)</li>" >> ${dir_website_temp}/index.html
  if test -e ${dir_website_temp}/tvvorschaualt/${vorschau}.jpg; then
    mv ${dir_website_temp}/tvvorschaualt/${vorschau}.jpg ${dir_website_temp}/tvvorschau/${vorschau}.jpg
    mv ${dir_website_temp}/tvvorschaualt/${vorschau}.html ${dir_website_temp}/tvvorschau/${vorschau}.html
  else
    # jpg Vorschau
    for prozent in {07..84..7}
    do
      ffmpegthumbnailer -i "$datei" -s 0 -t ${prozent}% -o ${dir_website_temp}/tvvorschau/temp${prozent}.jpg
    done
    rm $(du ${dir_website_temp}/tvvorschau/temp??.jpg | sort -n | awk 'NR == 1 { print $2 }')
    rm $(du ${dir_website_temp}/tvvorschau/temp??.jpg | sort -n | awk 'NR == 1 { print $2 }')
    montage -background '#ffffff' -geometry 960x540+2+2 -tile 1x10 ${dir_website_temp}/tvvorschau/temp??.jpg ${dir_website_temp}/tvvorschau/${vorschau}.jpg
    rm ${dir_website_temp}/tvvorschau/temp??.jpg
    #html Vorschau
    echo "<!doctype html>
  <html>
  <header>
    <meta charset=\"utf-8\">
    <title>${datei%.*}</title>
  </head>
  <body>
    <img src=${vorschau}.jpg width=\"100%\">
  </body>
  </html>" > ${dir_website_temp}/tvvorschau/${vorschau}.html
  fi
fi
done
echo '    </ul><br>' >> ${dir_website_temp}/index.html
#
for verzeichnis in *
do
if test -d "${verzeichnis}"; then
  echo "Eltern - ${verzeichnis}"
  cd "${verzeichnis}"
  echo "${verzeichnis}" | tr _ " " | awk '{print "    <h1>" $0 "</h1>"}'>> ${dir_website_temp}/index.html
  echo '    <ul>' >> ${dir_website_temp}/index.html
  verzeichnisolz=$(echo "${verzeichnis}" | tr _ " ")
  for datei in *
  do
  if [[ $datei =~ .*\.(mp4|mkv) ]]; then
    min_saved=$(grep "${datei}" "${saved_durations_file_old}" | tail -1 | cut -d: -f2)
    if [ -n "$min_saved" ] && [ "$min_saved" -eq "$min_saved" ] 2>/dev/null; then
      min=$min_saved
    else
      sek=$(ffprobe -show_format "${datei}" | sed -n '/duration/s/.*=//p')
      sekint=${sek%.*}
      min=$(( $sekint /60 ))
    fi
    echo "${datei}:${min}" >> ${saved_durations_file}
    vorschau=$(echo ${datei%.*} | tr -cd '[:alnum:]')
    echo "      <li><a href='javascript:PostToHA(\"/var/media/Toshiba4T/TVSendungen/${verzeichnis}/${datei}\")'><b>${datei%.*}</b></a>&nbsp;&nbsp;<span style=\"color:red\">(${min})</span>&nbsp;&nbsp;(<a href=\"tvvorschau/${vorschau}.html\">Vorschau</a>)</li>" >> ${dir_website_temp}/index.html
  if test -e ${dir_website_temp}/tvvorschaualt/${vorschau}.jpg; then
    mv ${dir_website_temp}/tvvorschaualt/${vorschau}.jpg ${dir_website_temp}/tvvorschau/${vorschau}.jpg
    mv ${dir_website_temp}/tvvorschaualt/${vorschau}.html ${dir_website_temp}/tvvorschau/${vorschau}.html
  else
    # jpg Vorschau
    for prozent in {07..84..7}
    do
      ffmpegthumbnailer -i "$datei" -s 0 -t ${prozent}% -o ${dir_website_temp}/tvvorschau/temp${prozent}.jpg
    done
    rm $(du ${dir_website_temp}/tvvorschau/temp??.jpg | sort -n | awk 'NR == 1 { print $2 }')
    rm $(du ${dir_website_temp}/tvvorschau/temp??.jpg | sort -n | awk 'NR == 1 { print $2 }')
    montage -background '#ffffff' -geometry 960x540+2+2 -tile 1x10 ${dir_website_temp}/tvvorschau/temp??.jpg ${dir_website_temp}/tvvorschau/${vorschau}.jpg
    rm ${dir_website_temp}/tvvorschau/temp??.jpg
    #html Vorschau
    echo "<!doctype html>
  <html>
  <header>
    <meta charset=\"utf-8\">
    <title>${datei%.*}</title>
  </head>
  <body>
    <img src=${vorschau}.jpg width=\"100%\">
  </body>
  </html>" > ${dir_website_temp}/tvvorschau/${vorschau}.html
  fi
  fi
  done
  echo '    </ul><br>' >> ${dir_website_temp}/index.html
  cd ..
fi
done
d=$(date +%d.%m.%Y)
echo "    <p>Stand: $d</p>" >> ${dir_website_temp}/index.html
echo '    </nobr>
    </body>
</html>' >> ${dir_website_temp}/index.html
#
rm -r ${dir_website_temp}/tvvorschaualt
rm ${saved_durations_file_old}
# -------------------
# tvu Kinder
saved_durations_file=${dir_website_temp}/saved_durations_kinder.txt
if [ ! -e "$saved_durations_file" ] ; then
    touch "$saved_durations_file"
fi
saved_durations_file_old=${dir_website_temp}/saved_durations_kinder_old.txt
mv ${saved_durations_file} ${saved_durations_file_old}
echo 'saved durations in minutes' > ${saved_durations_file}
#
mv ${dir_website_temp}/tvvorschaukinder ${dir_website_temp}/tvvorschaukinderalt
mkdir ${dir_website_temp}/tvvorschaukinder
echo ' '
echo ' '
echo '--- Schreibe TV-Sendungen Kinder in html-Datei ---'
echo ' '
echo "Kinder - Hauptordner"
cd ${dir_nas_media}/TVSendungen_Kinder
echo '<!doctype html>
<html>
  <header>
    <meta charset="utf-8">
    <title>TV-Sendungen</title>
    <style type="text/css">
      h1 {color:red;font-size:medium;font-family:sans-serif;}
      li {color:black;font-family:sans-serif;line-height:24px;}
      p {color:black;font-family:sans-serif;}
      a {color:inherit;}
      a:link {color:inherit;}
      a:visited {color:inherit;}
    </style>
  </head>
  <body>
    <script language="javascript"> 

    function PostToHA(filepath){
      var url = "http://homeassistant.fritz.box:8123/api/events/play_on_kodi_wz";

      var xhr = new XMLHttpRequest();
      xhr.open("POST", url);
' > ${dir_website_temp}/indexkinder.html
echo "      xhr.setRequestHeader(\"Authorization\", \"Bearer ${ha_token}\");" >> ${dir_website_temp}/indexkinder.html
echo '      xhr.setRequestHeader("content-type", "application/json");

      xhr.onreadystatechange = function () {
        if (xhr.readyState === 4) {
            console.log(xhr.status);
            console.log(xhr.responseText);
        }};

      var data = `{
        "filepath": "` + filepath + `"
      }`;

      xhr.send(data);
    }
    </script>
    <nobr>
    <h1>Kinder-Hauptordner&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="../index.html" style="color:darkorange;text-decoration:none;border-bottom: 1px solid darkorange;font-weight:bold;">=> Zu den Eltern</a>
    <ul>' >> ${dir_website_temp}/indexkinder.html
#
for datei in *
do
if [[ $datei =~ .*\.(mp4|mkv) ]]; then
  min_saved=$(grep "${datei}" "${saved_durations_file_old}" | tail -1 | cut -d: -f2)
  if [ -n "$min_saved" ] && [ "$min_saved" -eq "$min_saved" ] 2>/dev/null; then
    min=$min_saved
  else
    sek=$(ffprobe -show_format "${datei}" | sed -n '/duration/s/.*=//p')
    sekint=${sek%.*}
    min=$(( $sekint /60 ))
  fi
  echo "${datei}:${min}" >> ${saved_durations_file}
  vorschau=$(echo ${datei%.*} | tr -cd '[:alnum:]')
  echo "    <li><a href='javascript:PostToHA(\"/var/media/Toshiba4T/TVSendungen_Kinder/${datei}\")'><b>${datei%.*}</b></a>&nbsp;&nbsp;<span style=\"color:red\">(${min})</span>&nbsp;&nbsp;(<a href=\"tvvorschaukinder/${vorschau}.html\">Vorschau</a>)</li>" >> ${dir_website_temp}/indexkinder.html
  if test -e ${dir_website_temp}/tvvorschaukinderalt/${vorschau}.jpg; then
    mv ${dir_website_temp}/tvvorschaukinderalt/${vorschau}.jpg ${dir_website_temp}/tvvorschaukinder/${vorschau}.jpg
    mv ${dir_website_temp}/tvvorschaukinderalt/${vorschau}.html ${dir_website_temp}/tvvorschaukinder/${vorschau}.html
  else
    # jpg Vorschau
    for prozent in {07..84..7}
    do
      ffmpegthumbnailer -i "$datei" -s 0 -t ${prozent}% -o ${dir_website_temp}/tvvorschaukinder/temp${prozent}.jpg
    done
    rm $(du ${dir_website_temp}/tvvorschaukinder/temp??.jpg | sort -n | awk 'NR == 1 { print $2 }')
    rm $(du ${dir_website_temp}/tvvorschaukinder/temp??.jpg | sort -n | awk 'NR == 1 { print $2 }')
    montage -background '#ffffff' -geometry 960x540+2+2 -tile 1x10 ${dir_website_temp}/tvvorschaukinder/temp??.jpg ${dir_website_temp}/tvvorschaukinder/${vorschau}.jpg
    rm ${dir_website_temp}/tvvorschaukinder/temp??.jpg
    #html Vorschau
    echo "<!doctype html>
  <html>
  <header>
    <meta charset=\"utf-8\">
    <title>${datei%.*}</title>
  </head>
  <body>
    <img src=${vorschau}.jpg width=\"100%\">
  </body>
  </html>" > ${dir_website_temp}/tvvorschaukinder/${vorschau}.html
  fi
fi
done
echo '    </ul><br>' >> ${dir_website_temp}/indexkinder.html
#
for verzeichnis in *
do
if test -d "${verzeichnis}"; then
  echo "Kinder - ${verzeichnis}"
  cd "${verzeichnis}"
  echo "${verzeichnis}" | tr _ " " | awk '{print "    <h1>" $0 "</h1>"}'>> ${dir_website_temp}/indexkinder.html
  echo '    <ul>' >> ${dir_website_temp}/indexkinder.html
  verzeichnisolz=$(echo "${verzeichnis}" | tr _ " ")
  for datei in *
  do
  if [[ $datei =~ .*\.(mp4|mkv) ]]; then
    min_saved=$(grep "${datei}" "${saved_durations_file_old}" | tail -1 | cut -d: -f2)
    if [ -n "$min_saved" ] && [ "$min_saved" -eq "$min_saved" ] 2>/dev/null; then
      min=$min_saved
    else
      sek=$(ffprobe -show_format "${datei}" | sed -n '/duration/s/.*=//p')
      sekint=${sek%.*}
      min=$(( $sekint /60 ))
    fi
    echo "${datei}:${min}" >> ${saved_durations_file}
    vorschau=$(echo ${datei%.*} | tr -cd '[:alnum:]')
    echo "      <li><a href='javascript:PostToHA(\"/var/media/Toshiba4T/TVSendungen_Kinder/${verzeichnis}/${datei}\")'><b>${datei%.*}</b></a>&nbsp;&nbsp;<span style=\"color:red\">(${min})</span>&nbsp;&nbsp;(<a href=\"tvvorschaukinder/${vorschau}.html\">Vorschau</a>)</li>" >> ${dir_website_temp}/indexkinder.html
  if test -e ${dir_website_temp}/tvvorschaukinderalt/${vorschau}.jpg; then
    mv ${dir_website_temp}/tvvorschaukinderalt/${vorschau}.jpg ${dir_website_temp}/tvvorschaukinder/${vorschau}.jpg
    mv ${dir_website_temp}/tvvorschaukinderalt/${vorschau}.html ${dir_website_temp}/tvvorschaukinder/${vorschau}.html
  else
    # jpg Vorschau
    for prozent in {07..84..7}
    do
      ffmpegthumbnailer -i "$datei" -s 0 -t ${prozent}% -o ${dir_website_temp}/tvvorschaukinder/temp${prozent}.jpg
    done
    rm $(du ${dir_website_temp}/tvvorschaukinder/temp??.jpg | sort -n | awk 'NR == 1 { print $2 }')
    rm $(du ${dir_website_temp}/tvvorschaukinder/temp??.jpg | sort -n | awk 'NR == 1 { print $2 }')
    montage -background '#ffffff' -geometry 960x540+2+2 -tile 1x10 ${dir_website_temp}/tvvorschaukinder/temp??.jpg ${dir_website_temp}/tvvorschaukinder/${vorschau}.jpg
    rm ${dir_website_temp}/tvvorschaukinder/temp??.jpg
    #html Vorschau
    echo "<!doctype html>
  <html>
  <header>
    <meta charset=\"utf-8\">
    <title>${datei%.*}</title>
  </head>
  <body>
    <img src=${vorschau}.jpg width=\"100%\">
  </body>
  </html>" > ${dir_website_temp}/tvvorschaukinder/${vorschau}.html
  fi
  fi
  done
  echo '    </ul><br>' >> ${dir_website_temp}/indexkinder.html
  cd ..
fi
done
d=$(date +%d.%m.%Y)
echo "    <p>Stand: $d</p>" >> ${dir_website_temp}/indexkinder.html
echo '    </nobr>
    </body>
</html>' >> ${dir_website_temp}/indexkinder.html
#
rm -r ${dir_website_temp}/tvvorschaukinderalt
rm ${saved_durations_file_old}
# ------------------
# Stell die Liste der TVSendungen online
echo '--- Kopiere die TV-Sendungen-Seite auf den Webserver ---'
cd ${dir_website_temp}
cp index.html ${dir_website_online}/index.html
cp indexkinder.html ${dir_website_online}/kinder/index.html
rm ${dir_website_online}/tvvorschau/*
cp tvvorschau/* ${dir_website_online}/tvvorschau/
rm ${dir_website_online}/kinder/tvvorschaukinder/*
cp tvvorschaukinder/* ${dir_website_online}/kinder/tvvorschaukinder/
chown -R ${user_group_website} ${dir_website_online}
chmod -R 755 ${dir_website_online}
sleep 1
#
# melde den Plattenplatz aufs Handy
echo '--- Melde Plattenplatz aufs Handy ---'
msg1=$(df -h | awk '{if (match($1,/(Toshiba4T)/)) {print "Kodi " $4}}')
msg2=$(df -h | awk '{if (match($1,/(sdb1)/)) {print "HDD6T " $4}}')
msg3=$(df -h | awk '{if (match($1,/(sda1)/)) {print "SSD " $4}}')
msg4=$(df -h | awk '{if (match($1,/(mmcblk1p1)/)) {print "SD " $4}}')
msg=$(echo "$msg1 - $msg2 - $msg3 - $msg4")
echo $msg
curl -X POST -H "Authorization: Bearer ${ha_token}" -H "Content-Type: application/json" -d '{"msg":"'"$msg"'"}' http://homeassistant.fritz.box:8123/api/events/kodi_plattenplatz
#
echo ' '
echo '--- Fertig ---'
date
