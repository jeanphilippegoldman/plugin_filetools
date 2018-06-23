# Open files from a folder (and subfolders)
# author: jeanphilippegoldman@gmail.com
include ../procedures/list_recursive_path.proc
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
file_extension$ = if file_extension$ == "*" then "" else file_extension$ fi 

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
