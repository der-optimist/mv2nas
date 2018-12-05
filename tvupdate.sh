#!/bin/bash
# tvu Eltern
mv ~/tvvorschau ~/tvvorschaualt
mkdir ~/tvvorschau
echo '--- Schreibe TV-Sendungen in html-Datei ---'
set -e
cd /home/user1/smb/Intenso/TVSendungen
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
    <ul>' > ~/index.html
#
for datei in *
do
if [[ “$datei“ == “*.mp4“ || “$datei“ == “*.mkv“ ]]; then
  sek=$(ffprobe -show_format "${datei}" | sed -n '/duration/s/.*=//p')
  sekint=${sek%.*}
  min=$(( $sekint /60 ))
  vorschau=$(echo ${datei%.*} | tr -cd '[:alnum:]')
  echo "    <li><a href='http://kodi-wz:8080/jsonrpc?request={\"jsonrpc\":\"2.0\",\"id\":\"1\",\"method\":\"Player.Open\",\"params\":{\"item\":{\"file\":\"/var/media/Intenso/TVSendungen/${datei}\"}}}'><b>${datei%.*}</b></a>&nbsp;&nbsp;<span style=\"color:red\">(${min})</span>&nbsp;&nbsp;(<a href=\"https://www.google.de/search?s&btnI=Im+Feeling+Lucky&q=${datei%.*}&nbsp;site:zdf.de&nbsp;OR&nbsp;site:ardmediathek.de\">schau&nbsp;nach</a>)&nbsp;&nbsp;(<a href=\"tvvorschau/${vorschau}.html\">Vorschau</a>)</li>" >> ~/index.html
  if test -e ~/tvvorschaualt/${vorschau}.jpg; then
    mv ~/tvvorschaualt/${vorschau}.jpg ~/tvvorschau/${vorschau}.jpg
    mv ~/tvvorschaualt/${vorschau}.html ~/tvvorschau/${vorschau}.html
  else
    # jpg Vorschau
    for prozent in {05..75..10}
    do
      ffmpegthumbnailer -i "$datei" -s 0 -t ${prozent}% -o ~/tvvorschau/temp${prozent}.jpg
    done
    rm $(du ~/tvvorschau/temp??.jpg | sort -n | awk 'NR == 1 { print $2 }')
    rm $(du ~/tvvorschau/temp??.jpg | sort -n | awk 'NR == 1 { print $2 }')
    montage -background '#ffffff' -geometry 960x540+2+2 -tile 1x6 ~/tvvorschau/temp??.jpg ~/tvvorschau/${vorschau}.jpg
    rm ~/tvvorschau/temp??.jpg
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
  </html>" > ~/tvvorschau/${vorschau}.html
  fi
fi
done
echo '    </ul><br>' >> ~/index.html
#
for verzeichnis in *
do
if test -d "${verzeichnis}"; then
  cd "${verzeichnis}"
  echo "${verzeichnis}" | tr _ " " | awk '{print "    <h1>" $0 "</h1>"}'>> ~/index.html
  echo '    <ul>' >> ~/index.html
  verzeichnisolz=$(echo "${verzeichnis}" | tr _ " ")
  for datei in *
  do
  if [[ “$datei“ == “*.mp4“ || “$datei“ == “*.mkv“ ]]; then
    sek=$(ffprobe -show_format "${datei}" | sed -n '/duration/s/.*=//p')
    sekint=${sek%.*}
    min=$(( $sekint /60 ))
    vorschau=$(echo ${datei%.*} | tr -cd '[:alnum:]')
    echo "      <li><a href='http://kodi-wz:8080/jsonrpc?request={\"jsonrpc\":\"2.0\",\"id\":\"1\",\"method\":\"Player.Open\",\"params\":{\"item\":{\"file\":\"/var/media/Intenso/TVSendungen/${verzeichnis}/${datei}\"}}}'><b>${datei%.*}</b></a>&nbsp;&nbsp;<span style=\"color:red\">(${min})</span>&nbsp;&nbsp;(<a href=\"https://www.google.de/search?s&btnI=Im+Feeling+Lucky&q=${verzeichnisolz}&nbsp;${datei%.*}&nbsp;site:zdf.de&nbsp;OR&nbsp;site:ardmediathek.de\">schau&nbsp;nach</a>)&nbsp;&nbsp;(<a href=\"tvvorschau/${vorschau}.html\">Vorschau</a>)</li>" >> ~/index.html
  if test -e ~/tvvorschaualt/${vorschau}.jpg; then
    mv ~/tvvorschaualt/${vorschau}.jpg ~/tvvorschau/${vorschau}.jpg
    mv ~/tvvorschaualt/${vorschau}.html ~/tvvorschau/${vorschau}.html
  else
    # jpg Vorschau
    for prozent in {05..75..10}
    do
      ffmpegthumbnailer -i "$datei" -s 0 -t ${prozent}% -o ~/tvvorschau/temp${prozent}.jpg
    done
    rm $(du ~/tvvorschau/temp??.jpg | sort -n | awk 'NR == 1 { print $2 }')
    rm $(du ~/tvvorschau/temp??.jpg | sort -n | awk 'NR == 1 { print $2 }')
    montage -background '#ffffff' -geometry 960x540+2+2 -tile 1x6 ~/tvvorschau/temp??.jpg ~/tvvorschau/${vorschau}.jpg
    rm ~/tvvorschau/temp??.jpg
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
  </html>" > ~/tvvorschau/${vorschau}.html
  fi
  fi
  done
  echo '    </ul><br>' >> ~/index.html
  cd ..
fi
done
d=$(date +%d.%m.%Y)
echo "    <p>Stand: $d</p>" >> ~/index.html
echo '    </nobr>
    </body>
</html>' >> ~/index.html
#
rm -r ~/tvvorschaualt
# -------------------
# tvu Kinder
mv ~/tvvorschaukinder ~/tvvorschaukinderalt
mkdir ~/tvvorschaukinder
echo '--- Schreibe TV-Sendungen in html-Datei ---'
cd /home/user1/smb/Intenso/TVSendungen_Kinder
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
    <ul>' > ~/indexkinder.html
#
for datei in *
do
if [[ “$datei“ == “*.mp4“ || “$datei“ == “*.mkv“ ]]; then
  sek=$(ffprobe -show_format "${datei}" | sed -n '/duration/s/.*=//p')
  sekint=${sek%.*}
  min=$(( $sekint /60 ))
  vorschau=$(echo ${datei%.*} | tr -cd '[:alnum:]')
  echo "    <li><a href='http://kodi-wz:8080/jsonrpc?request={\"jsonrpc\":\"2.0\",\"id\":\"1\",\"method\":\"Player.Open\",\"params\":{\"item\":{\"file\":\"/var/media/Intenso/TVSendungen_Kinder/${datei}\"}}}'><b>${datei%.*}</b></a>&nbsp;&nbsp;<span style=\"color:red\">(${min})</span>&nbsp;&nbsp;(<a href=\"https://www.google.de/search?s&btnI=Im+Feeling+Lucky&q=${datei%.*}&nbsp;site:zdf.de&nbsp;OR&nbsp;site:ardmediathek.de\">schau&nbsp;nach</a>)&nbsp;&nbsp;(<a href=\"tvvorschaukinder/${vorschau}.html\">Vorschau</a>)</li>" >> ~/indexkinder.html
  if test -e ~/tvvorschaukinderalt/${vorschau}.jpg; then
    mv ~/tvvorschaukinderalt/${vorschau}.jpg ~/tvvorschaukinder/${vorschau}.jpg
    mv ~/tvvorschaukinderalt/${vorschau}.html ~/tvvorschaukinder/${vorschau}.html
  else
    # jpg Vorschau
    for prozent in {05..75..10}
    do
      ffmpegthumbnailer -i "$datei" -s 0 -t ${prozent}% -o ~/tvvorschaukinder/temp${prozent}.jpg
    done
    rm $(du ~/tvvorschaukinder/temp??.jpg | sort -n | awk 'NR == 1 { print $2 }')
    rm $(du ~/tvvorschaukinder/temp??.jpg | sort -n | awk 'NR == 1 { print $2 }')
    montage -background '#ffffff' -geometry 960x540+2+2 -tile 1x6 ~/tvvorschaukinder/temp??.jpg ~/tvvorschaukinder/${vorschau}.jpg
    rm ~/tvvorschaukinder/temp??.jpg
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
  </html>" > ~/tvvorschaukinder/${vorschau}.html
  fi
fi
done
echo '    </ul><br>' >> ~/indexkinder.html
#
for verzeichnis in *
do
if test -d "${verzeichnis}"; then
  cd "${verzeichnis}"
  echo "${verzeichnis}" | tr _ " " | awk '{print "    <h1>" $0 "</h1>"}'>> ~/indexkinder.html
  echo '    <ul>' >> ~/indexkinder.html
  verzeichnisolz=$(echo "${verzeichnis}" | tr _ " ")
  for datei in *
  do
  if [[ “$datei“ == “*.mp4“ || “$datei“ == “*.mkv“ ]]; then
    sek=$(ffprobe -show_format "${datei}" | sed -n '/duration/s/.*=//p')
    sekint=${sek%.*}
    min=$(( $sekint /60 ))
    vorschau=$(echo ${datei%.*} | tr -cd '[:alnum:]')
    echo "      <li><a href='http://kodi-wz:8080/jsonrpc?request={\"jsonrpc\":\"2.0\",\"id\":\"1\",\"method\":\"Player.Open\",\"params\":{\"item\":{\"file\":\"/var/media/Intenso/TVSendungen_Kinder/${verzeichnis}/${datei}\"}}}'><b>${datei%.*}</b></a>&nbsp;&nbsp;<span style=\"color:red\">(${min})</span>&nbsp;&nbsp;(<a href=\"https://www.google.de/search?s&btnI=Im+Feeling+Lucky&q=${verzeichnisolz}&nbsp;${datei%.*}&nbsp;site:zdf.de&nbsp;OR&nbsp;site:ardmediathek.de\">schau&nbsp;nach</a>)&nbsp;&nbsp;(<a href=\"tvvorschaukinder/${vorschau}.html\">Vorschau</a>)</li>" >> ~/indexkinder.html
  if test -e ~/tvvorschaukinderalt/${vorschau}.jpg; then
    mv ~/tvvorschaukinderalt/${vorschau}.jpg ~/tvvorschaukinder/${vorschau}.jpg
    mv ~/tvvorschaukinderalt/${vorschau}.html ~/tvvorschaukinder/${vorschau}.html
  else
    # jpg Vorschau
    for prozent in {05..75..10}
    do
      ffmpegthumbnailer -i "$datei" -s 0 -t ${prozent}% -o ~/tvvorschaukinder/temp${prozent}.jpg
    done
    rm $(du ~/tvvorschaukinder/temp??.jpg | sort -n | awk 'NR == 1 { print $2 }')
    rm $(du ~/tvvorschaukinder/temp??.jpg | sort -n | awk 'NR == 1 { print $2 }')
    montage -background '#ffffff' -geometry 960x540+2+2 -tile 1x6 ~/tvvorschaukinder/temp??.jpg ~/tvvorschaukinder/${vorschau}.jpg
    rm ~/tvvorschaukinder/temp??.jpg
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
  </html>" > ~/tvvorschaukinder/${vorschau}.html
  fi
  fi
  done
  echo '    </ul><br>' >> ~/indexkinder.html
  cd ..
fi
done
d=$(date +%d.%m.%Y)
echo "    <p>Stand: $d</p>" >> ~/indexkinder.html
echo '    </nobr>
    </body>
</html>' >> ~/indexkinder.html
#
rm -r ~/tvvorschaukinderalt
# ------------------
# Stell die Liste der TVSendungen online
echo '--- Stelle TV-Sendungen online ---'
cd
cp index.html /home/user1/smb/html/tvsendungen/index.html
cp indexkinder.html /home/user1/smb/html/tvsendungen/kinder/index.html
rm /home/user1/smb/html/tvsendungen/tvvorschau/*
cp tvvorschau/* /home/user1/smb/html/tvsendungen/tvvorschau/
rm /home/user1/smb/html/tvsendungen/kinder/tvvorschaukinder/*
cp tvvorschaukinder/* /home/user1/smb/html/tvsendungen/kinder/tvvorschaukinder/
sleep 10
#
# melde den Plattenplatz aufs Handy
echo '--- Melde Plattenplatz aufs Handy ---'
msg2=$(df -h | awk '{if (match($1,/(sda1)/)) {print "SSD " $4}}')
msg3=$(df -h | awk '{if (match($1,/(Intenso)/)) {print "NAS " $4}}')
msg=$(echo “$msg2 - $msg3“) && curl "https://api.simplepush.io/send/yourid/fertig/$msg" 
#
echo '--- Fertig ---'
date
