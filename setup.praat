# author: jeanphilippegoldman@gmail.com

open_files3$ = readFile$("scripts/template_open_files3.praat")
save_files2$ = readFile$("scripts/template_save_files2.praat")
resample_files$ = readFile$("scripts/template_resample_files.praat")
get_durations$ = readFile$("scripts/template_get_durations.praat")

writeFile: "scripts/open_files3.praat", open_files3$
writeFile: "scripts/save_files2.praat", save_files2$
writeFile: "scripts/resample_files.praat", resample_files$
writeFile: "scripts/get_durations.praat", get_durations$

Add menu command: "Objects", "Praat", "File Tools", "", 0, "" 
Add menu command: "Objects", "Praat", "Open files...", "File Tools", 1, "scripts/open_files3.praat"
Add menu command: "Objects", "Praat", "Save files...", "File Tools", 1, "scripts/save_files2.praat"
Add menu command: "Objects", "Praat", "Remove all", "File Tools", 1, "scripts/remove_all.praat"
Add menu command: "Objects", "Praat", "Resample files...", "File Tools", 1, "scripts/resample_files.praat"
Add menu command: "Objects", "Praat", "Get durations...", "File Tools", 1, "scripts/get_durations.praat"
