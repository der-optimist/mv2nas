#!/bin/bash
#
# --- Input ---
#
dir_downloads = '/srv/dev-disk-by-label-ssddata/ssddata/downloads'
dir_nas = '/srv/eaec4d04-9e72-4736-a72b-57d16e5b71b5'
dir_tvu_script = '/srv/dev-disk-by-label-ssddata/ssddata/omv_scripts/tv'
#
# -------------
#
cd ${dir_downloads}
rename 's/_daserste_/_ard_/' *
#
echo '--- schiebe aufs NAS ---'
echo '- Kinder -'
echo 'Bibi Blocksberg'
rsync --progress --remove-source-files *Bibi*Blocksberg* ${dir_nas}/TVSendungen_Kinder/Bibi_Blocksberg 2>/dev/null
#
echo 'Bibi und Tina'
rsync --progress --remove-source-files *Bibi*und*Tina* ${dir_nas}/TVSendungen_Kinder/Bibi_und_Tina 2>/dev/null
#
echo 'Biene Maja'
rsync --progress --remove-source-files *Biene*Maja* ${dir_nas}/TVSendungen_Kinder/Biene_Maja 2>/dev/null
#
echo 'Conni'
rsync --progress --remove-source-files *Meine*Freundin*Conni* ${dir_nas}/TVSendungen_Kinder/Conni 2>/dev/null
#
echo 'Mia and me'
rsync --progress --remove-source-files *Mia*and*me* ${dir_nas}/TVSendungen_Kinder/Mia_and_me 2>/dev/null
#
echo 'Peter Pan'
rsync --progress --remove-source-files *Peter*Pan* ${dir_nas}/TVSendungen_Kinder/Peter_Pan 2>/dev/null
#
echo '- Eltern -'
echo 'Der Alte'
rsync --progress --remove-source-files *ZDF*'Der Alte'* ${dir_nas}/TVSendungen/60_-_Der_Alte 2>/dev/null
#
echo 'Die Chefin'
rsync --progress --remove-source-files *ZDF*'Die Chefin'* ${dir_nas}/TVSendungen/60_-_Die_Chefin 2>/dev/null
#
echo 'Die Spezialisten'
rsync --progress --remove-source-files *ZDF*'Die Spezialisten'* ${dir_nas}/TVSendungen/45_-_Die_Spezialisten 2>/dev/null
#
echo 'Fernsehfilm der Woche'
rsync --progress --remove-source-files *ZDF*'Fernsehfilm der Woche'* ${dir_nas}/TVSendungen/90_-_Fernsehfilm_der_Woche 2>/dev/null
#
echo 'Der Kriminalist'
rsync --progress --remove-source-files *ZDF*'Kriminalist'* ${dir_nas}/TVSendungen/60_-_Kriminalist 2>/dev/null
#
echo 'Letzte Spur Berlin'
rsync --progress --remove-source-files *ZDF*'Letzte Spur Berlin'* ${dir_nas}/TVSendungen/45_-_Letzte_Spur_Berlin 2>/dev/null
#
echo 'Ein starkes Team'
rsync --progress --remove-source-files *ZDF*starkes*Team* ${dir_nas}/TVSendungen/90_-_Ein_starkes_Team 2>/dev/null
#
echo 'Polizeiruf'
rsync --progress --remove-source-files *'Polizeiruf'* ${dir_nas}/TVSendungen/90_-_Polizeiruf 2>/dev/null
#
echo 'Soko Leipzig'
rsync --progress --remove-source-files *ZDF*'SOKO Leipzig'* ${dir_nas}/TVSendungen/45_-_Soko_Leipzig 2>/dev/null
#
echo 'Soko Koeln'
rsync --progress --remove-source-files *ZDF*'SOKO Köln'* ${dir_nas}/TVSendungen/45_-_Soko_Köln 2>/dev/null
#
echo 'Soko Stuttgart'
rsync --progress --remove-source-files *ZDF*'SOKO Stuttgart'* ${dir_nas}/TVSendungen/45_-_Soko_Stuttgart 2>/dev/null
#
echo 'Sonstige SOKOs'
rsync --progress --remove-source-files *ZDF*SOKO* ${dir_nas}/TVSendungen/45_-_Sonstige_Sokos 2>/dev/null
#
echo 'Staatsanwalt'
rsync --progress --remove-source-files *ZDF*'Der Staatsanwalt'* ${dir_nas}/TVSendungen/60_-_Staatsanwalt 2>/dev/null
#
echo 'Tatort'
rsync --progress --remove-source-files *'Tatort'* ${dir_nas}/TVSendungen/90_-_Tatort 2>/dev/null
#
echo 'sonstige Kindersachen'
rsync --progress --remove-source-files *Der*kleine*Nick* ${dir_nas}/TVSendungen_Kinder 2>/dev/null
rsync --progress --remove-source-files *Unser*Sandm* ${dir_nas}/TVSendungen_Kinder 2>/dev/null
rsync --progress --remove-source-files *Dschungelbuch* ${dir_nas}/TVSendungen_Kinder 2>/dev/null
rsync --progress --remove-source-files *JoNaLu* ${dir_nas}/TVSendungen_Kinder 2>/dev/null
#
echo 'Sonstige ARD'
rsync --progress --remove-source-files *'ard'* ${dir_nas}/TVSendungen 2>/dev/null
#
echo 'Sonstige ZDF'
rsync --progress --remove-source-files *'ZDF'* ${dir_nas}/TVSendungen 2>/dev/null
#
echo '--- benenne auf dem NAS um ---'
set -e # nicht gemountetes NAS abfangen - bei Fehler beenden
cd ${dir_nas}/TVSendungen_Kinder/Bibi_Blocksberg
rename 's/_ZDF_//' *
rename 's/Bibi Blocksberg//' *
rename 's/(_http_|_hls_)[0-9a-z\s]*(_deu)*//' *
cd ${dir_nas}/TVSendungen_Kinder/Bibi_und_Tina
rename 's/_ZDF_//' *
rename 's/Bibi und Tina//' *
rename 's/(_http_|_hls_)[0-9a-z\s]*(_deu)*//' *
cd ${dir_nas}/TVSendungen_Kinder/Biene_Maja
rename 's/_ZDF_//' *
rename 's/ - Die Biene Maja//' *
rename 's/Die Biene Maja - / - /' *
rename 's/(_http_|_hls_)[0-9a-z\s]*(_deu)*//' *
cd ${dir_nas}/TVSendungen_Kinder/Conni
rename 's/_ZDF_//' *
rename 's/Meine Freundin Conni//' *
rename 's/(_http_|_hls_)[0-9a-z\s]*(_deu)*//' *
cd ${dir_nas}/TVSendungen_Kinder/Mia_and_me
rename 's/_ZDF_//' *
rename 's/Mia and me//' *
rename 's/(_http_|_hls_)[0-9a-z\s]*(_deu)*//' *
cd ${dir_nas}/TVSendungen_Kinder/Peter_Pan
rename 's/_ZDF_//' *
rename 's/Peter Pan//' *
rename 's/(_http_|_hls_)[0-9a-z\s]*(_deu)*//' *
cd ${dir_nas}/TVSendungen/60_-_Der_Alte
rename 's/_ZDF_Der Alte//' *
rename 's/(_http_|_hls_)[0-9a-z\s]*(_deu)*//' *
cd ${dir_nas}/TVSendungen/60_-_Die_Chefin
rename 's/_ZDF_Die Chefin//' *
rename 's/(_http_|_hls_)[0-9a-z\s]*(_deu)*//' *
cd ${dir_nas}/TVSendungen/90_-_Fernsehfilm_der_Woche
rename 's/_ZDF_Der Fernsehfilm der Woche//' *
rename 's/(_http_|_hls_)[0-9a-z\s]*(_deu)*//' *
cd ${dir_nas}/TVSendungen/60_-_Kriminalist
rename 's/_ZDF_Der Kriminalist//' *
rename 's/(_http_|_hls_)[0-9a-z\s]*(_deu)*//' *
cd ${dir_nas}/TVSendungen/45_-_Letzte_Spur_Berlin
rename 's/_ZDF_Letzte Spur Berlin//' *
rename 's/(_http_|_hls_)[0-9a-z\s]*(_deu)*//' *
cd ${dir_nas}/TVSendungen/90_-_Ein_starkes_Team
rename 's/_ZDF_Ein starkes Team//' *
rename 's/ - Ein starkes Team//' *
rename 's/(_http_|_hls_)[0-9a-z\s]*(_deu)*//' *
cd ${dir_nas}/TVSendungen/90_-_Polizeiruf
rename 's/_ard_Polizeiruf 110//' *
rename 's/(_http_|_hls_)[0-9a-z\s]*(_deu)*//' *
cd ${dir_nas}/TVSendungen/45_-_Soko_Leipzig
rename 's/_ZDF_SOKO Leipzig//' *
rename 's/(_http_|_hls_)[0-9a-z\s]*(_deu)*//' *
cd ${dir_nas}/TVSendungen/45_-_Soko_Stuttgart
rename 's/_ZDF_SOKO Stuttgart//' *
rename 's/ - SOKO Stuttgart//' *
rename 's/(_http_|_hls_)[0-9a-z\s]*(_deu)*//' *
cd ${dir_nas}/TVSendungen/45_-_Soko_Köln
rename 's/_ZDF_SOKO Köln//' *
rename 's/ - SOKO Köln//' *
rename 's/(_http_|_hls_)[0-9a-z\s]*(_deu)*//' *
cd ${dir_nas}/TVSendungen/45_-_Sonstige_Sokos
rename 's/_ZDF_/ - /' *
rename 's/(_http_|_hls_)[0-9a-z\s]*(_deu)*//' *
cd ${dir_nas}/TVSendungen/60_-_Staatsanwalt
rename 's/_ZDF_Der Staatsanwalt//' *
rename 's/(_http_|_hls_)[0-9a-z\s]*(_deu)*//' *
cd ${dir_nas}/TVSendungen/90_-_Tatort
rename 's/_ard_Tatort//' *
rename 's/(_http_|_hls_)[0-9a-z\s]*(_deu)*//' *
cd ${dir_nas}/TVSendungen
rename 's/_ZDF_/ - /' *
rename 's/_ard_/ - /' *
rename 's/_ZDFneo_ZDFneo/ - /' *
rename 's/(_http_|_hls_)[0-9a-z\s]*(_deu)*//' *
cd ${dir_nas}/TVSendungen_Kinder
rename 's/_ZDF_/ - /' *
rename 's/_ard_/ - /' *
rename 's/_ZDFneo_ZDFneo/ - /' *
rename 's/(_http_|_hls_)[0-9a-z\s]*(_deu)*//' *
#
cd ${dir_tvu_script}
/bin/bash ${dir_tvu_script}/tvupdate.sh &
