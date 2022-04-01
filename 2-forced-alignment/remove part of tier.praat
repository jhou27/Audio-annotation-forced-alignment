
  if ('do.tier1' = 3)



   no.ints = Get number of intervals... 3
   for int from 1 to no.ints
      label$ = Get label of interval... 3 int
      name$ = left$(label$, index(label$,"=")-1)
      Set interval text: 3, int, name$
   endfor
    
