
#setwd("/fs/project/PCON0005/cankun/yutong_zhao")
library(stringr)
all_files <- list.files(path="log",pattern = "[12].out")
fastp_result <- matrix()
hisat2_result <- matrix()
for (i in 1:length(all_files)) {
  this_file <- all_files[i]
  this_name <- strsplit(this_file, "\\.")[[1]][1]
  lines <- readLines(paste("log/",this_file,sep = ""))
  split_line <- unlist(strsplit(lines, " "))
  
  fastp_index <- which(lines == "Read1 before filtering:")
  select_fastp_line_index <- c(1:4, 7:10, 13:16, 19:22, 25:30,32,34)
  select_fastp_line <- lines[fastp_index + select_fastp_line_index]
  select_fastp_line <- strsplit(select_fastp_line, ": ")
  select_fastp_line <- sapply(select_fastp_line, "[", 2)
  this_fastp_result <- data.frame(select_fastp_line)
  colnames(this_fastp_result) <- this_name
  fastp_result <- cbind(this_fastp_result, fastp_result)
  
  
  hisat2_index <- grep("fastp v0.20.0",lines)[1]
  select_hisat2_line_index <- c(1:5, 7:8, 10:14)
  select_hisat2_line <- lines[hisat2_index + select_hisat2_line_index]
  select_hisat2_align_rate <- lines[hisat2_index + 15]
  select_hisat2_align_rate <- sub("\\ .*","",select_hisat2_align_rate)
  hisat2_int <- str_extract(select_hisat2_line,"[0-9]+")
  hisat2_bracket <- regmatches(select_hisat2_line, gregexpr("(?=\\().*?(?<=\\))", select_hisat2_line, perl=T))
  
  this_hisat2_result <- paste(hisat2_int,hisat2_bracket)
  this_hisat2_result <- c(this_hisat2_result,select_hisat2_align_rate)
  this_hisat2_result <- str_replace(this_hisat2_result,"character\\(0\\)","")
  this_hisat2_result <- data.frame(this_hisat2_result)
  colnames(this_hisat2_result) <- this_name
  hisat2_result <- cbind(this_hisat2_result, hisat2_result)
  
}

fastp_result$fastp_result <- c("total reads","total bases","Q20 bases","Q30 bases",
                               "total reads","total bases","Q20 bases","Q30 bases",
                               "total reads","total bases","Q20 bases","Q30 bases",
                               "total reads","total bases","Q20 bases","Q30 bases",
                               "reads passed filter","reads failed due to low quality",
                               "reads failed due to too many N","reads failed due to too short",
                               "reads with adapter trimmed","bases trimmed due to adapters",
                               "Duplication rate","Insert size peak")
fastp_meta <- c(rep("Read1 before filtering",4),rep("Read2 before filtering",4),rep("Read1 after filtering",4),rep("Read2 after filtering",4),rep("Filtering result",8))
fastp_result <- cbind(fastp_result,fastp_meta)
fastp_result <- fastp_result[,seq(dim(fastp_result)[2],1)]
colnames(fastp_result)[1:2] <- c("fastp_category1","fastp_category2")


hisat2_result$hisat2_result <- c("total reads","paired reads,of these:","aligned concordantly 0 times","aligned concordantly exactly 1 time",
                                 "aligned concordantly >1 times","pairs aligned concordantly 0 times; of these:","aligned discordantly 1 time","pairs aligned 0 times concordantly or discordantly; of these:",
                                 "mates make up the pairs; of these:","aligned 0 times","aligned exactly 1 time","aligned >1 times",
                                 "overall alignment rate")

hisat2_result <- hisat2_result[,seq(dim(hisat2_result)[2],1)]
colnames(hisat2_result)[1] <- c("hisat2_category")

dir.create("result",showWarnings = F)
write.csv(hisat2_result,"result/reads_alignment_report.csv",row.names = F)

write.csv(fastp_result,"result/reads_quality_control_report.csv",row.names = F)

