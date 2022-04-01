library(readr); library(stringr)

main.dir <- "/Users/aclyu/Downloads/SCOLAR-tools"
sppas.dir <- "/Users/aclyu/Downloads/SPPAS-3.6-2021-02-23"

in.dir <- paste(main.dir, "1-check-dictionaries", sep="/")

ref.names <- c("canto-pronunciation-dict.csv", "yue.vocab", "yue_chars.vocab", "yue-monosyllabic.dict", "yue-polysyllabic.dict")
ref.labels <- c("canto-pronunciation", "yue.vocab", "yue_chars.vocab", "yue-mono.dict", "yue-poly.dict")
for (n in 1:length(ref.names)) {
  ref.file <- ref.names[n]
  if (n==1) {
    ref.dir <- paste(main.dir, "ref-files", sep="/")
    ref.path <- paste(ref.dir, ref.file, sep="/")
    ref.dat <- read_csv(ref.path, col_names=T)
  } else if (n==2|n==3) {
    ref.dir <- paste(sppas.dir, "resources", "vocab", sep="/")
    ref.path <- paste(ref.dir, ref.file, sep="/")
    ref.dat <- read_tsv(ref.path, col_names=F)
  } else if (n==4|n==5) {
    ref.dir <- paste(sppas.dir, "resources", "dict", sep="/")
    ref.path <- paste(ref.dir, ref.file, sep="/")
    ref.dat <- read_tsv(ref.path, col_names=F)
    for (r in 1:nrow(ref.dat)) {
      row <- unlist(ref.dat[r, ])
      char <- strsplit(row, "\\s+")[[1]][1]
      ref.dat[r, "X2"] <- char
    }
  }
  assign(paste("ref.dat",n,sep=""),ref.dat)
}


latin.str <- "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890?.,"
latin <- strsplit(latin.str,"")[[1]]

num.str <- "123456"
numbers <- strsplit(num.str,"")[[1]]

dir.files <- list.files(in.dir)
files <- c()
recordings <- c()
for (f in dir.files) {
  if (substring(f,1,11)=="annotations") {
    rec <- substring(f,13,nchar(f)-4)
    files <- append(files, f)
    recordings <- append(recordings, rec)
  }
}

for (f in files) {
  rec <- recordings[match(f, files)]
  #in.file <- f
  in.file<-tools::file_path_sans_ext(f)
  in.file<-paste(in.file, '.csv',sep="")
  in.path <- paste(in.dir,in.file,sep="/")
  #dat <- read_tsv(in.path, col_names=T)
  dat<-read.csv(in.path)

  
  out.file <- paste("missing-chars-", rec, ".txt", sep="")
  #out.dir <- getwd()
  out.path <- paste(in.dir, out.file, sep="/")
  
  rows <- data.frame(matrix(nrow=0,ncol=5))
  names(rows) <- c("Character", "File", "TimeInFile", "IntervalNo", "Reference")
  
  for (r in 1:nrow(dat)) {
    line <- tolower(unlist(dat[r, "Utterance"]))
    line <- gsub("[[:punct:] ]+","",line)
    time <- unlist(dat[r, "Time"])
    int <- unlist(dat[r, "Interval"])
    rest <- line
    
    carryover <- ""
    while (!(rest=="")) {
      char <- substr(rest,1,1)
      char.next <- substr(rest,2,2)
      if (carryover=="yes") {
        char <- paste(char.prev,char,sep="")
      }
      if (nchar(char)==1 & !(char%in%latin)) {
        carryover <- "no"
      } else if (nchar(char)==1 & char%in%latin) {
        carryover <- "yes"
      # } else if (nchar(char)>1 & substr(char,nchar(char),nchar(char))%in%numbers) {
        # carryover <- "no"
      } else if (nchar(char)>1 & char.next%in%latin) {
        carryover <- "yes"
      } else if (nchar(char)>=1 & !(char.next%in%latin)) {
        carryover <- "no"
      }
      
      if (carryover=="no") {
        for (n in 1:length(ref.names)) {
          ref.dat <- get(paste("ref.dat",n,sep=""))
          if (n==1) {
            ref.rows <- ref.dat[ref.dat$Chinese==char, ]
          } else if (n==2|n==3) {
            ref.rows <- ref.dat[ref.dat$X1==char, ]
          } else if (n>=4) {
            ref.rows <- ref.dat[ref.dat$X2==char, ]
          }
          if (nrow(ref.rows)<1) {
            df.row <- data.frame(Character=char, File=rec, TimeInFile=time, IntervalNo=int, Reference=ref.labels[n])
            rows <- rbind(rows,df.row)
          }
        }
      }
      
      char.prev <- char
      rest <- substr(rest,2,nchar(rest))
    }
    
  }
  
  write_tsv(rows, path=out.path)
}

