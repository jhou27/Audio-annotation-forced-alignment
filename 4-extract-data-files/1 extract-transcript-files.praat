form Read list
integer tier 1
word dir /Users/aclyu/Downloads/SCOLAR-tools/4-extract-data-files
word out.dir /Users/aclyu/Downloads/SCOLAR-tools/corpus-data/raw
endform

list.name$ = "file_list"
in.files.path$ = dir$ + "/*-done.TextGrid"
Create Strings as file list: list.name$, in.files.path$

selectObject: "Strings "+list.name$
no.files = Get number of strings

for file from 1 to no.files
  selectObject: "Strings "+list.name$
  tg.name$ = Get string: file
  tg.path$ = dir$ + "/" + tg.name$
  Read from file... 'tg.path$'
  no.ints = Get number of intervals... tier
  file.name$ = left$(tg.name$, index(tg.name$,".")-1)
  session.label$ = left$(file.name$, index(file.name$,"-done")-1)
  fileout$ = out.dir$ + "/" + session.label$ + ".transcript"
  if fileReadable(fileout$)=0
    for int from 1 to no.ints
      select TextGrid 'file.name$'
      label$ = Get label of interval... tier int
      time = Get end point... tier int
      if label$<>"#" and label$<>""
        length = length(label$)
        utterance$ = ""
        for l from 1 to length
          char$ = mid$(label$,l,1)
          if char$<>"+" and char$<>"-" and char$<>" "
            utterance$ = utterance$ + char$
          endif
        endfor
        if int=1
          fileappend 'fileout$' 'time''tab$''utterance$'
        else
          fileappend 'fileout$' 'newline$''time''tab$''utterance$'
        endif
      else
        utterance$ = "<SIL>"
        if int=1
          fileappend 'fileout$' 'time''tab$''utterance$'
        else
          fileappend 'fileout$' 'newline$''time''tab$''utterance$'
        endif
      endif
    endfor
  endif
  select TextGrid 'file.name$'
  Remove
endfor

selectObject: "Strings "+list.name$
Remove
