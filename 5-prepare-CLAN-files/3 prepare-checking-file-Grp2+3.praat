form Read list
word speaker s203
word extension cl
word main_directory D:/Data/CDS-corpus/SCOLAR-tools/audio-files
word out_directory D:/Data/CDS-corpus/SCOLAR-tools/5-prepare-CLAN-files
endform

dir$ = main_directory$ + "/" + speaker$

filename$ = speaker$ + extension$ + "-CLAN-unchecked"
filename.new$ = speaker$ + extension$ + "-CLAN-to-check"

tg.path$ = dir$ + "/" + filename$ + ".TextGrid"
Read from file... 'tg.path$'

fileout$ = out_directory$ + "/" + filename.new$ + ".TextGrid"

select TextGrid 'filename$'
Remove tier: 12
Remove tier: 10
Remove tier: 6

Rename: filename.new$

Save as text file: fileout$
