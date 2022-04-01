form Read list
word dir /Users/aclyu/Downloads/SCOLAR-tools/4-extract-data-files
endform

list.name$ = "file_list"
in.files.path$ = dir$ + "/*-done.TextGrid"
Create Strings as file list: list.name$, in.files.path$

selectObject: "Strings "+list.name$
no.files = Get number of strings
for file from 1 to no.files
  selectObject: "Strings "+list.name$
  tg.in$ = Get string: file
  filename$ = left$(tg.in$, index(tg.in$,".")-1)
  filename2$ = left$(tg.in$, index(tg.in$,"-")-1)
  tg.in.path$ = dir$ + "/" + tg.in$
  Read from file... 'tg.in.path$'

  tg.out1$ = filename2$ + "-words"
  tg.out.path1$ = dir$ + "/" + tg.out1$ + ".TextGrid"
  tg.out2$ = filename2$ + "-sylls"
  tg.out.path2$ = dir$ + "/" + tg.out2$ + ".TextGrid"

  select TextGrid 'filename$'
  Copy: tg.out1$
  Remove tier: 8
  Remove tier: 8
  Remove tier: 8
  Remove tier: 8
  Remove tier: 8
  Remove tier: 8
  Save as text file: tg.out.path1$

  select TextGrid 'filename$'
  Copy: tg.out2$
  Remove tier: 2
  Remove tier: 2
  Remove tier: 2
  Remove tier: 2
  Remove tier: 2
  Remove tier: 2
  Save as text file: tg.out.path2$

endfor

