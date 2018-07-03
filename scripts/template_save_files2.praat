# Save multiple files
# author: jeanphilippegoldman@gmail.com
include ../procedures/config.proc

form Save selected object to files...
comment Save objects in folder:
text Folder <save_in>
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

n=numberOfSelected()
objects# = selected# ()

# Check if two or more objects share the same name

# Save preferences
## Save fields in preferences.txt
@config.read: "../preferences/preferences.txt"
@config.set: "save_in", folder$
@config.save

## Save fields
@config.read: "../preferences/preferences.txt"
script$ = readFile$("template_save_files2.praat")
script$ = replace$(script$, "<save_in>", config.read.return$["folder"], 1)
writeFile: "save_files2.praat", script$

audio_extension$[1] = "wav"
audio_extension$[2] = "aiff"

save_praat_files_in$[1] = "text"
save_praat_files_in$[2] = "short text"
save_praat_files_in$[3] = "binary"
save_praat_files_in$[4] = "table"
save_praat_files_in$[5] = "tab-separated file"
save_praat_files_in$[6] = "headerless spreadsheet"

writeInfoLine: "Save selected object to files..."

for i to size(objects#)
  selectObject: objects#[i]
  full_name$ = selected$()
  object_type$ = extractWord$(full_name$, "")
  object_name$ = extractWord$(full_name$, " ")
  extension$ = if object_type$ == "Sound" then audio_extension$[save_sounds_in] else object_type$ fi
  command_type$ = if object_type$ == "Sound" then save_sounds_in$ else save_praat_files_in$[save_praat_files_in] fi
  
  filename$ = object_name$ + "." + extension$
  file_fullpath$ = folder$ + "/" + filename$
  
  # Check if the filename already exists
  if fileReadable(file_fullpath$)
    beginPause: "Warning"
      comment: "The file ""'filename$'"" already exists in the specified folder."
      comment: "What do you want to do?"
    clicked = endPause: "Cancel", "Overwrite", "Serialize", 1
    if clicked = 3
      # Serialize
      serial_number = 0
      repeat 
        serial_number += 1
        serial_number$ = if serial_number < 10 then "00" else "0" fi + string$(serial_number)
        filename$ = object_name$ + "_" + serial_number$ + "." + extension$
        file_fullpath$ = folder$ + "/" + filename$
      until not fileReadable(file_fullpath$)
    elsif clicked = 1
      exitScript()
    endif
  endif
  
  save_command$ = "Save as " + command_type$ + " file..."
  
  appendInfoLine: save_command$ + tab$ + file_fullpath$
  do(save_command$, file_fullpath$)
endfor

appendInfoLine: size(objects#), " file(s) in ", folder$

selectObject: objects#
