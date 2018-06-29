# author: jeanphilippegoldman@gmail.com
# Description: get durations of audio files in a folder
include ../procedures/list_recursive_path.proc
include ../procedures/check_extension.proc
include ../procedures/config.proc

form Get Durations of all audio files
  comment Folder with sound files:
  text Folder <folder>
  word Sound_file_extension <audio_extension>
  boolean Recursive_search 0
endform

folder$= folder$-"\"-"/"

# Save preferences
## Save fields in preferences.txt
@config.read: "../preferences/preferences.txt"
@config.set: "folder", folder$
@config.set: "audio_extension", sound_file_extension$
@config.save

## Save fields
@config.read: "../preferences/preferences.txt"
script$ = readFile$("template_get_durations.praat")
script$ = replace$(script$, "<folder>", config.read.return$["folder"], 1)
script$ = replace$(script$, "<audio_extension>", config.read.return$["audio_extension"], 1)
writeFile: "get_durations.praat", script$

# List all files
files$ = if sound_file_extension$ == "" or sound_file_extension$ == "*" then "*" else "*." + sound_file_extension$ fi 
@createStringAsFileList: "fileList",  folder$ + "/" + files$, recursive_search
file_list = createStringAsFileList.return
number_of_files = Get number of strings

# Get only valid extensions
check_extension = if sound_file_extension$ == "" or sound_file_extension$ == "*" then 1 else 0 fi
if check_extension
  valid_extensions$ = readFile$("../preferences/extensions_get_durations.txt")
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

# Compute
total_duration = 0

info$ = ""
for ifile to number_of_files
  sd$ = object$[file_list, ifile]
  sd_path$ = folder$ + "/" + sd$
  sd = Read from file: sd_path$
  duration = object[sd].xmax
  total_duration += duration
  info$ = info$ + fixed$(duration, 3)+ tab$+ sd_path$ + newline$
  removeObject: sd
endfor

removeObject: file_list

# Print results
writeInfoLine: "Get durations..."
appendInfoLine: "Number of files: ", number_of_files
appendInfoLine: "Folder: ", folder$
appendInfoLine: "Total duration: ", fixed$(total_duration, 3)
if number_of_files != 0
  mean_duration = total_duration / number_of_files
  appendInfoLine: "Mean duration: ", fixed$(mean_duration, 3)
endif
appendInfoLine: ""
appendInfoLine: info$
