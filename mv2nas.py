import os
#from shutil import move
from subprocess import check_output

# Input
dir_downloads = '/srv/dev-disk-by-label-ssddata/ssddata/downloads'
dir_nas_media = '/srv/eaec4d04-9e72-4736-a72b-57d16e5b71b5'
path_tvu_script = '/srv/dev-disk-by-label-ssddata/ssddata/omv_scripts/tv/tvupdate.sh'
filetype = '.mp4'
search_strings_and_target_folders = [["Bibi Blocksberg", "TVSendungen_Kinder/Bibi_Blocksberg"],
                                     ["Bibi und Tina", "TVSendungen_Kinder/Bibi_und_Tina"],
                                     ["Die Biene Maja", "TVSendungen_Kinder/Biene_Maja"],
                                     ["Meine Freundin Conni", "TVSendungen_Kinder/Conni"],
                                     ["Lieselotte", "TVSendungen_Kinder/Lieselotte"],
                                     ["Mia and me", "TVSendungen_Kinder/Mia_and_me"],
                                     ["Peter Pan", "TVSendungen_Kinder/Peter_Pan"],
                                     ["Zacki und die Zoobande", "TVSendungen_Kinder/Zacki_Zoobande"],
                                     ["Der kleine Nick", "TVSendungen_Kinder"],
                                     ["Unser Sandmännchen", "TVSendungen_Kinder"],
                                     ["Dschungelbuch", "TVSendungen_Kinder"],
                                     ["JoNaLu", "TVSendungen_Kinder"],
                                     ["Leopard Seebär und Co", "TVSendungen_Kinder"],
                                     ["Der Alte", "TVSendungen/60_-_Der_Alte"],
                                     ["Die Chefin", "TVSendungen/60_-_Die_Chefin"],
                                     ["Der Fernsehfilm der Woche", "TVSendungen/90_-_Fernsehfilm_der_Woche"],
                                     ["Dengler", "TVSendungen/90_-_Dengler"],
                                     ["Die Toten vom Bodensee", "TVSendungen/90_-_Die_Toten_vom_Bodensee"],
                                     ["Letzte Spur Berlin", "TVSendungen/45_-_Letzte_Spur_Berlin"],
                                     ["Ein starkes Team", "TVSendungen/90_-_Ein_starkes_Team"],
                                     ["Polizeiruf 110", "TVSendungen/90_-_Polizeiruf"],
                                     ["Der Samstagskrimi", "TVSendungen/90_-_Sonstige_Samstagskrimis"],
                                     ["SOKO Leipzig", "TVSendungen/45_-_Soko_Leipzig"],
                                     ["SOKO Stuttgart", "TVSendungen/45_-_Soko_Stuttgart"],
                                     ["SOKO Köln", "TVSendungen/45_-_Soko_Köln"],
                                     ["Der Staatsanwalt", "TVSendungen/60_-_Staatsanwalt"],
                                     ["Tatort", "TVSendungen/90_-_Tatort"],
                                     ["Schatten der Mörder - Shadowplay", "TVSendungen/90_-_Schatten_der_Mörder"]]


def get_files(folder, filetype):
#    list_paths = []
    list_filenames = []
    list_dir = os.listdir(folder)
    for file in list_dir:
        if file.endswith(filetype):
#            file_path = os.path.normpath(os.path.join(folder, file))
#            list_paths.append(file_path)
            list_filenames.append(file)
    return list_filenames

for filename_origin in get_files(dir_downloads,filetype):
    source_filepath = dir_downloads + "/" + filename_origin
    filename = filename_origin
    #print(filename)
    # Remove Douplicates in Filename
    filename_split = filename.split(" - ")
    try:
        if (filename_split[1] + " - " + filename_split[2]) in (filename_split[3] + " - " + filename_split[4]):
            #2020-12-12 - Schatten - Shadow - Schatten - Shadow (1).mp4
            filename = filename_split[0]
            for i in range(3,len(filename_split)):
                filename = filename + " - " + filename_split[i]
        if filename_split[1] in filename_split[2]:
            #2020-12-12 - Schatten - Schatten - Folge (1).mp4
            filename = filename_split[0]
            for i in range(2,len(filename_split)):
                filename = filename + " - " + filename_split[i]
    except Exception as e:
        pass
    
    # replace special chars
    filename.replace("&","und")
    filename.replace(";","")
    filename.replace(":","")
    filename.replace(",","")
    
    # show what you have done...
    print(filename)
    
    for searchstring in search_strings_and_target_folders:
        if (" - " + searchstring[0]) in filename:
            filename_split = filename.split((" - " + searchstring[0]))
            filename = filename_split[0] + filename_split[1]
#            print(filename)
            target_foder = dir_nas_media + "/" + searchstring[1] + "/"
            target_filepath = dir_nas_media + "/" + searchstring[1] + "/" + filename
            break
        else:
            target_foder = dir_nas_media + "/" + "TVSendungen" + "/"
            target_filepath = dir_nas_media + "/" + "TVSendungen" + "/" + filename
    
#    print(target_filepath)
    
    #print("{} => {}".format(source_filepath,target_filepath))
    
    if not os.path.exists(target_foder):	
        os.makedirs(target_foder)
    #move(source_filepath, target_filepath)
    source_filepath_renamed = dir_downloads + "/" + filename
    if source_filepath_renamed != source_filepath:
        os.rename(source_filepath,source_filepath_renamed)
    
    #check_output(["touch",target_filepath])
    check_output(["rsync","--progress","--remove-source-files", source_filepath_renamed, target_foder, "2>/dev/null"])
    
    tvu_command = "/bin/bash " + path_tvu_script + " &"
    #os.system(tvu_command)
    
