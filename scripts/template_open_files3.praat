# Open files from a folder (and subfolders)
# author: jeanphilippegoldman@gmail.com

include ../procedures/list_recursive_path.proc

form Open files...
comment Folder with sound files:
text Folder 
word File_extension wav
boolean Recursive_search 0
optionmenu Open_method 1
  option Read from file...
  option Read long sound file...
  option Read Table from tab-separated file...
  option Read Table from comma-separated file...
endform

open_command$[1] = "Read from file..."
open_command$[2] = "Read long sound file..."
open_command$[3] = "Read Table from tab-separated file..."
open_command$[4] = "Read Table from comma-separated file..."
  

folder$=folder$-"\"-"/"
runScript: "../setbasename.praat", folder$, ""

checkextension = 0
if file_extension$ == ""
  extension_list$ = newline$ + readFile$("../preferences/extensions.txt")
  checkextension = 1
else
  file_extension$ = ".'file_extension$'"
endif

# Create file_list
if recursive_search
  @findFiles: folder$, "*" + file_extension$
  file_list = findFiles.return
else
  file_list = Create Strings as file list: "fileList", folder$ + "/*" + file_extension$
endif
Sort
number_of_files = Get number of strings
counter = 0

# Display in the Info window
clearinfo
writeInfoLine: "Open files..."
appendInfoLine: "Number of files: ", number_of_files

# Open each object
for i to number_of_files
  open_file = 1
  file$ = object$[file_list, i]
  file_path$ = folder$ + "/" + file$
  
  if checkextension
    extension$ = replace_regex$(file_path$, "(.*\.)(.*)", "\L\2", 0)
    open_file = index_regex(extension_list$, "\n'extension$'\n")
    message$ = "extension not supported"
  endif
  
  if open_file
    message$ = open_command$[open_method] + tab$ + file_path$
    object = do(open_command$[open_method], file_path$)
    counter+= 1
  endif  
  appendInfoLine: message$
endfor

appendInfoLine: counter, " file(s) in ", folder$

removeObject: file_list
