####Importing Data in R

####Import CSV
cces_sample <-
  read.csv("/Users/haoqiwang/Desktop/2021REUDataScience/week1/cces_sample_coursera.csv")

####Write CSV
write.csv(cces_sample,
          "/Users/haoqiwang/Desktop/2021REUDataScience/week1/test.csv")

####type in your directory path in setwd() or use the Session-->Set Working Directory menu options

getwd()

setwd("/Users/haoqiwang/Desktop/2021REUDataScience/week1")

#### Don't need the whole file path now
cces_sample <- read.csv("cces_sample_coursera.csv")

class(cces_sample)

median(cces_sample$pew_religimp, na.rm = T)

table(cces_sample$race)
