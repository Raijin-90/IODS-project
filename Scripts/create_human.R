require(tidyverse);require(here);require(readr)

#HV 21/11/23
#Data wrangling for next week

#Assingment 4 does not in itself include any data wrangling steps. All the data input in this task is done via the data() function to get to the boston dataset.
#Usage of this function is shown in the course diary under data overview. 
#As such, I will be providing this script instead as the "Data wrangling" deliverable for peer assessment.  


library(readr)
hd <- read_csv("https://raw.githubusercontent.com/KimmoVehkalahti/Helsinki-Open-Data-Science/master/datasets/human_development.csv")

summary(hd) #summary
str(hd) #structure
dim(hd) #dimensions


gii <- read_csv("https://raw.githubusercontent.com/KimmoVehkalahti/Helsinki-Open-Data-Science/master/datasets/gender_inequality.csv", na = "..")

summary(gii) #summary
str(gii) #structure
dim(gii) #dimensions


#Metadata here: https://hdr.undp.org/data-center/documentation-and-downloads. Shows what every abbreviation originally was...
#Multiple long, phrase form var names. Let's make them single objects that can be selected with 1 click.

colnames(hd)
colnames(hd)<-c("HDI_Rank","Country","HDI","LifeExp","EduExp","EduMean","GNI","GNI_minus_HDIrank")


colnames(gii)
colnames(gii)<-c("GII_Rank", "Country", "GII", "MMRatio", "ABRate", "PRP", "PSECED_F", "PSECED_M", "LFPR_F", "LFPR_M")


#Mutate the “Gender inequality” data and create two new variables. 
#The first new variable should be the ratio of female and male populations with secondary education in each country (i.e., Edu2.F / Edu2.M). 
#The second new variable should be the ratio of labor force participation of females and males in each country (i.e., Labo.F / Labo.M). (1 point)


library(tidyverse)
gii<-gii %>% mutate(PSECED_FM_Ratio = PSECED_F/PSECED_M,
                    LaborFM_ratio = LFPR_F/LFPR_M)

#Merging gii and hd by country

Human<-inner_join(hd, gii, by="Country")

write.csv(Human, file=here("Data/human.csv"))


