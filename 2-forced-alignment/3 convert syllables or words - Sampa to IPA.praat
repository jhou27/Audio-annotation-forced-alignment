form Read list
optionmenu analysis.type 1
option syllables
option words
word ref.file SPPAS-transcription-key
word ref.file2 diphthong-reference
word dir /Users/aclyu/Downloads/SCOLAR-tools/2-forced-alignment
word ref.dir /Users/aclyu/Downloads/SCOLAR-tools/ref-files
optionmenu check.items 2
option yes
option no
optionmenu do.tier1 1
option yes
option no
optionmenu do.tier2 1
option yes
option no
optionmenu do.tier3 1
option yes
option no
optionmenu do.tier4 1
option yes
option no
optionmenu do.tier5 1
option yes
option no
endform

list.name$ = "file_list"
in.files.path$ = dir$ + "/*_" + analysis.type$ + "-palign.TextGrid"
Create Strings as file list: list.name$, in.files.path$

ref.path$ = ref.dir$ + "/" + ref.file$ + ".txt"
Read Table from tab-separated file: ref.path$

ref.path2$ = ref.dir$ + "/" + ref.file2$ + ".txt"
Read Table from tab-separated file: ref.path2$

nchar.type = length(analysis.type$)

selectObject: "Strings "+list.name$
no.files = Get number of strings
for file from 1 to no.files
  selectObject: "Strings "+list.name$
  palign.file$ = Get string: file
  filename$ = left$(palign.file$, index(palign.file$,".")-1)
  filename2$ = left$(palign.file$, index(palign.file$,"_")+nchar.type)
  tg.in$ = filename2$ + "-merge"
  tg.in.path$ = dir$ + "/" + tg.in$ + ".TextGrid"
  Read from file... 'tg.in.path$'
  tg.out$ = filename2$ + "-transcribed"
  tg.out.path$ = dir$ + "/" + tg.out$ + ".TextGrid"

  select TextGrid 'tg.in$'
  Copy: tg.in$
  Rename: tg.out$
  select TextGrid 'tg.out$'
  no.tiers.tg.in = Get number of tiers
  Remove tier: 1
  if no.tiers.tg.in>7
    Remove tier: 2
    Remove tier: 2
    Remove tier: 2
    Remove tier: 2
  endif
  Remove tier: 5
  Duplicate tier: 2, 5, "PHON-Phone"
  Remove tier: 2
  Set tier name: 1, "Utterance"
  Set tier name: 2, "TokensOrtho"
  Set tier name: 3, "TokensIPA"
  Insert interval tier: 5, "PHON-Phoneme"
  fileout$ = tg.out.path$

  if do ("Is interval tier..." , 3)
   no.ints = Get number of intervals... 3
   for int from 1 to no.ints
      label$ = Get label of interval... 3 int
      name$ = left$(label$, index(label$,"=")-1)
      Set interval text: 3, int, name$
   endfor
   endif

  if ('do.tier1' = 1)
    select TextGrid 'tg.out$'
   no.ints = Get number of intervals... 1
    for int from 1 to no.ints
      select TextGrid 'tg.out$'
      label$ = Get label of interval... 1 int
      if label$="#" or label$="+"
        Set interval text: 1, int, ""
      endif
    endfor
  endif

  if ('do.tier2' = 1)
    select TextGrid 'tg.out$'
    no.ints = Get number of intervals... 2
    for int from 1 to no.ints
      select TextGrid 'tg.out$'
      label$ = Get label of interval... 2 int
      if label$="#" or label$="+"
        Set interval text: 2, int, ""
      endif
    endfor
  endif

  if ('do.tier3' = 1)
    select TextGrid 'tg.out$'
    no.ints = Get number of intervals... 3
    for int from 1 to no.ints
      select TextGrid 'tg.out$'
      label$ = Get label of interval... 3 int
      if label$="#" or label$="+"
        Set interval text: 3, int, ""
      elsif label$<>""
        lab.working$ = label$
        lab.length = length(lab.working$)
        lab.ipa$ = ""
        while lab.length>0
          if index(lab.working$, "-") = 0
            if ('check.items' = 1)
              print 'label$'('int'):'ph.sampa$''newline$'
            endif
            ph.sampa$ = lab.working$
            select Table 'ref.file$'
            ref.row = Search column: "SPPAS", ph.sampa$
            ph.ipa$ = Get value: ref.row, "IPA"
            lab.ipa$ = lab.ipa$ + ph.ipa$
            lab.working$ = ""
          else
            ind = index(lab.working$, "-")
            if ('check.items' = 1)
              print 'label$'('int'):'ph.sampa$''newline$'
            endif
            ph.sampa$ = left$(lab.working$, ind-1)
            select Table 'ref.file$'
            ref.row = Search column: "SPPAS", ph.sampa$
            ph.ipa$ = Get value: ref.row, "IPA"
            lab.ipa$ = lab.ipa$ + ph.ipa$
            lab.working$ = right$(lab.working$, lab.length-ind)
          endif
          lab.length = length(lab.working$)
        endwhile
        select TextGrid 'tg.out$'
        Set interval text: 3, int, lab.ipa$
      endif
    endfor
  endif

  if ('do.tier4' = 1)
    select TextGrid 'tg.out$'
    no.ints = Get number of intervals... 4
    for int from 1 to no.ints
      select TextGrid 'tg.out$'
      label$ = Get label of interval... 4 int
      if label$="#" or label$="+"
        Set interval text: 4, int, ""
      elsif label$<>""
        select Table 'ref.file$'
        ref.row = Search column: "SPPAS", label$
        ipa$ = Get value: ref.row, "IPA"
        select TextGrid 'tg.out$'
        Set interval text: 4, int, ipa$
      endif
    endfor
  endif

  if ('do.tier5' = 1)
    select TextGrid 'tg.out$'
    no.ints = Get number of intervals... 4
    skip = 0
    int.phoneme = 0
    for int.phone from 1 to no.ints-1
      if skip<>1
        int.phoneme = int.phoneme + 1
        select TextGrid 'tg.out$'
        label$ = Get label of interval... 4 int.phone
        if label$="#" or label$="+" or label$=""
          t.right = Get end time of interval... 4 int.phone
          Insert boundary: 5, t.right
        elsif label$<>""
          label.next$ = Get label of interval... 4 int.phone+1
          bigram$ = label$ + label.next$
          select Table 'ref.file2$'
          ref.row2 = Search column: "IPA", bigram$
          if ref.row2>0
            select Table 'ref.file2$'
            ipa$ = Get value: ref.row2, "IPA"
            select TextGrid 'tg.out$'
            t.right = Get end time of interval... 4 int.phone+1
            Insert boundary: 5, t.right
            Set interval text: 5, int.phoneme, ipa$
            skip = 1
          else
            ipa$ = label$
            select TextGrid 'tg.out$'
            t.right = Get end time of interval... 4 int.phone
            Insert boundary: 5, t.right
            Set interval text: 5, int.phoneme, ipa$
          endif
        endif
      else
        skip = 0
      endif
    endfor
  endif

  select TextGrid 'tg.out$'
  Duplicate tier: 4, 6, "PHON-Phone"
  Remove tier: 4

  Save as text file: fileout$
endfor
