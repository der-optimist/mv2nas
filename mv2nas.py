import os
from subprocess import check_output

# Input
dir_downloads = '/srv/dev-disk-by-id-ata-ST6000DM003-2CY186_WF208FWA-part1/hdddata/downloads'
dir_nas_media = '/srv/5fda0d53-e782-4f16-9775-20a361ff6e15' # remember: could also be user:pw@host without mounting as rsync is used below. should adapt rsync command then of course
path_tvu_script = '/srv/dev-disk-by-uuid-6416d6e7-a248-4554-9d15-d5643a6b8a67/ssddata/omv_scripts/tv/tvupdate.sh'
filetype = '.mp4'
dir_jo = '/srv/dev-disk-by-uuid-6416d6e7-a248-4554-9d15-d5643a6b8a67/ssddata/jo'
search_strings_jo = ["heute-show",
                     "Wismar",
                     "Die Anstalt",
                     "Frontal 21",
                     "Magazin Royale",
                     "History"]
search_strings_and_target_folders = [["Bibi Blocksberg", "TVSendungen_Kinder/Bibi_Blocksberg"],
                                     ["Bibi und Tina", "TVSendungen_Kinder/Bibi_und_Tina"],
                                     ["Die Biene Maja", "TVSendungen_Kinder/Biene_Maja"],
                                     ["Die Sendung mit der Maus", "TVSendungen_Kinder/Die_Maus"],
                                     ["Löwenzähnchen", "TVSendungen_Kinder/Löwenzähnchen"],
                                     ["Löwenzahn", "TVSendungen_Kinder/Löwenzahn"],
                                     ["Meine Freundin Conni", "TVSendungen_Kinder/Conni"],
                                     ["Lieselotte", "TVSendungen_Kinder/Lieselotte"],
                                     ["Lassie", "TVSendungen_Kinder/Lassie"],
                                     ["Mia and me", "TVSendungen_Kinder/Mia_and_me"],
                                     ["Mascha und der Bär", "TVSendungen_Kinder/Mascha_und_der_Bär"],
                                     ["Mama Fuchs und Papa Dachs", "TVSendungen_Kinder/Mama_Fuchs_und_Papa_Dachs"],
                                     ["Mumintal", "TVSendungen_Kinder/Mumintal"],
                                     ["Peter Pan", "TVSendungen_Kinder/Peter_Pan"],
                                     ["Zacki und die Zoobande", "TVSendungen_Kinder/Zacki_Zoobande"],
                                     ["Der kleine Nick", "TVSendungen_Kinder"],
                                     ["Der kleine Rabe Socke", "TVSendungen_Kinder/Rabe_Socke"],
                                     ["Unser Sandmännchen", "TVSendungen_Kinder"],
                                     ["Dschungelbuch", "TVSendungen_Kinder"],
                                     ["JoNaLu", "TVSendungen_Kinder"],
                                     ["Paula und die wilden Tiere", "TVSendungen_Kinder/Paula_und_die_wilden_Tiere"],
                                     ["Anna, Paula, Pia und die wilden Tiere _ wilde Natur", "TVSendungen_Kinder/Paula_und_die_wilden_Tiere_-_Kurze"],
                                     ["Paula und ihre wilde Welt", "TVSendungen_Kinder/Paula_und_ihre_wilde_Welt"],
                                     ["Anna, Pia, Paula und ihre wilde Welt", "TVSendungen_Kinder/Paula_und_ihre_wilde_Welt"],
                                     ["Anna, Pia und die Haustiere", "TVSendungen_Kinder/Paula_und_die_Haustiere"],
                                     ["Leopard Seebär und Co", "TVSendungen_Kinder/Leopard_Seebär_und_Co"],
                                     ["Giraffe Erdmännchen und Co", "TVSendungen_Kinder/Erdmännchen_Giraffe_und_Co"],
                                     ["Elefant, Tiger & Co", "TVSendungen_Kinder/Zoo_Leipzig"],
                                     ["Welt unter Strom", "TVSendungen_Kinder/Welt_unter_Strom"],
                                     ["Arne Dahl", "TVSendungen/110_-_Arne_Dahl"],
                                     ["Der Pass", "TVSendungen/50_-_Der_Pass"],
                                     ["Der Alte", "TVSendungen/60_-_Der_Alte"],
                                     ["Die Chefin", "TVSendungen/60_-_Die_Chefin"],
                                     ["Der Fernsehfilm der Woche", "TVSendungen/90_-_Fernsehfilm_der_Woche"],
                                     ["Dengler", "TVSendungen/90_-_Dengler"],
                                     ["Die Toten vom Bodensee", "TVSendungen/90_-_Die_Toten_vom_Bodensee"],
                                     ["Letzte Spur Berlin", "TVSendungen/45_-_Letzte_Spur_Berlin"],
                                     ["Ein starkes Team", "TVSendungen/90_-_Ein_starkes_Team"],
                                     ["München Mord", "TVSendungen/90_-_München_Mord"],
                                     ["Rechtsanwalt Vernau", "TVSendungen/90_-_Rechtsanwalt_Vernau"],
                                     ["Polizeiruf 110", "TVSendungen/90_-_Polizeiruf"],
                                     ["Neben der Spur", "TVSendungen/90_-_Neben_der_Spur"],
                                     ["Mord im Mittsommer", "TVSendungen/90_-_Mord_im_Mittsommer"],
                                     ["Sarah Kohr", "TVSendungen/90_-_Sarah_Kohr"],
                                     ["Unter anderen Umständen", "TVSendungen/90_-_Unter_anderen_Umständen"],
                                     ["Die Toten von Salzburg", "TVSendungen/90_-_Die_Toten_von_Salzburg"],
                                     ["Die Toten von Marnow", "TVSendungen/45_-_Die_Toten_von_Marnow"],
                                     ["Der Samstagskrimi", "TVSendungen/90_-_Sonstige_Samstagskrimis"],
                                     ["SOKO Leipzig", "TVSendungen/45_-_Soko_Leipzig"],
                                     ["SOKO Stuttgart", "TVSendungen/45_-_Soko_Stuttgart"],
                                     ["SOKO Köln", "TVSendungen/45_-_Soko_Köln"],
                                     ["Der Staatsanwalt", "TVSendungen/60_-_Staatsanwalt"],
                                     ["Ein Fall für zwei", "TVSendungen/60_-_Ein_Fall_für_zwei"],
                                     ["Tatort", "TVSendungen/90_-_Tatort"],
                                     ["The Mallorca Files", "TVSendungen/45_-_Mallorca_Files"],
                                     ["Filme - Nord bei Nordwest", "TVSendungen/90_-_Nord_bei_Nordwest"],
                                     ["Film im rbb - Nord bei Nordwest", "TVSendungen/90_-_Nord_bei_Nordwest"],
                                     ["Krimis im Ersten - Nord bei Nordwest", "TVSendungen/90_-_Nord_bei_Nordwest"],
                                     ["Krimis im Ersten - Der Kroatien-Krimi", "TVSendungen/90_-_KiE_Kroatien-Krimi"],
                                     ["Krimis im Ersten - Der Bozen-Krimi", "TVSendungen/90_-_KiE_Bozen-Krimi"],
                                     ["Krimis im Ersten - Der Island-Krimi", "TVSendungen/90_-_KiE_Island-Krimi"],
                                     ["Krimis im Ersten - Der Masuren-Krimi", "TVSendungen/90_-_KiE_Masuren-Krimi"],
                                     ["Krimis im Ersten - Der Lissabon-Krimi", "TVSendungen/90_-_KiE_Lissabon-Krimi"],
                                     ["Krimis im Ersten - Der Amsterdam-Krimi", "TVSendungen/90_-_KiE_Amsterdam-Krimi"],
                                     ["Der Usedom-Krimi", "TVSendungen/90_-_KiE_Usedom-Krimi"],
                                     ["Usedom-Krimi", "TVSendungen/90_-_KiE_Usedom-Krimi"],
                                     ["Krimis im Ersten - Wolfsland", "TVSendungen/90_-_KiE_Wolfsland"],
                                     ["Krimis im Ersten - Kommissar Dupin", "TVSendungen/90_-_KiE_Kommissar_Dupin"],
                                     ["Krimis im Ersten - Der Zürich-Krimi", "TVSendungen/90_-_KiE_Zürich-Krimi"],
                                     ["Krimis im Ersten - Der Irland-Krimi", "TVSendungen/90_-_KiE_Irland-Krimi"],
                                     ["Krimis im Ersten - Die Bestatterin", "TVSendungen/90_-_KiE_Die_Bestatterin"],
                                     ["Krimis im Ersten - Die Füchsin", "TVSendungen/90_-_KiE_Die_Füchsin"],
                                     ["Krimis im Ersten - Kommissar Wisting", "TVSendungen/90_-_KiE_Kommissar_Wisting"],
                                     ["Nord bei Nordwest", "TVSendungen/90_-_Nord_bei_Nordwest"],
                                     ["Die Heiland - Wir sind Anwalt", "TVSendungen/45_-_Die_Heiland"],
                                     ["Kanzlei Berger", "TVSendungen/45_-_Kanzlei_Berger"],
                                     ["Unbroken", "TVSendungen/45_-_Unbroken"],
                                     ["Im Netz der Camorra", "TVSendungen/45_-_Im_Netz_der_Camorra"],
                                     ["West of Liberty", "TVSendungen/45_-_West_of_Liberty"],
                                     ["Camilla Läckberg - Camilla Läckberg_ Mord in Fjällbacka", "TVSendungen/90_-_Camilla_Läckberg"],
                                     ["Arctic Circle - Der unsichtbare Tod", "TVSendungen/45_-_Arctic_Circle_-_Der_unsichtbare_Tod"],
                                     ["Bodyguard", "TVSendungen/110_-_Bodyguard"],
                                     ["Spielfilm-Highlights", "TVSendungen/90_-_Spielfilm-Highlights"],
                                     ["Tod von Freunden", "TVSendungen/60_-_Tod_von_Freunden"],
                                     ["Der Überläufer", "TVSendungen/45_-_Der_Überläufer"],
                                     ["Pure", "TVSendungen/30_-_Pure"],
                                     ["BOX 21", "TVSendungen/45_-_BOX_21"],
                                     ["Furia", "TVSendungen/45_-_Furia"],
                                     ["WESTWALL", "TVSendungen/45_-_Westwall"],
                                     ["The Killing", "TVSendungen/60_-_The_Killing"],
                                     ["Alex Rider", "TVSendungen/40_-_Alex_Rider"],
                                     ["Fernsehfilme und Serien - Serien - Occupied - Die Besatzung", "TVSendungen/45_Occupied_-_Die_Besatzung"],
                                     ["Fernsehfilme und Serien - Serien - Borgen - Gefährliche Seilschaften", "TVSendungen/60_Borgen_-_Gefährliche_Seilschaften"],
                                     ["Fernsehfilme und Serien - Serien - Clan", "TVSendungen/50_Clan_-_Krimikomödie"],
                                     ["Aus der Spur", "TVSendungen/50_-_Aus_der_Spur"],
                                     ["Hamilton - Undercover in Stockholm", "TVSendungen/45_-_Hamilton_-_Undercover_in_Stockholm"],
                                     ["Mord in der Familie - Der Zauberwürfel", "TVSendungen/45_-_Mord_in_der_Familie_-_Der_Zauberwürfel"],
                                     ["Schneller als die Angst", "TVSendungen/45_-_Schneller_als_die_Angst"],
                                     ["The Bay", "TVSendungen/45_-_The_Bay"],
                                     ["They Were Ten", "TVSendungen/45_-_They_Were_Ten"],
                                     ["Schwarzer Schatten - Serienmord im Krankenhaus", "TVSendungen/50_-_Schwarzer_Schatten_-_Serienmord_im_Krankenhaus"],
                                     ["Schatten der Mörder - Shadowplay", "TVSendungen/60_-_Schatten_der_Mörder"]]

# Code

def get_files(folder, filetype):
    list_filenames = []
    list_dir = os.listdir(folder)
    for file in list_dir:
        if file.endswith(filetype):
            list_filenames.append(file)
    return list_filenames

def clean_filename(filename):
    # replace special chars in file name
    filename = filename.replace("&","und")
    filename = filename.replace(";","")
    filename = filename.replace(":","")
    filename = filename.replace(",","")
    filename = filename.replace("–","-")
    filename = filename.replace("<", "")
    filename = filename.replace(">", "")
    filename = filename.replace("!", "")
    filename = filename.replace("?", "")
    filename = filename.replace("*", "")
    filename = filename.replace("[", "(")
    filename = filename.replace("]", ")")
    filename = filename.replace("{", "(")
    filename = filename.replace("}", ")")
    return filename
  
for filename_origin in get_files(dir_downloads,filetype):
    source_filepath = dir_downloads + "/" + filename_origin
    filename = filename_origin
    
    # Remove Douplicates in Filename
    filename_split = filename.split(" - ")
    try:
        if (filename_split[1] + " - " + filename_split[2]) in (filename_split[3] + " - " + filename_split[4]):
            #example: 2020-12-12 - Schatten - Shadow - Schatten - Shadow (1).mp4
            filename = filename_split[0]
            for i in range(3,len(filename_split)):
                filename = filename + " - " + filename_split[i]
        if filename_split[1] in filename_split[2]:
            #example: 2020-12-12 - Schatten - Schatten - Folge (1).mp4
            filename = filename_split[0]
            for i in range(2,len(filename_split)):
                filename = filename + " - " + filename_split[i]
    except Exception as e:
        pass
    
    # replace special chars in file name
    filename = clean_filename(filename)
    
    # show what you have done...
    print(filename)
    
    # check if it contains a "jo" searchstring
    is_jo = False
    for searchstring in search_strings_jo:
        if clean_filename(searchstring) in filename:
            print("Schiebe es zu Jo aufgrund: {}")
            target_foder = dir_jo + "/"
            target_filepath = dir_jo + "/" + filename
            is_jo = True
            break
    if is_jo:
        # rename the file
        source_filepath_renamed = dir_downloads + "/" + filename
        if source_filepath_renamed != source_filepath:
            os.rename(source_filepath,source_filepath_renamed)
        
        mv_command = "mv " + source_filepath_renamed.replace(" ", "\\ ").replace("(", "\\(").replace(")", "\\)") + " " + target_foder + " 2>/dev/null"
        check_output(mv_command,shell=True)
        continue
    
    # check if it contains a searchstring - so it would get a special target folder
    for searchstring in search_strings_and_target_folders:
        if (" - " + clean_filename(searchstring[0])) in filename:
            # Cut out that part, as it is already part of the folder name.
            filename = filename.replace((" - " + clean_filename(searchstring[0])),"")
            print("Sortiere es ein unter: {}".format(searchstring[0]))
            target_foder = dir_nas_media + "/" + searchstring[1] + "/"
            target_filepath = dir_nas_media + "/" + searchstring[1] + "/" + filename
            break
        else:
            target_foder = dir_nas_media + "/" + "TVSendungen" + "/"
            target_filepath = dir_nas_media + "/" + "TVSendungen" + "/" + filename
    
    if not os.path.exists(target_foder):	
        os.makedirs(target_foder)
    
    # rename the file
    source_filepath_renamed = dir_downloads + "/" + filename
    if source_filepath_renamed != source_filepath:
        os.rename(source_filepath,source_filepath_renamed)
    
    rsync_command = "rsync --progress --remove-source-files " + source_filepath_renamed.replace(" ", "\\ ").replace("(", "\\(").replace(")", "\\)") + " " + target_foder + " 2>/dev/null"
    check_output(rsync_command,shell=True)

# start tvupdate script
tvu_command = '/bin/bash ' + path_tvu_script + ' &'
os.system(tvu_command)
