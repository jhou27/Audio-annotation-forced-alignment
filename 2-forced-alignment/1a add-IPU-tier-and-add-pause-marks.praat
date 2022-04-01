form Read list
word filename s101alf
word dir /Users/aclyu/Downloads/SCOLAR-tools/2-forced-alignment
endform

tg.path$ = dir$ + "/" + filename$ + ".TextGrid"
Read from file... 'tg.path$'
no.ints = Get number of intervals... 1

tg.backup$ = filename$ + "-backup.TextGrid"
tg.backup.path$ = dir$ + "/" + tg.backup$
Save as text file: tg.backup.path$

select TextGrid 'filename$'
Set tier name: 1, "IPUs"
Duplicate tier: 1, 2, "Orthography"

fileout$ = tg.path$

ipu.no = 0

for int from 1 to no.ints
  select TextGrid 'filename$'
  label$ = Get label of interval... 1 int
  if label$="" or label$="#"
    Set interval text: 1, int, "#"
    Set interval text: 2, int, "#"
  else
    ipu.no = ipu.no + 1
    ipu.label$ = "ipu_" + string$(ipu.no)
    Set interval text: 1, int, ipu.label$
    loc = index(label$, ",")
    if loc=0
      label.new$ = label$
    else
      label.new$ = ""
      tail$ = label$
      while loc<>0
        head$ = left$(tail$,loc-1)
        if label.new$=""
          label.new$ = head$
        else
          label.new$ = label.new$ + "+" + head$
        endif
        tail$ = right$(tail$,length(tail$)-loc)
        loc = index(tail$, ",")
        if loc=0
          label.new$ = label.new$ + "+" + tail$
        endif
      endwhile
    endif

#    label.new$ = "+" + label$ + "+"
    Set interval text: 2, int, label.new$
  endif
endfor

Save as text file: fileout$
