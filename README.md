# Star Wars Characters: Data Cleaning & Exploration

A beginner R project practicing data cleaning, summarization, and visualization using the `starwars` dataset — character data (height, mass, species, homeworld, films, etc.) from the Star Wars films, built into the `dplyr` package.

## What this project does

1. Loads and inspects the raw dataset
2. Cleans missing values in `height`, `mass`, and other columns
3. Handles the tricky list-columns (`films`, `vehicles`, `starships`) — e.g. counting how many films each character appears in
4. Summarizes key stats (by species and homeworld) using `dplyr`
5. Produces four `ggplot2` visualizations exploring height, mass, species, and film appearances
6. Saves the plots as image files

## Files

- `analysis.R` — the full script, organized into commented sections
- `outputs/` — generated plots (created when you run the script)

## Setup

Open `analysis.R` in RStudio and install the required packages if you don't have them:

```r
install.packages(c("dplyr", "ggplot2", "tidyr"))
```

Then run the script top to bottom (Ctrl/Cmd + Shift + Enter to run all, or step through chunk by chunk).

## What I practiced

- Reading and inspecting a data frame (`str()`, `summary()`, `glimpse()`)
- Handling missing values (`is.na()`, `drop_na()`)
- Working with list-columns (a quirk specific to this dataset)
- Grouping and summarizing (`group_by()`, `summarize()`)
- Writing and saving `ggplot2` visualizations

## Possible next steps

- Explore relationships between species and homeworld
- Add a simple model predicting mass from height
- Turn this into an R Markdown report that renders to HTML

## Dataset source

`starwars` dataset, built into the [`dplyr`](https://dplyr.tidyverse.org/reference/starwars.html) package, originally sourced from the [SWAPI](https://swapi.dev/) API.
