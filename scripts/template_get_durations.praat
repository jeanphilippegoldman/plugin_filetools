# author: jeanphilippegoldman@gmail.com
# Description: get durations of audio files in a folder
include ../procedures/config.proc

form Get Durations of all audio files
  comment Folder with sound files:
  text Folder <folder>
  word Sound_file_extension <audio_extension>
endform

@config.read: "../preferences/preferences.txt"

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

fileList = Create Strings as file list: "list", folder$ + "/*" + sound_file_extension$
number_of_files = Get number of strings

total_duration = 0

writeInfoLine: "Get durations..."

for ifile to number_of_files
  sd$ = object$[fileList, ifile]
  sd_path$ = folder$ + "/" + sd$
  sd = Read from file: sd_path$
  duration = object[sd].xmax
  total_duration += duration
  appendInfoLine: fixed$(duration, 3), tab$, sd$
  removeObject: sd
endfor

removeObject: fileList
appendInfoLine: "Total duration: ", fixed$(total_duration, 3)

if number_of_files != 0
  mean_duration = total_duration / number_of_files
  appendInfoLine: "Mean duration: ", fixed$(mean_duration, 3)
endif
