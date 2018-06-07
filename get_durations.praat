# author: jeanphilippegoldman@gmail.com
# Description: get durations of audio files in a folder

form Get Durations of all audio files
  comment Folder with sound files:
  text Folder 
  word Sound_file_extension wav
endform

folder$= folder$-"\"-"/"
runScript: "setbasename.praat", folder$, ""

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
