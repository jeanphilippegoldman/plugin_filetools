# author: jeanphilippegoldman@gmail.com
# Description: Modify sample frequency of audio files in a folder

form Modify sample frequency
  optionmenu sampling_frequency 1
    option 16000
    option 22050
    option 44100
    option 48000
comment Folder with sound files:
text Folder 
word File_extension wav
endform

writeInfoLine: "Resample files..."
folder$=folder$-"\"-"/"
#execute setbasename.praat "'folder$'" 'files$'

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
