# Open files from a folder (and subfolders)
# author: jeanphilippegoldman@gmail.com
include ../procedures/list_recursive_path.proc
include ../procedures/check_extension.proc
include ../procedures/config.proc

form Open files...
comment Folder with files:
text Folder <folder>
word File_extension <file_extension>
boolean Recursive_search 0
optionmenu Open_method 1
  option Read from file...
  option Read long sound file...
  option Read Table from tab-separated file...
  option Read Table from comma-separated file...
endform

# Save preferences
## Save fields in preferences.txt
@config.read: "../preferences/preferences.txt"
@config.set: "folder", folder$
@config.set: "file_extension", file_extension$
@config.save

## Save script
@config.read: "../preferences/preferences.txt"
script$ = readFile$("template_open_files3.praat")
script$ = replace$(script$, "<folder>", config.read.return$["folder"], 1)
script$ = replace$(script$, "<file_extension>", config.read.return$["file_extension"], 1)
writeFile: "open_files3.praat", script$

open_command$[1] = "Read from file..."
open_command$[2] = "Read long sound file..."
open_command$[3] = "Read Table from tab-separated file..."
open_command$[4] = "Read Table from comma-separated file..."

folder$=folder$-"\"-"/"

# List all files
files$ = if file_extension$ == "" or file_extension$ == "*" then "*" else "*." + file_extension$ fi 

@createStringAsFileList: "fileList",  folder$ + "/" + files$, recursive_search
file_list = createStringAsFileList.return
number_of_files = Get number of strings

info$ = ""
# Get only valid extensions
check_extension = if file_extension$ == "" or file_extension$ == "*" then 1 else 0 fi 
if check_extension
  valid_extensions$ = readFile$("../preferences/extensions.txt")
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
for i to number_of_files
  file$ = object$[file_list, i]
  file_path$ = folder$ + "/" + file$
    
  info$ = info$ + open_command$[open_method] + tab$ + file_path$ + newline$
  object = do(open_command$[open_method], file_path$)
endfor

# Print results
writeInfoLine: "Open files..."
appendInfoLine: "Number of files: ", number_of_files
appendInfoLine: "Folder: ", folder$
appendInfoLine: ""
appendInfoLine: info$

removeObject: file_list
