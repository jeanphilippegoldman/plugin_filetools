# author: jeanphilippegoldman@gmail.com
# Description: Modify sample frequency of audio files in a folder
include ../procedures/list_recursive_path.proc
include ../procedures/check_extension.proc
include ../procedures/config.proc


form Modify sample frequency
  optionmenu Sampling_frequency 1
    option 16000
    option 22050
    option 44100
    option 48000
  comment Folder with sound files:
  text Folder <folder>
  word Sound_file_extension <audio_extension>
  boolean Recursive_search 0
endform

# Save preferences
## Save fields in preferences.txt
@config.read: "../preferences/preferences.txt"
@config.set: "folder", folder$
@config.set: "audio_extension", sound_file_extension$
@config.save

## Save fields
@config.read: "../preferences/preferences.txt"
script$ = readFile$("template_resample_files.praat")
script$ = replace$(script$, "<folder>", config.read.return$["folder"], 1)
script$ = replace$(script$, "<audio_extension>", config.read.return$["file_extension"], 1)
writeFile: "resample_files.praat", script$

folder$=folder$-"\"-"/"

sampling_frequency = number(sampling_frequency$)

# List all files
files$ = if sound_file_extension$ == "" or sound_file_extension$ == "*" then "*" else "*." + sound_file_extension$ fi 
@createStringAsFileList: "fileList",  folder$ + "/" + files$, recursive_search
file_list = createStringAsFileList.return
number_of_files = Get number of strings

# Get only valid extensions
check_extension = if sound_file_extension$ == "" or sound_file_extension$ == "*" then 1 else 0 fi
if check_extension
  valid_extensions$ = readFile$("../preferences/extensions_audio.txt")
  for ifile to number_of_files
    filename$ = object$[file_list, ifile]
    @checkExtension: filename$, valid_extensions$
    if not checkExtension.return
      Remove string: ifile
      ifile -=1
      number_of_files -= 1
    endif
  endfor
endif

#compute
info$ = ""
for ifile to number_of_files
  open_file = 1
  file$ = object$[file_list, ifile]
  file_path$ = folder$ + "/" + file$

  info$ = info$ + string$(ifile) + tab$ + file_path$ + newline$
  sound = Read from file: file_path$
  sound$ = selected$("Sound")
  
  sound_resampled = Resample: sampling_frequency, 50
  Rename: file$
  Save as WAV file: folder$ + "/" + file$
  removeObject: sound, sound_resampled
endfor
removeObject: file_list

# Print results
writeInfoLine: "Resample files..."
appendInfoLine: "Number of files: ", number_of_files
appendInfoLine: "Folder: ", folder$
appendInfoLine: ""
appendInfoLine: info$
