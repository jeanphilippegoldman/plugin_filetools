# author: jeanphilippegoldman@gmail.com
# Description: Modify sample frequency of audio files in a folder
include ../procedures/config.proc

form Modify sample frequency
  optionmenu sampling_frequency 1
    option 16000
    option 22050
    option 44100
    option 48000
comment Folder with sound files:
text Folder <folder>
word File_extension <audio_extension>
endform

# Save preferences
## Save fields in preferences.txt
@config.read: "../preferences/preferences.txt"
@config.set: "folder", folder$
@config.set: "audio_extension", file_extension$
@config.save

## Save fields
@config.read: "../preferences/preferences.txt"
script$ = readFile$("template_resample_files.praat")
script$ = replace$(script$, "<folder>", config.read.return$["folder"], 1)
script$ = replace$(script$, "<audio_extension>", config.read.return$["file_extension"], 1)
writeFile: "resample_files.praat", script$

writeInfoLine: "Resample files..."
folder$=folder$-"\"-"/"

sampling_frequency = number(sampling_frequency$)

file_list = Create Strings as file list: "list", folder$ + "/*." + file_extension$
numberOfFiles = Get number of strings

appendInfoLine: numberOfFiles, " files"

for ifile to numberOfFiles
  filename$ = object$[file_list, ifile]
  appendInfoLine: ifile, tab$, filename$
  sound = Read from file: folder$ + "/" + filename$
  sound$ = selected$("Sound")
  
  sound_resampled = Resample: sampling_frequency, 50
  Rename: filename$
  Save as WAV file: folder$ + "/" + filename$
  removeObject: sound, sound_resampled
endfor
removeObject: file_list
