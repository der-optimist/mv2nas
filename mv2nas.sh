#!/bin/bash
# move downloaded files to specific folders on the NAS
# and rename them
#
# --- Input ---
#
dir_downloads='/srv/dev-disk-by-label-ssddata/ssddata/downloads'
dir_nas_media='/srv/eaec4d04-9e72-4736-a72b-57d16e5b71b5'
dir_tvu_script='/srv/dev-disk-by-label-ssddata/ssddata/omv_scripts/tv'
#
# -------------
#
cd ${dir_downloads}
#rename 's/_daserste_/_ard_/' *
#rename 's/_KI.KA_/_ZDF_/' *
# remove doublicates in name:
rename 's/(^.{10}_[^_]+_)(.+)(\s\-\s)\2(.+)/$1$2$4/' *
# remove special chars:
rename 's/&/und/' *
rename 's/:/ /' *
rename 's/;/ /' *
#
echo '--- schiebe aufs NAS ---'
echo '- Kinder -'
echo 'Bibi Blocksberg'
rsync --progress --remove-source-files *Bibi*Blocksberg* ${dir_nas_media}/TVSendungen_Kinder/Bibi_Blocksberg 2>/dev/null
#
echo 'Bibi und Tina'
rsync --progress --remove-source-files *Bibi*und*Tina* ${dir_nas_media}/TVSendungen_Kinder/Bibi_und_Tina 2>/dev/null
#
echo 'Biene Maja'
rsync --progress --remove-source-files *Biene*Maja* ${dir_nas_media}/TVSendungen_Kinder/Biene_Maja 2>/dev/null
#
echo 'Conni'
rsync --progress --remove-source-files *Meine*Freundin*Conni* ${dir_nas_media}/TVSendungen_Kinder/Conni 2>/dev/null
#
echo 'Lieselotte'
rsync --progress --remove-source-files *Lieselotte* ${dir_nas_media}/TVSendungen_Kinder/Lieselotte 2>/dev/null
#
echo 'Mia and me'
rsync --progress --remove-source-files *Mia*and*me* ${dir_nas_media}/TVSendungen_Kinder/Mia_and_me 2>/dev/null
#
echo 'Peter Pan'
rsync --progress --remove-source-files *Peter*Pan* ${dir_nas_media}/TVSendungen_Kinder/Peter_Pan 2>/dev/null
#
echo 'Zacki Zoobande'
rsync --progress --remove-source-files *Zacki*Zoobande* ${dir_nas_media}/TVSendungen_Kinder/Zacki_Zoobande 2>/dev/null
#
echo '- Eltern -'
echo 'Der Alte'
rsync --progress --remove-source-files *'Der Alte'* ${dir_nas_media}/TVSendungen/60_-_Der_Alte 2>/dev/null
#
echo 'Die Chefin'
rsync --progress --remove-source-files *'Die Chefin'* ${dir_nas_media}/TVSendungen/60_-_Die_Chefin 2>/dev/null
#
echo 'Die Spezialisten'
rsync --progress --remove-source-files *'Die Spezialisten'* ${dir_nas_media}/TVSendungen/45_-_Die_Spezialisten 2>/dev/null
#
echo 'Fernsehfilm der Woche'
rsync --progress --remove-source-files *'Fernsehfilm der Woche'* ${dir_nas_media}/TVSendungen/90_-_Fernsehfilm_der_Woche 2>/dev/null
#
echo 'Dengler'
rsync --progress --remove-source-files *'Dengler'* ${dir_nas_media}/TVSendungen/90_-_Dengler 2>/dev/null
#
echo 'Die Toten vom Bodensee'
rsync --progress --remove-source-files *'Dengler'* ${dir_nas_media}/TVSendungen/90_-_Die_Toten_vom_Bodensee 2>/dev/null
#
echo 'Der Kriminalist'
rsync --progress --remove-source-files *'Kriminalist'* ${dir_nas_media}/TVSendungen/60_-_Kriminalist 2>/dev/null
#
echo 'Letzte Spur Berlin'
rsync --progress --remove-source-files *'Letzte Spur Berlin'* ${dir_nas_media}/TVSendungen/45_-_Letzte_Spur_Berlin 2>/dev/null
#
echo 'Ein starkes Team'
rsync --progress --remove-source-files *starkes*Team* ${dir_nas_media}/TVSendungen/90_-_Ein_starkes_Team 2>/dev/null
#
echo 'Polizeiruf'
rsync --progress --remove-source-files *'Polizeiruf'* ${dir_nas_media}/TVSendungen/90_-_Polizeiruf 2>/dev/null
#
echo 'Soko Leipzig'
rsync --progress --remove-source-files *'SOKO Leipzig'* ${dir_nas_media}/TVSendungen/45_-_Soko_Leipzig 2>/dev/null
#
echo 'Soko Köln'
rsync --progress --remove-source-files *'SOKO Köln'* ${dir_nas_media}/TVSendungen/45_-_Soko_Köln 2>/dev/null
#
echo 'Soko Stuttgart'
rsync --progress --remove-source-files *'SOKO Stuttgart'* ${dir_nas_media}/TVSendungen/45_-_Soko_Stuttgart 2>/dev/null
#
echo 'Sonstige SOKOs'
rsync --progress --remove-source-files *SOKO* ${dir_nas_media}/TVSendungen/45_-_Sonstige_Sokos 2>/dev/null
#
echo 'Staatsanwalt'
rsync --progress --remove-source-files *'Der Staatsanwalt'* ${dir_nas_media}/TVSendungen/60_-_Staatsanwalt 2>/dev/null
#
echo 'Tatort'
rsync --progress --remove-source-files *'Tatort'* ${dir_nas_media}/TVSendungen/90_-_Tatort 2>/dev/null
#
echo 'sonstige Kindersachen'
rsync --progress --remove-source-files *Der*kleine*Nick* ${dir_nas_media}/TVSendungen_Kinder 2>/dev/null
rsync --progress --remove-source-files *Unser*Sandm* ${dir_nas_media}/TVSendungen_Kinder 2>/dev/null
rsync --progress --remove-source-files *Dschungelbuch* ${dir_nas_media}/TVSendungen_Kinder 2>/dev/null
rsync --progress --remove-source-files *JoNaLu* ${dir_nas_media}/TVSendungen_Kinder 2>/dev/null
rsync --progress --remove-source-files *Leopard*Seeb*Co* ${dir_nas_media}/TVSendungen_Kinder 2>/dev/null
#
#echo 'Sonstige mp4'
rsync --progress --remove-source-files *.mp4 ${dir_nas_media}/TVSendungen 2>/dev/null
#
echo '--- benenne auf dem NAS um ---'
set -e # nicht gemountetes NAS abfangen - bei Fehler beenden
cd ${dir_nas_media}/TVSendungen_Kinder/Bibi_Blocksberg
#rename 's/_ZDF_//' *
rename 's/Bibi Blocksberg//' *
#rename 's/(_http_|_hls_)[0-9a-z\s]*(_deu)*//' *
#rename 's/(_TV_Ton)//' *
cd ${dir_nas_media}/TVSendungen_Kinder/Bibi_und_Tina
#rename 's/_ZDF_//' *
rename 's/Bibi und Tina//' *
#rename 's/(_http_|_hls_)[0-9a-z\s]*(_deu)*//' *
#rename 's/(_TV_Ton)//' *
cd ${dir_nas_media}/TVSendungen_Kinder/Biene_Maja
#rename 's/_ZDF_//' *
rename 's/ - Die Biene Maja//' *
rename 's/Die Biene Maja - / - /' *
#rename 's/(_http_|_hls_)[0-9a-z\s]*(_deu)*//' *
#rename 's/(_TV_Ton)//' *
cd ${dir_nas_media}/TVSendungen_Kinder/Conni
#rename 's/_ZDF_//' *
rename 's/Meine Freundin Conni//' *
#rename 's/(_http_|_hls_)[0-9a-z\s]*(_deu)*//' *
#rename 's/(_TV_Ton)//' *
cd ${dir_nas_media}/TVSendungen_Kinder/Lieselotte
#rename 's/_ZDF_//' *
rename 's/Lieselotte//' *
#rename 's/(_http_|_hls_)[0-9a-z\s]*(_deu)*//' *
#rename 's/(_TV_Ton)//' *
cd ${dir_nas_media}/TVSendungen_Kinder/Mia_and_me
#rename 's/_ZDF_//' *
rename 's/Mia and me//' *
#rename 's/(_http_|_hls_)[0-9a-z\s]*(_deu)*//' *
#rename 's/(_TV_Ton)//' *
cd ${dir_nas_media}/TVSendungen_Kinder/Peter_Pan
#rename 's/_ZDF_//' *
rename 's/Peter Pan//' *
#rename 's/(_http_|_hls_)[0-9a-z\s]*(_deu)*//' *
#rename 's/(_TV_Ton)//' *
cd ${dir_nas_media}/TVSendungen_Kinder/Zacki_Zoobande
#rename 's/_ZDF_//' *
rename 's/Zacki und die Zoobande//' *
#rename 's/(_http_|_hls_)[0-9a-z\s]*(_deu)*//' *
#rename 's/(_TV_Ton)//' *
cd ${dir_nas_media}/TVSendungen/60_-_Der_Alte
rename 's/_Der Alte//' *
#rename 's/(_http_|_hls_)[0-9a-z\s]*(_deu)*//' *
#rename 's/(_TV_Ton)//' *
cd ${dir_nas_media}/TVSendungen/60_-_Die_Chefin
rename 's/_Die Chefin//' *
#rename 's/(_http_|_hls_)[0-9a-z\s]*(_deu)*//' *
#rename 's/(_TV_Ton)//' *
cd ${dir_nas_media}/TVSendungen/90_-_Fernsehfilm_der_Woche
rename 's/_Der Fernsehfilm der Woche//' *
#rename 's/(_http_|_hls_)[0-9a-z\s]*(_deu)*//' *
#rename 's/(_TV_Ton)//' *
cd ${dir_nas_media}/TVSendungen/90_-_Dengler
rename 's/_Dengler//' *
#rename 's/(_http_|_hls_)[0-9a-z\s]*(_deu)*//' *
#rename 's/(_TV_Ton)//' *
cd ${dir_nas_media}/TVSendungen/90_-_Die_Toten_vom_Bodensee
rename 's/_Die Toten vom Bodensee//' *
#rename 's/(_http_|_hls_)[0-9a-z\s]*(_deu)*//' *
#rename 's/(_TV_Ton)//' *
cd ${dir_nas_media}/TVSendungen/60_-_Kriminalist
rename 's/_Der Kriminalist//' *
#rename 's/(_http_|_hls_)[0-9a-z\s]*(_deu)*//' *
#rename 's/(_TV_Ton)//' *
cd ${dir_nas_media}/TVSendungen/45_-_Letzte_Spur_Berlin
rename 's/_Letzte Spur Berlin//' *
#rename 's/(_http_|_hls_)[0-9a-z\s]*(_deu)*//' *
#rename 's/(_TV_Ton)//' *
cd ${dir_nas_media}/TVSendungen/90_-_Ein_starkes_Team
rename 's/_Ein starkes Team//' *
rename 's/ - Ein starkes Team//' *
#rename 's/(_http_|_hls_)[0-9a-z\s]*(_deu)*//' *
#rename 's/(_TV_Ton)//' *
cd ${dir_nas_media}/TVSendungen/90_-_Polizeiruf
rename 's/_Polizeiruf 110//' *
#rename 's/(_http_|_hls_)[0-9a-z\s]*(_deu)*//' *
#rename 's/(_TV_Ton)//' *
cd ${dir_nas_media}/TVSendungen/45_-_Soko_Leipzig
rename 's/_SOKO Leipzig//' *
#rename 's/(_http_|_hls_)[0-9a-z\s]*(_deu)*//' *
#rename 's/(_TV_Ton)//' *
cd ${dir_nas_media}/TVSendungen/45_-_Soko_Stuttgart
rename 's/_SOKO Stuttgart//' *
rename 's/ - SOKO Stuttgart//' *
#rename 's/(_http_|_hls_)[0-9a-z\s]*(_deu)*//' *
#rename 's/(_TV_Ton)//' *
cd ${dir_nas_media}/TVSendungen/45_-_Soko_Köln
rename 's/_SOKO Köln//' *
rename 's/ - SOKO Köln//' *
#rename 's/(_http_|_hls_)[0-9a-z\s]*(_deu)*//' *
#rename 's/(_TV_Ton)//' *
#cd ${dir_nas_media}/TVSendungen/45_-_Sonstige_Sokos
#rename 's/_ZDF_/ - /' *
#rename 's/(_http_|_hls_)[0-9a-z\s]*(_deu)*//' *
#rename 's/(_TV_Ton)//' *
cd ${dir_nas_media}/TVSendungen/60_-_Staatsanwalt
rename 's/_Der Staatsanwalt//' *
#rename 's/(_http_|_hls_)[0-9a-z\s]*(_deu)*//' *
#rename 's/(_TV_Ton)//' *
cd ${dir_nas_media}/TVSendungen/90_-_Tatort
rename 's/_Tatort//' *
#rename 's/(_http_|_hls_)[0-9a-z\s]*(_deu)*//' *
#rename 's/(_TV_Ton)//' *
cd ${dir_nas_media}/TVSendungen
#rename 's/_ZDF_/ - /' *
#rename 's/_ard_/ - /' *
#rename 's/_ZDFneo_ZDFneo/ - /' *
#rename 's/_ZDFneo_/ - /' *
#rename 's/(_http_|_hls_)[0-9a-z\s]*(_deu)*//' *
#rename 's/(_TV_Ton)//' *
rename 's/_/ - /' *.mp4
cd ${dir_nas_media}/TVSendungen_Kinder
#rename 's/_ZDF_/ - /' *
#rename 's/_ard_/ - /' *
#rename 's/_ZDFneo_ZDFneo/ - /' *
#rename 's/_ZDFneo_/ - /' *
#rename 's/(_http_|_hls_)[0-9a-z\s]*(_deu)*//' *
#rename 's/(_TV_Ton)//' *
rename 's/_/ - /' *.mp4
#
cd ${dir_tvu_script}
/bin/bash ${dir_tvu_script}/tvupdate.sh &
