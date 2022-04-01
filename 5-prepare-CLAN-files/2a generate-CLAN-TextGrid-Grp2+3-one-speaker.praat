form Read list
word speaker s303
word extension ali
word main_directory D:/Data/CDS-corpus/SCOLAR-tools/audio-files
endform

dir$ = main_directory$ + "/" + speaker$
out_directory$ = dir$

filename$ = speaker$ + extension$ + "-1-done"
filename.new$ = speaker$ + extension$ + "-CLAN-unchecked"

tg.path$ = dir$ + "/" + filename$ + ".TextGrid"
Read from file... 'tg.path$'

fileout$ = out_directory$ + "/" + filename.new$ + ".TextGrid"

select TextGrid 'filename$'
Duplicate tier: 1, 1, "MOT"
no.ints.utt = Get number of intervals: 2

for i.u from 1 to no.ints.utt
  select TextGrid 'filename$'
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
        if lab.ortho$ = ""
          if i.o<>int.ortho.end
            label$ = label$ + " (.)"
          endif
        else
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

select TextGrid 'filename$'
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

Rename: filename.new$

Duplicate tier: 11, 12, "PHON-Unchecked-1"

Save as text file: fileout$
