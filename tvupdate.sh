#!/bin/bash
# create a small website of downloaded video files incl. link
# to directly start them in kodi
#
# --- Input ---
#
dir_website_temp='/srv/dev-disk-by-label-ssddata/ssddata/omv_scripts/tv/website'
dir_website_online='/srv/dev-disk-by-label-ssddata/www/tvsendungen'
dir_nas_media='/srv/eaec4d04-9e72-4736-a72b-57d16e5b71b5'
user_group_website='nobody.users'
simplepush_id='123abc'
#
# -------------
#
# tvu Eltern
mv ${dir_website_temp}/tvvorschau ${dir_website_temp}/tvvorschaualt
mkdir ${dir_website_temp}/tvvorschau
echo '--- Schreibe TV-Sendungen in html-Datei ---'
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
    <nobr>
    <h1>Eltern-Hauptordner&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="kinder/index.html" style="color:darkorange;text-decoration:none;border-bottom: 1px solid darkorange;font-weight:bold;">=> Zu den Kindern</a>
    <ul>' > ${dir_website_temp}/index.html
#
for datei in *
do
if [[ $datei =~ .*\.(mp4|mkv) ]]; then
  sek=$(ffprobe -show_format "${datei}" | sed -n '/duration/s/.*=//p')
  sekint=${sek%.*}
  min=$(( $sekint /60 ))
  vorschau=$(echo ${datei%.*} | tr -cd '[:alnum:]')
  echo "    <li><a href='http://kodi-wz:8080/jsonrpc?request={\"jsonrpc\":\"2.0\",\"id\":\"1\",\"method\":\"Player.Open\",\"params\":{\"item\":{\"file\":\"/var/media/Intenso/TVSendungen/${datei}\"}}}'><b>${datei%.*}</b></a>&nbsp;&nbsp;<span style=\"color:red\">(${min})</span>&nbsp;&nbsp;(<a href=\"https://www.google.de/search?s&btnI=Im+Feeling+Lucky&q=${datei%.*}&nbsp;site:zdf.de&nbsp;OR&nbsp;site:ardmediathek.de\">schau&nbsp;nach</a>)&nbsp;&nbsp;(<a href=\"tvvorschau/${vorschau}.html\">Vorschau</a>)</li>" >> ${dir_website_temp}/index.html
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
  cd "${verzeichnis}"
  echo "${verzeichnis}" | tr _ " " | awk '{print "    <h1>" $0 "</h1>"}'>> ${dir_website_temp}/index.html
  echo '    <ul>' >> ${dir_website_temp}/index.html
  verzeichnisolz=$(echo "${verzeichnis}" | tr _ " ")
  for datei in *
  do
  if [[ $datei =~ .*\.(mp4|mkv) ]]; then
    sek=$(ffprobe -show_format "${datei}" | sed -n '/duration/s/.*=//p')
    sekint=${sek%.*}
    min=$(( $sekint /60 ))
    vorschau=$(echo ${datei%.*} | tr -cd '[:alnum:]')
    echo "      <li><a href='http://kodi-wz:8080/jsonrpc?request={\"jsonrpc\":\"2.0\",\"id\":\"1\",\"method\":\"Player.Open\",\"params\":{\"item\":{\"file\":\"/var/media/Intenso/TVSendungen/${verzeichnis}/${datei}\"}}}'><b>${datei%.*}</b></a>&nbsp;&nbsp;<span style=\"color:red\">(${min})</span>&nbsp;&nbsp;(<a href=\"https://www.google.de/search?s&btnI=Im+Feeling+Lucky&q=${verzeichnisolz}&nbsp;${datei%.*}&nbsp;site:zdf.de&nbsp;OR&nbsp;site:ardmediathek.de\">schau&nbsp;nach</a>)&nbsp;&nbsp;(<a href=\"tvvorschau/${vorschau}.html\">Vorschau</a>)</li>" >> ${dir_website_temp}/index.html
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
# -------------------
# tvu Kinder
mv ${dir_website_temp}/tvvorschaukinder ${dir_website_temp}/tvvorschaukinderalt
mkdir ${dir_website_temp}/tvvorschaukinder
echo '--- Schreibe TV-Sendungen in html-Datei ---'
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
    <nobr>
    <h1>Kinder-Hauptordner&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="../index.html" style="color:darkorange;text-decoration:none;border-bottom: 1px solid darkorange;font-weight:bold;">=> Zu den Eltern</a>
    <ul>' > ${dir_website_temp}/indexkinder.html
#
for datei in *
do
if [[ $datei =~ .*\.(mp4|mkv) ]]; then
  sek=$(ffprobe -show_format "${datei}" | sed -n '/duration/s/.*=//p')
  sekint=${sek%.*}
  min=$(( $sekint /60 ))
  vorschau=$(echo ${datei%.*} | tr -cd '[:alnum:]')
  echo "    <li><a href='http://kodi-wz:8080/jsonrpc?request={\"jsonrpc\":\"2.0\",\"id\":\"1\",\"method\":\"Player.Open\",\"params\":{\"item\":{\"file\":\"/var/media/Intenso/TVSendungen_Kinder/${datei}\"}}}'><b>${datei%.*}</b></a>&nbsp;&nbsp;<span style=\"color:red\">(${min})</span>&nbsp;&nbsp;(<a href=\"https://www.google.de/search?s&btnI=Im+Feeling+Lucky&q=${datei%.*}&nbsp;site:zdf.de&nbsp;OR&nbsp;site:ardmediathek.de\">schau&nbsp;nach</a>)&nbsp;&nbsp;(<a href=\"tvvorschaukinder/${vorschau}.html\">Vorschau</a>)</li>" >> ${dir_website_temp}/indexkinder.html
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
  cd "${verzeichnis}"
  echo "${verzeichnis}" | tr _ " " | awk '{print "    <h1>" $0 "</h1>"}'>> ${dir_website_temp}/indexkinder.html
  echo '    <ul>' >> ${dir_website_temp}/indexkinder.html
  verzeichnisolz=$(echo "${verzeichnis}" | tr _ " ")
  for datei in *
  do
  if [[ $datei =~ .*\.(mp4|mkv) ]]; then
    sek=$(ffprobe -show_format "${datei}" | sed -n '/duration/s/.*=//p')
    sekint=${sek%.*}
    min=$(( $sekint /60 ))
    vorschau=$(echo ${datei%.*} | tr -cd '[:alnum:]')
    echo "      <li><a href='http://kodi-wz:8080/jsonrpc?request={\"jsonrpc\":\"2.0\",\"id\":\"1\",\"method\":\"Player.Open\",\"params\":{\"item\":{\"file\":\"/var/media/Intenso/TVSendungen_Kinder/${verzeichnis}/${datei}\"}}}'><b>${datei%.*}</b></a>&nbsp;&nbsp;<span style=\"color:red\">(${min})</span>&nbsp;&nbsp;(<a href=\"https://www.google.de/search?s&btnI=Im+Feeling+Lucky&q=${verzeichnisolz}&nbsp;${datei%.*}&nbsp;site:zdf.de&nbsp;OR&nbsp;site:ardmediathek.de\">schau&nbsp;nach</a>)&nbsp;&nbsp;(<a href=\"tvvorschaukinder/${vorschau}.html\">Vorschau</a>)</li>" >> ${dir_website_temp}/indexkinder.html
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
# ------------------
# Stell die Liste der TVSendungen online
echo '--- Stelle TV-Sendungen online ---'
cd ${dir_website_temp}
cp index.html ${dir_website_online}/index.html
cp indexkinder.html ${dir_website_online}/kinder/index.html
rm ${dir_website_online}/tvvorschau/*
cp tvvorschau/* ${dir_website_online}/tvvorschau/
rm ${dir_website_online}/kinder/tvvorschaukinder/*
cp tvvorschaukinder/* ${dir_website_online}/kinder/tvvorschaukinder/
chown -R ${user_group_website} ${dir_website_online}
chmod -R 755 ${dir_website_online}
sleep 2
#
# melde den Plattenplatz aufs Handy
echo '--- Melde Plattenplatz aufs Handy ---'
msg1=$(df -h | awk '{if (match($1,/(Intenso)/)) {print "Kodi " $4}}')
msg2=$(df -h | awk '{if (match($1,/(sda1)/)) {print "HDD6T " $4}}')
msg3=$(df -h | awk '{if (match($1,/(sdb1)/)) {print "SSD-Sys " $4}}')
msg4=$(df -h | awk '{if (match($1,/(sdb2)/)) {print "SSD-Dat " $4}}')
msg=$(echo "$msg1 - $msg2 - $msg3 - $msg4") && curl "https://api.simplepush.io/send/${simplepush_id}/fertig/$msg" 
#
echo '--- Fertig ---'
date
