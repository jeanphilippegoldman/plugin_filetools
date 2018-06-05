# Open files from a folder (and subfolders)
# author: jeanphilippegoldman@gmail.com

form Open files...
text Folder C:\Users\jp\Google Drive\MIAPARLE\projects\OMO\
text Files 
boolean and_immediate_subfolders no
optionmenu openmethod 1
  option Read from file...
  option Read Table from table file...
  option Read Table from tab-separated file...
comment need more levels or more opening options ? ask the author
endform

clearinfo
printline Open files...
execute setbasename.praat "'folder$'" 'files$'

call loadextensions

nrf2=0
call openthis "'folder$'" 'files$'

if and_immediate_subfolders
  listID=Create Strings as directory list... dir 'folder$'
  numberOfDir = Get number of strings
  if numberOfDir!=0
    for idir to numberOfDir
      dirname$ = Get string... idir
      if dirname$!="." and dirname$!=".."
        call openthis "'folder$''dirname$'" 'files$'
        select Strings dir
      endif
    endfor
  endif
  printline Grand total : 'nrf2' file(s) in 'folder$'
  select listID
  Remove
endif

select extID
plus wextID
Remove

procedure openthis .d$ .f$
nrf=0
printline openthis:'.d$' '.f$'
Create Strings as file list... list '.d$'\'.f$'
Sort
numberOfFiles = Get number of strings
printline 'numberOfFiles'
for ifile to numberOfFiles
  filename$ = Get string... ifile
  #printline '.d$'\'filename$'
  if fileReadable("'.d$'\'filename$'")
    #printline readable
    call checkextension
    if checkextension.r
      printline 'openmethod$' '.d$'\'filename$'
      s'ifile'ID='openmethod$' '.d$'\'filename$'
      nrf=nrf+1
      nrf2=nrf2+1
    else
     printline extension not supported
    endif
  else
    #printline not readable
    s'ifile'ID=0
  endif
  select Strings list
endfor
select Strings list
Remove

printline 'nrf' file(s) in '.d$'
endproc


procedure checkextension
  .r=0
  .extension$ = right$(filename$,length(filename$)-rindex(filename$,"."))
  #printline '.extension$'
  .extension$= replace_regex$(.extension$,".","\L&",0)
  #printline '.extension$'
  select wextID
  .r=Has word... '.extension$'
endproc

procedure loadextensions
  extID=Read Strings from raw text file... extensions.txt
  Sort
  wextID=To WordList
  #replace_regex$(a$,".","\L&",0)
endproc

