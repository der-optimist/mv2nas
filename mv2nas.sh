#!/bin/bash
cd /home/user1/downloads
rename 's/_daserste_/_ard_/' *
#
echo '--- schiebe aufs NAS ---'
echo '- Kinder -'
echo 'Bibi Blocksberg'
rsync --progress --remove-source-files *Bibi*Blocksberg* /home/user1/smb/Intenso/TVSendungen_Kinder/Bibi_Blocksberg 2>/dev/null
#
echo 'Bibi und Tina'
rsync --progress --remove-source-files *Bibi*und*Tina* /home/user1/smb/Intenso/TVSendungen_Kinder/Bibi_und_Tina 2>/dev/null
#
echo 'Biene Maja'
rsync --progress --remove-source-files *Biene*Maja* /home/user1/smb/Intenso/TVSendungen_Kinder/Biene_Maja 2>/dev/null
#
echo 'Conni'
rsync --progress --remove-source-files *Meine*Freundin*Conni* /home/user1/smb/Intenso/TVSendungen_Kinder/Conni 2>/dev/null
#
echo 'Mia and me'
rsync --progress --remove-source-files *Mia*and*me* /home/user1/smb/Intenso/TVSendungen_Kinder/Mia_and_me 2>/dev/null
#
echo 'Peter Pan'
rsync --progress --remove-source-files *Peter*Pan* /home/user1/smb/Intenso/TVSendungen_Kinder/Peter_Pan 2>/dev/null
#
echo '- Eltern -'
echo 'Der Alte'
rsync --progress --remove-source-files *ZDF*'Der Alte'* /home/user1/smb/Intenso/TVSendungen/60_-_Der_Alte 2>/dev/null
#
echo 'Die Chefin'
rsync --progress --remove-source-files *ZDF*'Die Chefin'* /home/user1/smb/Intenso/TVSendungen/60_-_Die_Chefin 2>/dev/null
#
echo 'Die Spezialisten'
rsync --progress --remove-source-files *ZDF*'Die Spezialisten'* /home/user1/smb/Intenso/TVSendungen/45_-_Die_Spezialisten 2>/dev/null
#
echo 'Fernsehfilm der Woche'
rsync --progress --remove-source-files *ZDF*'Fernsehfilm der Woche'* /home/user1/smb/Intenso/TVSendungen/90_-_Fernsehfilm_der_Woche 2>/dev/null
#
echo 'Der Kriminalist'
rsync --progress --remove-source-files *ZDF*'Kriminalist'* /home/user1/smb/Intenso/TVSendungen/60_-_Kriminalist 2>/dev/null
#
echo 'Letzte Spur Berlin'
rsync --progress --remove-source-files *ZDF*'Letzte Spur Berlin'* /home/user1/smb/Intenso/TVSendungen/45_-_Letzte_Spur_Berlin 2>/dev/null
#
echo 'Ein starkes Team'
rsync --progress --remove-source-files *ZDF*starkes*Team* /home/user1/smb/Intenso/TVSendungen/90_-_Ein_starkes_Team 2>/dev/null
#
echo 'Polizeiruf'
rsync --progress --remove-source-files *'Polizeiruf'* /home/user1/smb/Intenso/TVSendungen/90_-_Polizeiruf 2>/dev/null
#
echo 'Soko Leipzig'
rsync --progress --remove-source-files *ZDF*'SOKO Leipzig'* /home/user1/smb/Intenso/TVSendungen/45_-_Soko_Leipzig 2>/dev/null
#
echo 'Soko Koeln'
rsync --progress --remove-source-files *ZDF*'SOKO K'?ln* /home/user1/smb/Intenso/TVSendungen/45_-_Soko_Koeln 2>/dev/null
#
echo 'Soko Stuttgart'
rsync --progress --remove-source-files *ZDF*'SOKO Stuttgart'* /home/user1/smb/Intenso/TVSendungen/45_-_Soko_Stuttgart 2>/dev/null
#
echo 'Sonstige SOKOs'
rsync --progress --remove-source-files *ZDF*SOKO* /home/user1/smb/Intenso/TVSendungen/45_-_Sonstige_Sokos 2>/dev/null
#
echo 'Staatsanwalt'
rsync --progress --remove-source-files *ZDF*'Der Staatsanwalt'* /home/user1/smb/Intenso/TVSendungen/60_-_Staatsanwalt 2>/dev/null
#
echo 'Tatort'
rsync --progress --remove-source-files *'Tatort'* /home/user1/smb/Intenso/TVSendungen/90_-_Tatort 2>/dev/null
#
echo 'sonstige Kindersachen'
rsync --progress --remove-source-files *Der*kleine*Nick* /home/user1/smb/Intenso/TVSendungen_Kinder 2>/dev/null
rsync --progress --remove-source-files *Unser*Sandm* /home/user1/smb/Intenso/TVSendungen_Kinder 2>/dev/null
rsync --progress --remove-source-files *Dschungelbuch* /home/user1/smb/Intenso/TVSendungen_Kinder 2>/dev/null
rsync --progress --remove-source-files *JoNaLu* /home/user1/smb/Intenso/TVSendungen_Kinder 2>/dev/null
#
echo 'Sonstige ARD'
rsync --progress --remove-source-files *'ard'* /home/user1/smb/Intenso/TVSendungen 2>/dev/null
#
echo 'Sonstige ZDF'
rsync --progress --remove-source-files *'ZDF'* /home/user1/smb/Intenso/TVSendungen 2>/dev/null
#
echo 'alles andere'
rsync -r --progress --remove-source-files * /home/user1/smb/Intenso/Sonstiges/entpackt 2>/dev/null
#
echo '--- benenne auf dem NAS um ---'
set -e # nicht gemountetes NAS abfangen - bei Fehler beenden
cd /home/user1/smb/Intenso/TVSendungen_Kinder/Bibi_Blocksberg
rename 's/_ZDF_//' *
rename 's/Bibi Blocksberg//' *
rename 's/(_http_|_hls_)[0-9a-z\s]*(_deu)*//' *
cd /home/user1/smb/Intenso/TVSendungen_Kinder/Bibi_und_Tina
rename 's/_ZDF_//' *
rename 's/Bibi und Tina//' *
rename 's/(_http_|_hls_)[0-9a-z\s]*(_deu)*//' *
cd /home/user1/smb/Intenso/TVSendungen_Kinder/Biene_Maja
rename 's/_ZDF_//' *
rename 's/ - Die Biene Maja//' *
rename 's/Die Biene Maja - / - /' *
rename 's/(_http_|_hls_)[0-9a-z\s]*(_deu)*//' *
cd /home/user1/smb/Intenso/TVSendungen_Kinder/Conni
rename 's/_ZDF_//' *
rename 's/Meine Freundin Conni//' *
rename 's/(_http_|_hls_)[0-9a-z\s]*(_deu)*//' *
cd /home/user1/smb/Intenso/TVSendungen_Kinder/Mia_and_me
rename 's/_ZDF_//' *
rename 's/Mia and me//' *
rename 's/(_http_|_hls_)[0-9a-z\s]*(_deu)*//' *
cd /home/user1/smb/Intenso/TVSendungen_Kinder/Peter_Pan
rename 's/_ZDF_//' *
rename 's/Peter Pan//' *
rename 's/(_http_|_hls_)[0-9a-z\s]*(_deu)*//' *
cd /home/user1/smb/Intenso/TVSendungen/60_-_Der_Alte
rename 's/_ZDF_Der Alte//' *
rename 's/(_http_|_hls_)[0-9a-z\s]*(_deu)*//' *
cd /home/user1/smb/Intenso/TVSendungen/60_-_Die_Chefin
rename 's/_ZDF_Die Chefin//' *
rename 's/(_http_|_hls_)[0-9a-z\s]*(_deu)*//' *
cd /home/user1/smb/Intenso/TVSendungen/90_-_Fernsehfilm_der_Woche
rename 's/_ZDF_Der Fernsehfilm der Woche//' *
rename 's/(_http_|_hls_)[0-9a-z\s]*(_deu)*//' *
cd /home/user1/smb/Intenso/TVSendungen/60_-_Kriminalist
rename 's/_ZDF_Der Kriminalist//' *
rename 's/(_http_|_hls_)[0-9a-z\s]*(_deu)*//' *
cd /home/user1/smb/Intenso/TVSendungen/45_-_Letzte_Spur_Berlin
rename 's/_ZDF_Letzte Spur Berlin//' *
rename 's/(_http_|_hls_)[0-9a-z\s]*(_deu)*//' *
cd /home/user1/smb/Intenso/TVSendungen/90_-_Ein_starkes_Team
rename 's/_ZDF_Ein starkes Team//' *
rename 's/ - Ein starkes Team//' *
rename 's/(_http_|_hls_)[0-9a-z\s]*(_deu)*//' *
cd /home/user1/smb/Intenso/TVSendungen/90_-_Polizeiruf
rename 's/_ard_Polizeiruf 110//' *
rename 's/(_http_|_hls_)[0-9a-z\s]*(_deu)*//' *
cd /home/user1/smb/Intenso/TVSendungen/45_-_Soko_Leipzig
rename 's/_ZDF_SOKO Leipzig//' *
rename 's/(_http_|_hls_)[0-9a-z\s]*(_deu)*//' *
cd /home/user1/smb/Intenso/TVSendungen/45_-_Sonstige_Sokos
rename 's/_ZDF_/ - /' *
rename 's/(_http_|_hls_)[0-9a-z\s]*(_deu)*//' *
cd /home/user1/smb/Intenso/TVSendungen/60_-_Staatsanwalt
rename 's/_ZDF_Der Staatsanwalt//' *
rename 's/(_http_|_hls_)[0-9a-z\s]*(_deu)*//' *
cd /home/user1/smb/Intenso/TVSendungen/90_-_Tatort
rename 's/_ard_Tatort//' *
rename 's/(_http_|_hls_)[0-9a-z\s]*(_deu)*//' *
cd /home/user1/smb/Intenso/TVSendungen
rename 's/_ZDF_/ - /' *
rename 's/_ard_/ - /' *
rename 's/_ZDFneo_ZDFneo/ - /' *
rename 's/(_http_|_hls_)[0-9a-z\s]*(_deu)*//' *
cd /home/user1/smb/Intenso/TVSendungen_Kinder
rename 's/_ZDF_/ - /' *
rename 's/_ard_/ - /' *
rename 's/_ZDFneo_ZDFneo/ - /' *
rename 's/(_http_|_hls_)[0-9a-z\s]*(_deu)*//' *
#
set +e # wenn jd leer ist erzeugt rm nen Fehler, es soll aber weiter gehen...
rm -r /home/user1/downloads/*
#
cd /home/user1
bash /home/user1/tvupdate.sh &
