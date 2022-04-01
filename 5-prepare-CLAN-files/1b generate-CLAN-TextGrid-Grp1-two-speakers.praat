form Read list
word speaker s203
word extension cl
word main_directory D:/Data/CDS-corpus/SCOLAR-tools/audio-files
word out_directory D:/Data/CDS-corpus/SCOLAR-tools/5-prepare-CLAN-files
endform

dir$ = main_directory$ + "/" + speaker$

filename1$ = speaker$ + extension$ + "-1-done"
filename2$ = speaker$ + extension$ + "-2"
filename.new$ = speaker$ + extension$ + "-CLAN-unchecked"

tg.path1$ = dir$ + "/" + filename1$ + ".TextGrid"
Read from file... 'tg.path1$'

tg.path2$ = dir$ + "/" + filename2$ + ".TextGrid"
Read from file... 'tg.path2$'
Set tier name: 1, "CHI"
Extract one tier: 1

fileout$ = out_directory$ + "/" + filename.new$ + ".TextGrid"

select TextGrid 'filename1$'
Duplicate tier: 1, 1, "MOT"
no.ints.utt = Get number of intervals: 2

for i.u from 1 to no.ints.utt
  select TextGrid 'filename1$'
  lab.utt$ = Get label of interval: 1, i.u
  if lab.utt$<>""
    start.utt = Get start time of interval: 1, i.u
    end.utt = Get end time of interval: 1, i.u

    label$ = ""
    int.ortho.start = Get interval at time: 3, start.utt
    int.ortho.end = Get interval at time: 3, end.utt
    for i.o from int.ortho.start to int.ortho.end
      start.wd = Get start time of interval: 3, i.o
      end.wd = Get end time of interval: 3, i.o
      mid.wd = (start.wd + end.wd)/2
      if mid.wd>=start.utt and mid.wd<=end.utt
        lab.ortho$ = Get label of interval: 3, i.o
        if lab.ortho$<>""
          if label$ = ""
            label$ = lab.ortho$
          else
            label$ = label$ + " " + lab.ortho$
          endif
        endif
      endif
    endfor

    last.char$ = right$(lab.utt$, 1)
    if last.char$<>"?"
      label$ = label$ + " ."
    else
      label$ = label$ + " ?"
    endif

    Set interval text: 1, i.u, label$

  endif
endfor

select TextGrid 'filename1$'
Remove tier: 6
Remove tier: 7
Remove tier: 10
Remove tier: 11
Remove tier: 12
Remove tier: 12

Set tier name: 3, "WORD-Ortho-1"
Set tier name: 4, "WORD-Jyutping-1"
Set tier name: 5, "WORD-CitIPA-1"
Set tier name: 6, "WORD-ActIPA-1"
Set tier name: 7, "SYLL-Ortho-1"
Set tier name: 8, "SYLL-Jyutping-1"
Set tier name: 9, "SYLL-CitIPA-1"
Set tier name: 10, "SYLL-ActIPA-1"
Set tier name: 11, "PHON-Phoneme-1"


selectObject: "TextGrid 'filename1$'"
plusObject: "TextGrid CHI"
Merge

Insert interval tier: 13, "WORD-Ortho-2"
Insert interval tier: 14, "WORD-Jyutping-2"
Insert interval tier: 15, "WORD-CitIPA-2"
Insert interval tier: 16, "WORD-ActIPA-2"
Insert interval tier: 17, "SYLL-Ortho-2"
Insert interval tier: 18, "SYLL-Jyutping-2"
Insert interval tier: 19, "SYLL-CitIPA-2"
Insert interval tier: 20, "SYLL-ActIPA-2"
Insert interval tier: 21, "PHON-Phoneme-2"

Rename: filename.new$

Duplicate tier: 11, 12, "PHON-Unchecked-1"

Save as text file: fileout$
