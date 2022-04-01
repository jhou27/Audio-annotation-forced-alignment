form Read list
word ref.file canto-pronunciation-dict
word dir /Users/aclyu/Downloads/SCOLAR-tools/3-add-canonical-forms
word ref.dir /Users/aclyu/Downloads/SCOLAR-tools/ref-files
endform


list.name$ = "file_list"
in.files.path$ = dir$ + "/*-transcribed.TextGrid"
Create Strings as file list: list.name$, in.files.path$

ref.path$ = ref.dir$ + "/" + ref.file$ + ".csv"
Read Table from comma-separated file... 'ref.path$'

selectObject: "Strings "+list.name$
no.files = Get number of strings
for file from 1 to no.files
  selectObject: "Strings "+list.name$
  tg.in$ = Get string: file
  filename$ = left$(tg.in$, index(tg.in$,".")-1)
  filename2$ = left$(tg.in$, index(tg.in$,"-")-1)

  tg.in.path$ = dir$ + "/" + tg.in$
  Read from file... 'tg.in.path$'

  tg.out$ = filename2$ + "-done"
  tg.out.path$ = dir$ + "/" + tg.out$ + ".TextGrid"

  select TextGrid 'filename$'
  Duplicate tier: 2, 3, "WORD-Jyutping"
  Duplicate tier: 2, 4, "WORD-CitIPA"
  Duplicate tier: 2, 5, "WORD-CitTone"
  Duplicate tier: 7, 8, "SYLL-Jyutping"
  Duplicate tier: 7, 9, "SYLL-CitIPA"
  Duplicate tier: 7, 10, "SYLL-CitTone"
  Duplicate tier: 7, 14, "PHON-Tone"

  no.ints = Get number of intervals... 3
  for int from 1 to no.ints
    select TextGrid 'filename$'
    label$ = Get label of interval... 3 int
    if label$<>""
      select Table 'ref.file$'
      ref.row = Search column: "Chinese", label$
      if ref.row>0
        label.new$ = Get value: ref.row, "Jyutping"
        select TextGrid 'filename$'
        Set interval text: 3, int, label.new$
      endif
    endif
  endfor

  no.ints = Get number of intervals... 8
  for int from 1 to no.ints
    select TextGrid 'filename$'
    label$ = Get label of interval... 8 int
    if label$<>""
      select Table 'ref.file$'
      ref.row = Search column: "Chinese", label$
      if ref.row>0
        label.new$ = Get value: ref.row, "Jyutping"
        select TextGrid 'filename$'
        Set interval text: 8, int, label.new$
      endif
    endif
  endfor

  no.ints = Get number of intervals... 4
  for int from 1 to no.ints
    select TextGrid 'filename$'
    label$ = Get label of interval... 4 int
    if label$<>""
      select Table 'ref.file$'
      ref.row = Search column: "Chinese", label$
      if ref.row>0
        label.new$ = Get value: ref.row, "IPA.seg"
        select TextGrid 'filename$'
        Set interval text: 4, int, label.new$
      endif
    endif
  endfor

  no.ints = Get number of intervals... 9
  for int from 1 to no.ints
    select TextGrid 'filename$'
    label$ = Get label of interval... 9 int
    if label$<>""
      select Table 'ref.file$'
      ref.row = Search column: "Chinese", label$
      if ref.row>0
        label.new$ = Get value: ref.row, "IPA.seg"
        select TextGrid 'filename$'
        Set interval text: 9, int, label.new$
      endif
    endif
  endfor

  no.ints = Get number of intervals... 5
  for int from 1 to no.ints
    select TextGrid 'filename$'
    label$ = Get label of interval... 5 int
    if label$<>""
      select Table 'ref.file$'
      ref.row = Search column: "Chinese", label$
     if ref.row>0
        label.new$ = Get value: ref.row, "Tone"
        select TextGrid 'filename$'
        Set interval text: 5, int, label.new$
      else
        select TextGrid 'filename$'
        Set interval text: 5, int, "?"
      endif
    endif
  endfor

  no.ints = Get number of intervals... 10
  for int from 1 to no.ints
    select TextGrid 'filename$'
    label$ = Get label of interval... 10 int
    if label$<>""
      select Table 'ref.file$'
      ref.row = Search column: "Chinese", label$
      if ref.row>0
        label.new$ = Get value: ref.row, "Tone"
        select TextGrid 'filename$'
        Set interval text: 10, int, label.new$
      endif
    endif
  endfor

  no.ints = Get number of intervals... 14
  for int from 1 to no.ints
    select TextGrid 'filename$'
    Set interval text: 14, int, ""
  endfor

  Duplicate tier: 5, 7, "WORD-ActTone"
  no.ints = Get number of intervals... 5
  for int from 1 to no.ints
    label$ = Get label of interval... 5 int
    if label$<>""
      t.ons = Get start time of interval: 5, int
      t.off = Get end time of interval: 5, int
      int2a = Get interval at time: 15, t.ons
      int2b = Get interval at time: 15, t.off - 0.001
      lab2$ = ""
      if int2a=int2b
        lab2.add$ = Get label of interval... 15 int2a
        if lab2.add$<>""
          lab2$ = lab2.add$
        else
          lab2$ = "?"
        endif
      else
        for int2 from int2a to int2b
          lab2.add$ = Get label of interval... 15 int2
          if lab2$=""
            if lab2.add$<>""
              lab2$ = lab2.add$
            else
              lab2$ = "?"
            endif
          else
            if lab2.add$<>""
              lab2$ = lab2$ + "." + lab2.add$
            else
              lab2$ = lab2$ + ".?"
            endif
          endif
        endfor
      endif
      Set interval text: 7, int, lab2$
    endif
  endfor

  Duplicate tier: 11, 13, "SYLL-ActTone"
  no.ints = Get number of intervals... 11
  for int from 1 to no.ints
    label$ = Get label of interval... 11 int
    if label$<>""
      t.ons = Get start time of interval: 11, int
      t.off = Get end time of interval: 11, int
      t.mid = (t.ons + t.off)/2
      int2 = Get interval at time: 16, t.mid
      lab2$ = Get label of interval... 16 int2
     if lab2$=""
        lab2$ = "?"
      endif
      Set interval text: 13, int, lab2$
    endif
  endfor

  Save as text file: tg.out.path$
endfor
