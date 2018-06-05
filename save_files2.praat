# Save multiple files
# author: jeanphilippegoldman@gmail.com

form Save selected object to files...
comment Folder
text Folder C:\Users\jp\Google Drive\MIAPARLE\projects\OMO\
optionmenu save_sounds_in 1
	option WAV
	option AIFF
optionmenu save_praat_files_in 1
	option text
	option short_text
	option binary
	option table
	option tab-separated file
	option headerless spreadsheet
endform

clearinfo
printline Save selected object to files...
n=numberOfSelected()
printline 'n' objetcs
for i to n
  id'i'=selected(i)
  s'i'$ = selected$ (i)
  t'i'$ = extractWord$ (selected$ (i), "")
  n'i'$= right$(selected$(i),length(s'i'$)-length(t'i'$)-1)
endfor

folder$=folder$-"\"-"/"+"/"
execute setbasename.praat "'folder$'"

for i to n
  select id'i'
  thisname$=n'i'$
  thistype$=t'i'$
  if t'i'$="Sound"
    printline Write to 'save_sounds_in$' file... 'folder$''thisname$'.'save_sounds_in$'
    Write to 'save_sounds_in$' file... 'folder$''thisname$'.'save_sounds_in$'
  else
    printline Write to 'save_praat_files_in$' file... 'folder$''thisname$'.'thistype$'
    Write to 'save_praat_files_in$' file... 'folder$''thisname$'.'thistype$'
  endif
endfor

