# modifies scripts for their default folder and files input variables
# author: jeanphilippegoldman@gmail.com

form Set base name
text Folder C:\Users\jp\Google Drive\MIAPARLE\projects\OMO\
text Files 
endform

clearinfo
#printline Setbasename
if right$(folder$,1)!="\" and right$(folder$,1)!="/"
  folder$= folder$ + "/"
endif

call modifile setbasename.praat "'folder$'" 'files$'
call modifile open_files3.praat "'folder$'" 'files$'
call modifile save_files2.praat "'folder$'" ""
call modifile get_durations.praat "'folder$'" 'files$'

procedure modifile .script$ .folder$ .files$

  Read Strings from raw text file... '.script$'
  ns=Get number of strings
  call modiline "text Folder" 'folder$'
  .mod_folder = modiline.cont
  call modiline "text Files" 'files$'
  .mod_files = modiline.cont

  if .mod_folder ==0 or .mod_files == 0
    Write to raw text file... '.script$'
    #printline Modified '.script$'
  else
    #printline Not modified '.script$'
  endif
  Remove
endproc

procedure modiline .declaration$ .mod$

  .cont = 1
  .i = 1
  while .cont==1 and .i<=ns
    .s$=Get string... '.i'
    .in = index(.s$,.declaration$)
    if .in>0
      .s$=left$(.s$,.in+length(.declaration$)-1)+" "+.mod$
      Set string... '.i' '.s$'
      .cont=0
    endif
  .i=.i+1
  endwhile
endproc
