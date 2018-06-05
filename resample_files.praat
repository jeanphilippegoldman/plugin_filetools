# Modify sample frequency of audio files in a folder
# author: jeanphilippegoldman@gmail.com

form Modify sample frequency
  optionmenu sampling_frequency 1
    option 16000
    option 22050
    option 44100
    option 48000
  comment folder
  text Folder C:\Users\goldman\Desktop\CLIPS\
  text Files *.wav
endform

clearinfo
printline Resample files...
folder$=folder$-"\"-"/"+"/"
execute setbasename.praat "'folder$'" 'files$'

sp='sampling_frequency$'
sID=Create Strings as file list... list 'folder$''files$'
numberOfFiles = Get number of strings
printline 'numberOfFiles' files

for ifile to numberOfFiles
  select Strings list
  filename$ = Get string... ifile
  printline 'ifile' 'filename$'
  sID=Read from file... 'folder$''filename$'
  s$=selected$("Sound")
  s2ID=Resample... 'sp' 50
  Rename... 'filename$'
  select s2ID
  printline Save as WAV file... 'folder$''s$'.wav
  nowarn Save as WAV file... 'folder$''s$'.wav
  plus sID
  Remove
endfor
select Strings list
Remove

