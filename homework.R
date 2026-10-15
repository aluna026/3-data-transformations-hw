# Aylin Luna
# PSYC 259 Homework 3 - Data Transformation
# For full credit, provide answers for at least 7/11

# List names of students collaborating with:

### SETUP: RUN THIS BEFORE STARTING ----------

# Load packages
library(tidyverse)
ds <- read_csv("data_raw/rolling_stone_500.csv")

### Question 1 ----------

# Use a function to check the class of all of the variables in 'ds'
# Convert "Year" to a numeric, saving it back to 'ds'
# Use a function to check that your conversion succeeded

# ANSWER
glimpse(ds)
# character, numeric (double)

class(ds$Year) # it's a character

ds$Year <- as.numeric(ds$Year) # changing Year to numeric
class(ds$Year) # checking to see if Year actually is numeric now

### Question 2 ----------

# Using a dplyr function,
# change ds so that all of the variables are lowercase

# ANSWER
ds <- ds %>% rename_with(tolower) # changes variable/column names from "Rank", "Song", and "Artist" to lower case

### Question 3 ----------

# Use mutate to create a new variable in ds that has the decade of the year as a number
# For example, 1971 would become 1970, 2001 would become 2000
# Hint: read the documentation for ?floor and make sure year is numeric (from Question 1)

# ANSWER
glimpse(ds)
class(ds$year) # year is a numeric (double)
ds <- mutate(ds, decade = floor(year / 10) * 10)
# creating a decade column by dividing the year by 10 and taking the whole number and multiplying by 10

### Question 4 ----------

# Sort the dataset by rank so that 1 is at the top

# ANSWER
ds <- arrange(ds, rank)

### Question 5 ----------

# Use filter and select to create a new tibble called 'top10'
# That just has the artists and songs for the top 10 songs

# ANSWER
top10 <- ds %>%
  filter(rank <= 10) %>%
  select(c("artist", "song"))
# filtering to include only the top 10 ranked songs and then selecting only the artist and song columns to appear


### Question 6 ----------

# Use summarize to find the earliest, most recent, and average release year
# and save the results to a new tibble called "ds_sum"
# Hint, the function drop_na() might help. Read ?drop_na

# ANSWER
ds_sum <- ds %>%
  drop_na() %>%
  summarize(
    max_year = max(year),
    min_year = min(year),
    mean_year = mean(year)
  )
ds_sum # to view ds_sum

### Question 7 ----------

# Use filter on the original dataset 'ds' to find all of the artists/song titles from
# the min/max/mean years that you identified in 'ds_sum'
# Use one filter command only, and sort the responses by year
# Bonus: find a way to do it without hard coding the years (i.e. pull them from ds_sum)
# (this might take some searching to find functions that will help)

# ANSWER
ds %>%
  filter(year %in% ds_sum) %>%
  arrange(year)

### Question 8 ----------

# There's an error here. The oldest song "Brass in Pocket"
# is from 1979! Use mutate and ifelse to fix the error in 'ds'
# then recalculate decade, and then
# recalculate the responses from Questions 6-7 to
# find the correct oldest, averag-ist, and most recent songs

# ANSWER
ds <- ds %>%
  mutate(year = if_else(year == 1879, 1979, year))

# unsure if it's good practice to add the code again here to show I'm re-running it or if its okay to 
# just go back and run the code in questions 6-7
ds <- mutate(ds, decade = floor(year / 10) * 10)

ds_sum <- ds %>%
  drop_na() %>%
  summarize(
    max_year = max(year),
    min_year = min(year),
    mean_year = mean(year)
  )
ds_sum

ds %>%
  filter(year %in% ds_sum) %>%
  arrange(year)

### Question 9 ---------

# Use group_by and summarize to find the average rank and
# number of songs on the list by decade. To make things easier
# filter out the NA values from decade before summarizing
# You don't need to save the results anywhere
# Use the pipe %>% to string the commands together

# ANSWER
ds %>%
  drop_na(decade) %>%
  group_by(decade) %>%
  summarize(
    avg_rank = mean(rank),
    n_songs = n()
  )


### Question 10 --------

# Look up the dplyr "count" function
# Use it to count up the number of songs by decade
# Then use slice_max() to pull the row with the most songs
# Use the pipe %>% to string the commands together
# Check against your answers from Question 9 to make sure it matches

# ANSWER
ds %>% distinct(decade) # seeing how many actual unique decades there are in the dataset (10) to make sure my next code matches
ds %>% count(decade, name = "n_songs") %>% # first part counts n songs by each unique decade
  slice_max(n_songs) # this part pulls the row with the most songs (decade: 1970, which matches #9!)

### Question 11 ------
# Use RStudio's styler to style all the code in your homework
install.packages("styler")
library(styler)
