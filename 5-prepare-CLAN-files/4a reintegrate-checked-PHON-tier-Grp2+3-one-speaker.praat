form Read list
word speaker s203
word extension alf
word main_directory D:/Data/CDS-corpus/SCOLAR-tools/audio-files
word out_directory D:/Data/CDS-corpus/SCOLAR-tools/5-prepare-CLAN-files
endform

dir$ = main_directory$ + "/" + speaker$

filename1$ = speaker$ + extension$ + "-CLAN-unchecked"
filename2$ = speaker$ + extension$ + "-CLAN-checked"
filename.new$ = speaker$ + extension$ + "-CLAN"

tg.path1$ = dir$ + "/" + filename1$ + ".TextGrid"
Read from file... 'tg.path1$'

tg.path2$ = dir$ + "/" + filename2$ + ".TextGrid"
Read from file... 'tg.path2$'

fileout$ = out_directory$ + "/" + filename.new$ + ".TextGrid"

select TextGrid 'filename2$'
Duplicate tier: 3, 6, "WORD-ActIPA-1"
Duplicate tier: 7, 10, "SYLL-ActIPA-1"

act.syll.tier = 10
act.wd.tier = 6
act.phon.tier = 11

no.ints.syll = Get number of intervals: act.syll.tier
no.ints.wd = Get number of intervals: act.wd.tier

for syll.int from 1 to no.ints.syll
  lab$ = Get label of interval: act.syll.tier, syll.int
  if lab$<>""
    t.ons = Get start time of interval: act.syll.tier, syll.int
    t.off = Get end time of interval: act.syll.tier, syll.int
    phon.int.ons = Get high interval at time: act.phon.tier, t.ons
    phon.int.off = Get low interval at time: act.phon.tier, t.off
    syll.phon$ = ""
    for phon.int from phon.int.ons to phon.int.off
      phon.add$ = Get label of interval: act.phon.tier, phon.int
      syll.phon$ = syll.phon$ + phon.add$
    endfor
    Set interval text: act.syll.tier, syll.int, syll.phon$
  endif
endfor


for wd.int from 1 to no.ints.wd
  lab$ = Get label of interval: act.wd.tier, wd.int
  if lab$<>""
    t.ons = Get start time of interval: act.wd.tier, wd.int
    t.off = Get end time of interval: act.wd.tier, wd.int
    syll.int.ons = Get high interval at time: act.syll.tier, t.ons
    syll.int.off = Get low interval at time: act.syll.tier, t.off
    wd.phon$ = ""
    for syll.int from syll.int.ons to syll.int.off
      phon.add$ = Get label of interval: act.syll.tier, syll.int
      if wd.phon$ = ""
        wd.phon$ = phon.add$
      else
        wd.phon$ = wd.phon$ + "." + phon.add$
      endif
    endfor
    Set interval text: act.wd.tier, wd.int, wd.phon$
  endif
endfor


select TextGrid 'filename1$'
Set tier name: 12, "PHON-Phoneme-PreCor-1"
Extract one tier: 12
select TextGrid 'filename2$'
plus TextGrid PHON-Phoneme-PreCor-1
Merge

Rename: filename.new$

Save as text file: fileout$


