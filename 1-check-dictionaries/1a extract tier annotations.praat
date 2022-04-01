form Read list
word dir1 /Users/aclyu/Downloads/SCOLAR-tools/1-check-dictionaries
word dir2 /Users/aclyu/Downloads/SPPAS-3.6-2021-02-23/resources/vocab
integer tier 1
endform

strings = Create Strings as file list: "list", dir1$ + "/*.wav"
no.files = Get number of strings

for n to no.files
  selectObject: strings
  file$ = Get string: n
  Read from file: dir1$ + "/" + file$
  filename$ = left$(file$,index(file$,".wav")-1)

  tg.path$ = dir1$ + "/" + filename$ + ".TextGrid"
  Read from file... 'tg.path$'
  no.ints = Get number of intervals... tier

  clearinfo
  fileout$ = dir1$ + "/annotations-" + filename$ + ".txt"
  fileappend 'fileout$' File'tab$'Interval'tab$'Time'tab$'Utterance

  for int from 1 to no.ints
    select TextGrid 'filename$'
    label$ = Get label of interval... tier int
    time = Get start point... tier int
    if label$<>"#" and label$<>""
      length = length(label$)
      utterance$ = ""
      for l from 1 to length
        char$ = mid$(label$,l,1)
        if char$<>"+" and char$<>"-" and char$<>" "
          utterance$ = utterance$ + char$
        endif
      endfor
      fileappend 'fileout$' 'newline$''filename$''tab$''int''tab$''time''tab$''utterance$'
    endif
  endfor
endfor