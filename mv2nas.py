import os

# Input
dir_downloads = '/srv/dev-disk-by-label-ssddata/ssddata/downloads'
dir_nas_media = '/srv/eaec4d04-9e72-4736-a72b-57d16e5b71b5'
dir_tvu_script = '/srv/dev-disk-by-label-ssddata/ssddata/omv_scripts/tv'
filetype = '.mp4'

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

for filename in get_files(dir_downloads,filetype):
    print(filename)
    filename_split = filename.split(" - ")
    try:
        if (filename_split[1] + filename_split[2]) == (filename_split[3] + filename_split[4]):
            filename = filename_split[0] + " - "
            for i in range(3,len(filename_split)):
                filename = filename + " - " + i
                print("double doublicates")
        if filename_split[1] == filename_split[2]:
            filename = filename_split[0] + " - "
            for i in range(2,len(filename_split)):
                filename = filename + " - " + i
                print("single doublicates")
    except:
        print("no doublicates")
        pass
    print(filename)
