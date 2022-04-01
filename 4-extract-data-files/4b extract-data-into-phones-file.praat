form Read list
integer tier.phon 9
word dir /Users/aclyu/Downloads/SCOLAR-tools/4-extract-data-files
endform

date$ = date$()

list.name$ = "file_list"
in.files.path$ = dir$ + "/*-sylls.TextGrid"
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

  out.file$ = filename2$ + ".phones"
  out.path$ = dir$ + "/" + out.file$

  # fileappend 'out.path$' fileID 'filename$''newline$'
  # fileappend 'out.path$' comment created on 'date$''newline$'
  # fileappend 'out.path$' #'newline$'

  select TextGrid 'filename$'
  no.ints = Get number of intervals... tier.phon
  for int from 1 to no.ints
    lab.phon$ = Get label of interval... tier.phon int
    t.off = Get end point... tier.phon int
    if lab.phon$<>""
      lab.phon$ = Get label of interval... tier.phon int
      fileappend 'out.path$' 't.off''tab$''lab.phon$''newline$'
    else
      fileappend 'out.path$' 't.off''tab$'<SIL>'newline$'
    endif
  endfor
endfor

