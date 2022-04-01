form Read list
word filename s101alf
word dir /Users/aclyu/Downloads/SCOLAR-tools/2-forced-alignment
endform

aud.path.in$ = dir$ + "/" + filename$ + ".wav"
Read from file... 'aud.path.in$'

tg.path.in$ = dir$ + "/" + filename$ + ".TextGrid"
Read from file... 'tg.path.in$'


file.out1$ = filename$ + "_syllables"
aud.path.out1$ = dir$ + "/" + file.out1$ + ".wav"
tg.path.out1$ = dir$ + "/" + file.out1$ + ".TextGrid"

file.out2$ = filename$ + "_words"
aud.path.out2$ = dir$ + "/" + file.out2$ + ".wav"
tg.path.out2$ = dir$ + "/" + file.out2$ + ".TextGrid"


select Sound 'filename$'
Copy: file.out1$
Save as WAV file: aud.path.out1$

select Sound 'filename$'
Copy: file.out2$
Save as WAV file: aud.path.out2$


select TextGrid 'filename$'
Copy: file.out1$
Save as text file: tg.path.out1$

select TextGrid 'filename$'
Copy: file.out2$
Save as text file: tg.path.out2$
