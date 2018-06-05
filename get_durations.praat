# get durations of audio files in a folder
# author: jeanphilippegoldman@gmail.com

form Get Durations of all WAV files
comment provide a folder
text Folder C:\Users\jp\Google Drive\MIAPARLE\projects\OMO\
text Files 
endform

clearinfo
printline Get durations...
execute setbasename.praat "'folder$'" 'files$'

Create Strings as file list... list 'folder$'\'files$'
numberOfFiles = Get number of strings

total_duration = 0

for ifile to numberOfFiles
  filename$ = Get string... ifile
  Read from file... 'folder$'/'filename$'
  duration = Get total duration
  total_duration = total_duration + duration
  printline 'duration:3''tab$''filename$' 
  Remove
select Strings list
endfor
Remove
printline Total duration: 'total_duration:3'
if numberOfFiles != 0
  mean_duration = total_duration / numberOfFiles
  printline Mean duration:  'mean_duration:3'
endif


