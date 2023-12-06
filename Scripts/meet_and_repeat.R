library(here)
#Load BPRS and RATS data

BPRS<-read.table("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/BPRS.txt", header=T)

RATS<- read.table("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/rats.txt")


#Save the data as local backup
write.csv(RATS,file=here("Data/rats.csv"))
write.csv(BPRS, file=here("Data/BPRS.csv"))


#Summarize the data

str(BPRS);str(RATS)
dim(BPRS);dim(RATS)

colnames(BPRS);colnames(RATS)

summary(BPRS);summary(RATS)

head(BPRS);head(RATS)

#Factorize categorical variables

BPRS$treatment<-as.factor(BPRS$treatment)
BPRS$subject<-as.factor(BPRS$subject)

RATS$ID<-as.factor(RATS$ID)
RATS$Group<-as.factor(RATS$Group)

#Convert wideform data to longform
library(tidyverse)
BPRS_long<-pivot_longer(BPRS, cols=-c(treatment, subject), names_to = "weeks", values_to = "pbrs")

RATS_long<-pivot_longer(RATS, cols=-c(ID, Group), names_to = "WD", values_to = "Weight")


#Add var "Time" to RATS and "Week" to BPRS

RATS_long<-RATS_long %>% mutate(Time = as.integer(substr(WD, 3,4))) 

BPRS_long<-BPRS_long %>% mutate(Week = as.integer(substr(weeks,5,5)))




#Datas used to have dims of e.g.  40x11 for BPRS, i.e. very wide. Many variables. Few rows. 
#We just squeezed the week information from separate columns to rows, lengthening the whole thing into 360 obs and just 4 vars.
#This whole operation does not eliminate any information, just compresses the structure. Easily seen via e.g. the view command

#Let's visualize the difference in summaries:

str(BPRS)
str(BPRS_long)

dim(BPRS)
dim(BPRS_long)

str(RATS)
str(RATS_long)

dim(RATS)
dim(RATS_long)

summary(BPRS);summary(BPRS_long)
summary(RATS);summary(RATS_long)


#Save the longform data
write.csv(RATS,file=here("Data/rats_lng.csv"))
write.csv(BPRS, file=here("Data/BPRS_lng.csv"))




