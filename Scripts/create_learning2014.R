#Script for creating practice data "Learning2014" for assignment 2
#Henri V 04/11/23

#As I use some parts of my own workflow, first we check that you have the needed package "here" for it.

if (!require(here) == T) {
  install.packages("here")
}

if (!require(tidyverse) == T) {
  install.packages("tidyverse")
}

#Load the needed packages, that were installed above if they already weren't
library(tidyverse)
library(here)

#Data retrieval

lrn14 <-
  read.table(
    "http://www.helsinki.fi/~kvehkala/JYTmooc/JYTOPKYS3-data.txt",
    sep = "\t",
    header = TRUE
  )

#Dimensions
dim(lrn14) #183 observations in 60 vars. Basically a redundant row as output of str(lrn14) also shows these.

#Structure
str(lrn14) #Mainly integers, just one string variable

Complete_data <-
  filter(lrn14, complete.cases(lrn14))  #Check for NAs. Filters only those rows for which no NAs exist on any of the variables.
Complete_data %>% dim()  #Exactly the same dims, no NA issues

#Creating combination variables and scaling them.
#Contents of each are Defined in exercise 2.

deep_questions <-
  c("D03",
    "D11",
    "D19",
    "D27",
    "D07",
    "D14",
    "D22",
    "D30",
    "D06",
    "D15",
    "D23",
    "D31")
surface_questions <-
  c(
    "SU02",
    "SU10",
    "SU18",
    "SU26",
    "SU05",
    "SU13",
    "SU21",
    "SU29",
    "SU08",
    "SU16",
    "SU24",
    "SU32"
  )
strategic_questions <-
  c("ST01", "ST09", "ST17", "ST25", "ST04", "ST12", "ST20", "ST28")

# select the columns related to deep learning
deep_columns <- select(lrn14, all_of(deep_questions))
# and create column 'deep' by averaging
lrn14$deep <- rowMeans(deep_columns)

# select the columns related to surface learning
surface_columns <- select(lrn14, all_of(surface_questions))
# and create column 'surf' by averaging
lrn14$surf <- rowMeans(surface_columns)

# select the columns related to strategic learning
strategic_columns <- select(lrn14, all_of(strategic_questions))
# and create column 'stra' by averaging

lrn14$stra <- rowMeans(strategic_columns)

#Select only the desired variables, filter only those for which Points > 0 in the same pipe.

Keepers <-
  c("gender", "Age", "Attitude", "deep", "stra", "surf", "Points")

lrn14 <- lrn14 %>% select(Keepers) %>% filter(Points > 0)
str(lrn14) #166 obs, 7 vars, as required. All variables present

#Set working directory

setwd("E:/R_projektikansio/IODS-project") #Not really needed if you specify the path via "here" syntax. But worth some course points so I'll leave it.

#Save output as csv

write.csv(lrn14, file = here("Data/learning2014.csv"), row.names = F) #Remember to tick row names as false, otherwise you get an additional "running numbering" column. 

#Double check that all went fine

str(read_csv(here("Data/learning2014.csv")))

head(read_csv(here("Data/learning2014.csv")))

#Same structure.

gc()
rm(list=ls())
