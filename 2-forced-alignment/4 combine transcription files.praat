form Read list
word dir /Users/aclyu/Downloads/SCOLAR-tools/2-forced-alignment
endform

list.name$ = "file_list"
in.files.path$ = dir$ + "/*_syllables-transcribed.TextGrid"
Create Strings as file list: list.name$, in.files.path$

selectObject: "Strings "+list.name$
no.files = Get number of strings
for file from 1 to no.files
  selectObject: "Strings "+list.name$

  filename1$ = Get string: file
  tg.in1$ = left$(filename1$, index(filename1$,".")-1)
  tg.in.path1$ = dir$ + "/" + filename1$
  Read from file... 'tg.in.path1$'

  tg.in2$ = left$(filename1$, index(filename1$,"_")) + "words-transcribed"
  filename2$ = tg.in2$ + ".TextGrid"
  tg.in.path2$ = dir$ + "/" + filename2$
  Read from file... 'tg.in.path2$'

  tg.out$ = left$(filename1$, index(filename1$,"_")-1) + "-transcribed"
  tg.out.path$ = dir$ + "/" + tg.out$ + ".TextGrid"


  select TextGrid 'tg.in1$'
  Copy: tg.in1$
  Rename: tg.out$
  Set tier name: 2, "SYLL-Ortho"
  Set tier name: 3, "SYLL-ActIPA"
  Insert interval tier: 6, "WORD-Ortho"
  Insert interval tier: 7, "WORD-ActIPA"

  select TextGrid 'tg.in2$'
  no.ints = Get number of intervals... 2
  int.syll = 0
  for int.wd from 1 to no.ints-1
    int.syll = int.syll + 1
    select TextGrid 'tg.in2$'
    lab.ortho.wd$ = Get label of interval... 2 int.wd
    lab.ipa.wd$ = Get label of interval... 3 int.wd

    select TextGrid 'tg.out$'
    lab.ortho.syll$ = Get label of interval... 2 int.syll
    lab.ipa.syll$ = Get label of interval... 3 int.syll
    t.right.syll = Get end time of interval... 2 int.syll
    while lab.ortho.syll$<>lab.ortho.wd$
      int.syll = int.syll+1
      t.right.syll = Get end time of interval... 2 int.syll
      lab.ortho.syll.add$ = Get label of interval... 2 int.syll
      lab.ipa.syll.add$ = Get label of interval... 3 int.syll
      lab.ortho.syll$ = lab.ortho.syll$ + lab.ortho.syll.add$
      lab.ipa.syll$ = lab.ipa.syll$ + "." + lab.ipa.syll.add$
    endwhile

    Insert boundary: 6, t.right.syll
    Insert boundary: 7, t.right.syll
    Set interval text... 6 int.wd 'lab.ortho.syll$'
    Set interval text... 7 int.wd 'lab.ipa.syll$'
  endfor

  Duplicate tier: 2, 8, "SYLL-Ortho"
  Duplicate tier: 3, 9, "SYLL-ActIPA"
  Duplicate tier: 4, 10, "PHON-Phoneme"
  Duplicate tier: 5, 11, "PHON-Phone"

  Remove tier... 2
  Remove tier... 2
  Remove tier... 2
  Remove tier... 2

  Save as text file: tg.out.path$

endfor
