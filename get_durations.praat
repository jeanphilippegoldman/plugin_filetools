# get durations of audio files in a folder
# author: jeanphilippegoldman@gmail.com
# Description: ?

form Get Durations of all audio files
  comment Folder with sound files:
  text Folder 
  word Sound_file_extension wav
endform

folder$= folder$-"\"-"/"
runScript: "setbasename.praat", folder$, ""

fileList = Create Strings as file list: "list", folder$ + "/*" + sound_file_extension$
numberOfFiles = Get number of strings

total_duration = 0

writeInfoLine: "Get durations..."

for ifile to numberOfFiles
  sd$ = object$[fileList, ifile]
  sdPath$ = folder$ + "/" + sd$
  sd = Read from file: sdPath$
  duration = object[sd].xmax
  total_duration += duration
  appendInfoLine: fixed$(duration, 3), tab$, sd$
  removeObject: sd
endfor

removeObject: fileList
appendInfoLine: "Total duration: ", fixed$(total_duration, 3)

if numberOfFiles != 0
  mean_duration = total_duration / numberOfFiles
  appendInfoLine: "Mean duration: ", fixed$(mean_duration, 3)
endif
