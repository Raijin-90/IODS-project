
library(tidyverse); library(here)

#Henri V (11/11/2023)
# Data retrieval and modification script for Exercise 3
# Data sourced from: https://archive.ics.uci.edu/dataset/320/student+performance

# Wrangling ####

# Read data

Student_mat<-read.csv(here("Data/student-mat.csv"), sep=";")
Student_por<-read.csv(here("Data/student-por.csv"), sep=";")

# Dimensions and structure

str(Student_mat)
str(Student_por)

dim(Student_mat)
dim(Student_por)

# Define which vars will be used for merging the data
free_cols <- c("failures","paid","absences","G1","G2","G3")
join_cols <- setdiff(colnames(Student_por), free_cols)

mat_por<- inner_join(Student_mat, Student_por, by = join_cols, suffix = c(".math", ".por"))

rm(Student_mat,Student_por)

alc <- select(mat_por, all_of(join_cols))

#Duplicate removal

# print out the columns not used for joining (those that varied in the two data sets)

col_name<-print(free_cols)

# for every column name not used for joining...
for(col_name in free_cols) {
  # select two columns from 'math_por' with the same original name
  two_cols <- select(mat_por, starts_with(col_name))
  # select the first column vector of those two columns
  first_col <- select(two_cols, 1)[[1]]
  
  # then, enter the if-else structure!
  # if that first column vector is numeric...
  if(is.numeric(first_col)) {
    # take a rounded average of each row of the two columns and
    # add the resulting vector to the alc data frame
    alc[col_name] <- round(rowMeans(two_cols))
  } else { # else (if the first column vector was not numeric)...
    # add the first column vector to the alc data frame
    alc[col_name] <- "change me!"
  }
}

#Average the daily and weekly alc consumption

alc <- mutate(alc, alc_use = (Dalc + Walc) / 2)

#Based on this, create a boolean column differentiating those w. alc use > 2 from the others

alc <- mutate(alc, high_use = alc_use > 2)

#Check data and save 

glimpse(alc)

write_csv(mat_por ,here("Data/Data_assignment3.csv"))



