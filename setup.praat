# author: jeanphilippegoldman@gmail.com
include procedures/config.proc

if praatVersion < 6040
  appendInfoLine: "Plug-in name: filetools"
  appendInfoLine: "Warning: This plug-in only works on Praat version 6.0.40 or later. Please, get a more recent version of Praat."
  appendInfoLine: "Praat website: http://www.fon.hum.uva.nl/praat/"
endif

@config.read: "preferences/preferences.txt"

open_files3$ = readFile$("scripts/template_open_files3.praat")
open_files3$ = replace$(open_files3$, "<folder>", config.read.return$["folder"], 1)
open_files3$ = replace$(open_files3$, "<file_extension>", config.read.return$["file_extension"], 1)

save_files2$ = readFile$("scripts/template_save_files2.praat")
save_files2$ = replace$(save_files2$, "<save_in>", config.read.return$["save_in"], 1)

resample_files$ = readFile$("scripts/template_resample_files.praat")
resample_files$ = replace$(resample_files$, "<folder>", config.read.return$["folder"], 1)
resample_files$ = replace$(resample_files$, "<audio_extension>", config.read.return$["audio_extension"], 1)

get_durations$ = readFile$("scripts/template_get_durations.praat")
get_durations$ = replace$(get_durations$, "<folder>", config.read.return$["folder"], 1)
get_durations$ = replace$(get_durations$, "<audio_extension>", config.read.return$["audio_extension"], 1)

writeFile: "scripts/open_files3.praat", open_files3$
writeFile: "scripts/save_files2.praat", save_files2$
writeFile: "scripts/resample_files.praat", resample_files$
writeFile: "scripts/get_durations.praat", get_durations$

Add menu command: "Objects", "Praat", "File Tools", "", 0, "" 
Add menu command: "Objects", "Praat", "Open files...", "File Tools", 1, "scripts/open_files3.praat"
Add menu command: "Objects", "Praat", "Save files...", "File Tools", 1, "scripts/save_files2.praat"
Add menu command: "Objects", "Praat", "Remove all", "File Tools", 1, "scripts/template_remove_all.praat"
Add menu command: "Objects", "Praat", "Resample files...", "File Tools", 1, "scripts/resample_files.praat"
Add menu command: "Objects", "Praat", "Get durations...", "File Tools", 1, "scripts/get_durations.praat"
