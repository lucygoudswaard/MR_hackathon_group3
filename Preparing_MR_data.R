## packages

library(data.table)
ifelse("devtools" %in% rownames(installed.packages()), 
       NA, 
       install.packages("devtools"))
devtools::install_github("hughesevoanth/moosefun")
if (!require("BiocManager", quietly = TRUE))
  install.packages("BiocManager")

BiocManager::install("biomaRt")

systolic <- fread("/user/home/lg14289/systolic_ukb_afr.tsv.gz")
diastolic <- fread("/user/home/lg14289/diastolic_ukb_afr.tsv.gz")

## Add chromosome position to both files. Effect allele needs to be first to match to UGR.
systolic$snpid <- paste0(systolic$chromosome, ":", systolic$base_pair_location, ":", systolic$other_allele, ":", systolic$effect_allele)
diastolic$snpid <- paste0(diastolic$chromosome, ":", diastolic$base_pair_location, ":", diastolic$other_allele, ":", diastolic$effect_allele )

## Read in UGR data
dat <- fread("/user/home/lg14289/restricted_eos_countannotated.txt.gz")

match <- systolic[,c("snpid", "variant_id")]
eos_sys <- merge(dat, match, by = "snpid")

match2 <- diastolic[,c("snpid", "variant_id")]
eos_dias <-  merge(dat, match2, by = "snpid")

# Combine and keep unique rows
eos_combined <- unique(rbind(eos_sys, eos_dias))
eos_combined <- tidyr::separate(eos_combined, snpid, into = c("chr","pos","ea","oa"), sep = ":")

#write.table(systolic, file = "/user/home/lg14289/systolic_5e-5.txt", sep = "\t", col.names = T, row.names = F)
#write.table(diastolic, file = "/user/home/lg14289/diastolic_5e-5.txt", sep = "\t", col.names = T, row.names = F)
#write.table(eos_combined, file = "/user/home/lg14289/eosinophil.txt", sep = "\t", col.names = T, row.names = F)
