# =============================================================
# Star Wars Characters: Data Cleaning & Exploration
# =============================================================
# A beginner practice project using the `starwars` dataset,
# which comes built into the dplyr package.

# -------------------------------------------------------------
# 0. Setup
# -------------------------------------------------------------
# install.packages(c("dplyr", "ggplot2", "tidyr"))

library(dplyr)
library(ggplot2)
library(tidyr)

# Create a folder to save our plots into
if (!dir.exists("outputs")) dir.create("outputs")

# -------------------------------------------------------------
# 1. Load and inspect the data
# -------------------------------------------------------------
data(starwars)

# Quick look at the structure and first few rows
glimpse(starwars)
head(starwars)

# How big is it, and what columns do we have?
dim(starwars)
colnames(starwars)

# Which columns have missing values, and how many?
colSums(is.na(starwars))

# -------------------------------------------------------------
# 2. Clean the data
# -------------------------------------------------------------
# height and mass have missing values -- for this project we'll
# keep rows but be careful to exclude NAs during calculations
# rather than dropping whole characters (we don't want to lose
# people just because one field is missing).

# mass has an extreme outlier (Jabba the Hutt) -- worth checking
starwars %>%
  arrange(desc(mass)) %>%
  select(name, mass) %>%
  head(3)

# films, vehicles, and starships are "list-columns" -- each cell
# holds a small vector instead of a single value. We can turn
# these into simple counts, which is much easier to work with.
starwars_clean <- starwars %>%
  mutate(
    n_films = lengths(films),
    n_vehicles = lengths(vehicles),
    n_starships = lengths(starships)
  )

# Confirm it worked
starwars_clean %>%
  select(name, n_films, n_vehicles, n_starships) %>%
  head()

# -------------------------------------------------------------
# 3. Summarize the data
# -------------------------------------------------------------
# Average height and mass by species (excluding NAs), for
# species with more than one character in the dataset
species_summary <- starwars_clean %>%
  filter(!is.na(species)) %>%
  group_by(species) %>%
  summarize(
    n = n(),
    avg_height = mean(height, na.rm = TRUE),
    avg_mass = mean(mass, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  filter(n > 1) %>%
  arrange(desc(n))

print(species_summary)

# Who appears in the most films?
starwars_clean %>%
  select(name, n_films) %>%
  arrange(desc(n_films)) %>%
  head(5)

# Homeworld counts
starwars_clean %>%
  filter(!is.na(homeworld)) %>%
  count(homeworld, sort = TRUE) %>%
  head(10)

# -------------------------------------------------------------
# 4. Visualize the data
# -------------------------------------------------------------

## Plot 1: Height vs. mass, colored by species (top species only)
top_species <- species_summary$species[1:5]

plot1 <- starwars_clean %>%
  filter(species %in% top_species) %>%
  ggplot(aes(x = height, y = mass, color = species)) +
  geom_point(size = 3, alpha = 0.8) +
  labs(
    title = "Height vs. Mass by Species",
    subtitle = "Top 5 most common species in the dataset",
    x = "Height (cm)",
    y = "Mass (kg)",
    color = "Species"
  ) +
  theme_minimal()

print(plot1)
ggsave("outputs/01_height_vs_mass.png", plot1, width = 7, height = 5)

## Plot 2: Distribution of height across all characters
plot2 <- starwars_clean %>%
  filter(!is.na(height)) %>%
  ggplot(aes(x = height)) +
  geom_histogram(binwidth = 10, fill = "steelblue", color = "white") +
  labs(
    title = "Distribution of Character Heights",
    x = "Height (cm)",
    y = "Count"
  ) +
  theme_minimal()

print(plot2)
ggsave("outputs/02_height_distribution.png", plot2, width = 7, height = 5)

## Plot 3: Number of characters per homeworld (top 10)
plot3 <- starwars_clean %>%
  filter(!is.na(homeworld)) %>%
  count(homeworld, sort = TRUE) %>%
  slice_head(n = 10) %>%
  ggplot(aes(x = reorder(homeworld, n), y = n)) +
  geom_col(fill = "darkorange") +
  coord_flip() +
  labs(
    title = "Top 10 Homeworlds by Character Count",
    x = "Homeworld",
    y = "Number of Characters"
  ) +
  theme_minimal()

print(plot3)
ggsave("outputs/03_top_homeworlds.png", plot3, width = 7, height = 5)

## Plot 4: Film appearances vs. species (top species only)
plot4 <- starwars_clean %>%
  filter(species %in% top_species) %>%
  ggplot(aes(x = species, y = n_films, fill = species)) +
  geom_boxplot(show.legend = FALSE) +
  labs(
    title = "Film Appearances by Species",
    x = "Species",
    y = "Number of Films Appeared In"
  ) +
  theme_minimal()

print(plot4)
ggsave("outputs/04_films_by_species.png", plot4, width = 7, height = 5)

# -------------------------------------------------------------
# 5. Wrap-up
# -------------------------------------------------------------
cat("\nAnalysis complete. Plots saved to the outputs/ folder.\n")
