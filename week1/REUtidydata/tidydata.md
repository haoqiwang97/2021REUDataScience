Goal: talk about article [Tidy Data](https://www.jstatsoft.org/article/view/v059i10) by Hadley Wickham and learn tidy data.

## Why tidy data?  
Tidy datasets are easy to manipulate, model and visualize.  
It is often said that 80% of data analysis is spent on the process of cleaning and preparing
the data.


## What is tidy data?
> Happy families are all alike; every
unhappy family is unhappy in its own
way.  
>Leo Tolstoy

Like families, tidy datasets are all alike but every messy dataset is messy in its own way. Tidy datasets provide a standardized way to link the structure of a dataset (its physical layout) with its semantics (its meaning).

### Data structure
- Most statistical datasets are rectangular tables made up of rows and columns.
    - The columns are almost always labeled.
    - The rows are sometimes labeled.

Look at Table 1. The table has two columns and three rows, and both rows and columns are labeled.

|              | treatmenta | treatmentb |
|:-------------|-----------:|-----------:|
| John Smith   |         NA |         13 |
| Jane Doe     |         12 |          5 |
| Mary Johnson |          6 |         15 |

Table 1: Typical presentation dataset.

There are other ways to structure the same underlying data. Table 2 shows the same data as Table 1, but the rows and columns have been transposed. The data is the same, but the layout is different.

|            | John Smith | Jane Doe | Mary Johnson |
|:-----------|-----------:|---------:|-------------:|
| treatmenta |         NA |       12 |            6 |
| treatmentb |         13 |        5 |           15 |

Table 2: The same data as in Table 1 but structured differently.

Our vocabulary of rows and columns is simply not rich enough to describe why the two tables represent the same data.

### Data semantics
- A dataset is a collection of values.
    - numbers (if quantitative) 
    - strings (if qualitative)
- Every value belongs to a variable and an observation.
- A variable contains all values that measure the same underlying attribute (like height, temperature, duration) across units.
- An observation contains all values measured on the same unit (like a person, or a day, or a race) across attributes.

Table 3 reorganizes Table 1 to make the values, variables and observations more clear.

The dataset contains

- 18 values 
- 3 variables 
    - person, with three possible values (John Smith, Mary Johnson, and Jane Doe).
    - treatment, with two possible values (a and b).
    - result, with five or six values depending on how you think of the missing value (NA, 16, 3, 2, 11, 1).
- 6 observations
- Experimental design: every combination of person and treatment was measured (completely crossed design)


| name         | trt | result |
|:-------------|:----|-------:|
| John Smith   | a   |     NA |
| Jane Doe     | a   |     12 |
| Mary Johnson | a   |      6 |
| John Smith   | b   |     13 |
| Jane Doe     | b   |      5 |
| Mary Johnson | b   |     15 |

Table 3: The same data as in Table 1 but with variables in columns and
observations in rows.

It is diffcult to precisely define variables and observations in general.  
Example 1,  

- height and weight columns (2 variables)
- height and width columns (values of a **dimension** variable?)  

Example 2,  

- home phone and work phone variables
- phone number and number type variables?

Rule of thumb
- Functional relationships between variables (e.g., z is a linear combination
of x and y, density is the ratio of weight to volume)
- Make comparisons between groups of observations (e.g., average of group a vs. average of
group b) 

### Tidy data

#### Tidy data
1. Each variable forms a column.
2. Each observation forms a row.
3. Each type of observational unit forms a table.

#### Messy data  
Messy data is any other arrangement of the data.

Table 3 is the tidy version of Table 1. Each row represents an observation, the result of one
treatment on one person, and each column is a variable.

The layout ensures that values of different
variables from the same observation are always paired.

#### Order of variables and observations
While the order of variables and observations does not affect analysis, a good ordering makes
it easier to scan the raw values. Think the role of a variable in analysis: fixed by the design of the data collection, measured during the course of the experiment.

- Fixed variables describe the experimental design and are known in advance.
- Measured variables are what we actually measure in the study.
- Fixed variables should come first, followed by measured variables, each ordered so that
related variables are contiguous.


## Tidying messy datasets
Real datasets can, and often do, violate the three precepts of tidy data in almost every way
imaginable.

Tools: melting, string splitting, and casting.

### Column headers are values, not variable names
Table 4 shows a subset of a typical dataset of this form.  
This dataset explores the relationship
between income and religion in the US. It comes from a report produced by the Pew Research
Center, an American think-tank that collects data on attitudes to topics ranging from religion
to the internet, and produces many reports that contain datasets in this format.

This dataset has three variables, religion, income and frequency. To tidy it, we need to
melt, or stack it. In other words, we need to turn columns into rows.

Note: this arrangement can be called messy, while in come cases it can be extremely useful.

| religion                | &lt;$10k | $10–20k | $20–30k | $30–40k | $40–50k | $50–75k |
|:------------------------|---------:|--------:|--------:|--------:|--------:|--------:|
| Agnostic                |       27 |      34 |      60 |      81 |      76 |     137 |
| Atheist                 |       12 |      27 |      37 |      52 |      35 |      70 |
| Buddhist                |       27 |      21 |      30 |      34 |      33 |      58 |
| Catholic                |      418 |     617 |     732 |     670 |     638 |    1116 |
| Don’t know/refused      |       15 |      14 |      15 |      11 |      10 |      35 |
| Evangelical Prot        |      575 |     869 |    1064 |     982 |     881 |    1486 |
| Hindu                   |        1 |       9 |       7 |       9 |      11 |      34 |
| Historically Black Prot |      228 |     244 |     236 |     238 |     197 |     223 |
| Jehovah’s Witness       |       20 |      27 |      24 |      24 |      21 |      30 |
| Jewish                  |       19 |      19 |      25 |      25 |      30 |      95 |

Table 4: The first ten rows of data on income and religion from the Pew
Forum. Three columns, $75-100k, $100-150k and >150k, have been
omitted.

Melting is parameterized by a list of columns that are already variables, or `colvars`
for short.  
The other columns are converted into two variables: a new variable called `column` that contains repeated column headings and a new variable called `value` that contains the
concatenated data values from the previously separate columns.  
This is illustrated in Table 5
with a toy dataset. The result of melting is a molten dataset.


<table class="kable_wrapper">
<caption>
Table 5: A simple example of melting. Left is melted with one colvar,
row, yielding the molten dataset on the right. The information in each table is
exactly the same, just stored in a different way.
</caption>
<tbody>
<tr>
<td>

| row |   a |   b |   c |
|:----|----:|----:|----:|
| A   |   1 |   4 |   7 |
| B   |   2 |   5 |   8 |
| C   |   3 |   6 |   9 |

</td>
<td>

| row | column | value |
|:----|:-------|------:|
| A   | a      |     1 |
| B   | a      |     2 |
| C   | a      |     3 |
| A   | b      |     4 |
| B   | b      |     5 |
| C   | b      |     6 |
| A   | c      |     7 |
| B   | c      |     8 |
| C   | c      |     9 |

</td>
</tr>
</tbody>
</table>

The Pew dataset has one `colvar`, religion, and melting yields Table 6. 
To better reflect their roles in this dataset, the variable `column` has been renamed to income, and the `value` column to freq. 

This form is tidy because each column represents a variable and each row
represents an observation, in this case a demographic unit corresponding to a combination of
religion and income.

| religion | income             | freq |
|:---------|:-------------------|-----:|
| Agnostic | &lt;$10k           |   27 |
| Agnostic | $10–20k            |   34 |
| Agnostic | $20–30k            |   60 |
| Agnostic | $30–40k            |   81 |
| Agnostic | $40–50k            |   76 |
| Agnostic | $50–75k            |  137 |
| Agnostic | $75–100k           |  122 |
| Agnostic | $100–150k          |  109 |
| Agnostic | &gt;150k           |   84 |
| Agnostic | Don’t know/refused |   96 |

Table 6: The first ten rows of the tidied Pew survey dataset on income
and religion. The column has been renamed to income, and value to freq.

Another common use of this data format is to record regularly spaced observations over time.

For example, the Billboard dataset shown in Table 7 records the date a song first entered the
Billboard Top 100. It has variables for artist, track, date.entered, rank and week. The
rank in each week after it enters the top 100 is recorded in 75 columns, wk1 to wk75. If a song
is in the Top 100 for less than 75 weeks the remaining columns are filled with missing values.

This form of storage is not tidy, but it is useful for data entry. It reduces duplication since
otherwise each song in each week would need its own row, and song metadata like title and
artist would need to be repeated.

|     | year | artist         | track                 | time | date.entered | wk1 | wk2 | wk3 |
|:----|-----:|:---------------|:----------------------|:-----|:-------------|----:|----:|----:|
| 1   | 2000 | 2 Pac          | Baby Don’t Cry        | 4:22 | 2000-02-26   |  87 |  82 |  72 |
| 2   | 2000 | 2Ge+her        | The Hardest Part Of … | 3:15 | 2000-09-02   |  91 |  87 |  92 |
| 3   | 2000 | 3 Doors Down   | Kryptonite            | 3:53 | 2000-04-08   |  81 |  70 |  68 |
| 6   | 2000 | 98^0           | Give Me Just One Nig… | 3:24 | 2000-08-19   |  51 |  39 |  34 |
| 7   | 2000 | A\*Teens       | Dancing Queen         | 3:44 | 2000-07-08   |  97 |  97 |  96 |
| 8   | 2000 | Aaliyah        | I Don’t Wanna         | 4:15 | 2000-01-29   |  84 |  62 |  51 |
| 9   | 2000 | Aaliyah        | Try Again             | 4:03 | 2000-03-18   |  59 |  53 |  38 |
| 10  | 2000 | Adams, Yolanda | Open My Heart         | 5:30 | 2000-08-26   |  76 |  76 |  74 |

Table 7: The first eight Billboard top hits for 2000. Other columns not
shown are wk4, wk5, …, wk75.

This dataset has `colvars` year, artist, track, time, and date.entered. Melting yields
Table 8. `column` has been converted to week by extracting the number, and date has been computed from date.entered and week.

| year | artist       | time | track                 | date       | week | rank |
|-----:|:-------------|:-----|:----------------------|:-----------|-----:|-----:|
| 2000 | 2 Pac        | 4:22 | Baby Don’t Cry        | 2000-02-26 |    1 |   87 |
| 2000 | 2 Pac        | 4:22 | Baby Don’t Cry        | 2000-03-04 |    2 |   82 |
| 2000 | 2 Pac        | 4:22 | Baby Don’t Cry        | 2000-03-11 |    3 |   72 |
| 2000 | 2 Pac        | 4:22 | Baby Don’t Cry        | 2000-03-18 |    4 |   77 |
| 2000 | 2 Pac        | 4:22 | Baby Don’t Cry        | 2000-03-25 |    5 |   87 |
| 2000 | 2 Pac        | 4:22 | Baby Don’t Cry        | 2000-04-01 |    6 |   94 |
| 2000 | 2 Pac        | 4:22 | Baby Don’t Cry        | 2000-04-08 |    7 |   99 |
| 2000 | 2Ge+her      | 3:15 | The Hardest Part Of … | 2000-09-02 |    1 |   91 |
| 2000 | 2Ge+her      | 3:15 | The Hardest Part Of … | 2000-09-09 |    2 |   87 |
| 2000 | 2Ge+her      | 3:15 | The Hardest Part Of … | 2000-09-16 |    3 |   92 |
| 2000 | 3 Doors Down | 3:53 | Kryptonite            | 2000-04-08 |    1 |   81 |
| 2000 | 3 Doors Down | 3:53 | Kryptonite            | 2000-04-15 |    2 |   70 |
| 2000 | 3 Doors Down | 3:53 | Kryptonite            | 2000-04-22 |    3 |   68 |
| 2000 | 3 Doors Down | 3:53 | Kryptonite            | 2000-04-29 |    4 |   67 |
| 2000 | 3 Doors Down | 3:53 | Kryptonite            | 2000-05-06 |    5 |   66 |

Table 8: First fifteen rows of the tidied Billboard dataset. The date
column does not appear in the original table, but can be computed from
date.entered and week.

### Multiple variables stored in one column

After melting, the column variable names often becomes a combination of multiple underlying
variable names.

This is illustrated by the tuberculosis (TB) dataset, a sample of which is shown in Table 9.

This dataset comes from the World Health Organization, and records
the counts of confirmed tuberculosis cases by country, year, and demographic group. The
demographic groups are broken down by sex (m, f) and age (0-14, 15-25, 25-34, 35-44,
45-54, 55-64, unknown).

|     | country | year | m014 | m1524 | m2534 | m3544 | m4554 | m5564 | m65 |  mu | f014 |
|:----|:--------|-----:|-----:|------:|------:|------:|------:|------:|----:|----:|-----:|
| 11  | AD      | 2000 |    0 |     0 |     1 |     0 |     0 |     0 |   0 |  NA |   NA |
| 37  | AE      | 2000 |    2 |     4 |     4 |     6 |     5 |    12 |  10 |  NA |    3 |
| 61  | AF      | 2000 |   52 |   228 |   183 |   149 |   129 |    94 |  80 |  NA |   93 |
| 88  | AG      | 2000 |    0 |     0 |     0 |     0 |     0 |     0 |   1 |  NA |    1 |
| 137 | AL      | 2000 |    2 |    19 |    21 |    14 |    24 |    19 |  16 |  NA |    3 |
| 166 | AM      | 2000 |    2 |   152 |   130 |   131 |    63 |    26 |  21 |  NA |    1 |
| 179 | AN      | 2000 |    0 |     0 |     1 |     2 |     0 |     0 |   0 |  NA |    0 |
| 208 | AO      | 2000 |  186 |   999 |  1003 |   912 |   482 |   312 | 194 |  NA |  247 |
| 237 | AR      | 2000 |   97 |   278 |   594 |   402 |   419 |   368 | 330 |  NA |  121 |
| 266 | AS      | 2000 |   NA |    NA |    NA |    NA |     1 |     1 |  NA |  NA |   NA |

Table 9: Original TB dataset. Corresponding to each ‘m’ column for
males, there is also an ‘f’ column for females, f1524, f2534 and so on.
These are not shown to conserve space. Note the mixture of 0s and
missing values (NA). This is due to the data collection process and the
distinction is important for this dataset.

Table 10(a) shows the results of melting the TB dataset, and Table 10(b) shows the results
of splitting the single column column into two real variables: age and sex.

<table class="kable_wrapper">
<caption>
Table 10: Tidying the TB dataset requires first melting, and then
splitting the column column into two variables: sex and age.
</caption>
<tbody>
<tr>
<td>

| country | year | column | cases | sex | age   |
|:--------|-----:|:-------|------:|:----|:------|
| AD      | 2000 | m014   |     0 | m   | 0–14  |
| AD      | 2000 | m1524  |     0 | m   | 15–24 |
| AD      | 2000 | m2534  |     1 | m   | 25–34 |
| AD      | 2000 | m3544  |     0 | m   | 35–44 |
| AD      | 2000 | m4554  |     0 | m   | 45–54 |
| AD      | 2000 | m5564  |     0 | m   | 55–64 |
| AD      | 2000 | m65    |     0 | m   | 65+   |
| AE      | 2000 | m014   |     2 | m   | 0–14  |
| AE      | 2000 | m1524  |     4 | m   | 15–24 |
| AE      | 2000 | m2534  |     4 | m   | 25–34 |
| AE      | 2000 | m3544  |     6 | m   | 35–44 |
| AE      | 2000 | m4554  |     5 | m   | 45–54 |
| AE      | 2000 | m5564  |    12 | m   | 55–64 |
| AE      | 2000 | m65    |    10 | m   | 65+   |
| AE      | 2000 | f014   |     3 | f   | 0–14  |

(a) Molten data

</td>
<td>

| country | year | sex | age   | cases |
|:--------|-----:|:----|:------|------:|
| AD      | 2000 | m   | 0–14  |     0 |
| AD      | 2000 | m   | 15–24 |     0 |
| AD      | 2000 | m   | 25–34 |     1 |
| AD      | 2000 | m   | 35–44 |     0 |
| AD      | 2000 | m   | 45–54 |     0 |
| AD      | 2000 | m   | 55–64 |     0 |
| AD      | 2000 | m   | 65+   |     0 |
| AE      | 2000 | m   | 0–14  |     2 |
| AE      | 2000 | m   | 15–24 |     4 |
| AE      | 2000 | m   | 25–34 |     4 |
| AE      | 2000 | m   | 35–44 |     6 |
| AE      | 2000 | m   | 45–54 |     5 |
| AE      | 2000 | m   | 55–64 |    12 |
| AE      | 2000 | m   | 65+   |    10 |
| AE      | 2000 | f   | 0–14  |     3 |

(b) Tidy data

</td>
</tr>
</tbody>
</table>

### Variables are stored in both rows and columns

The most complicated form of messy data occurs when variables are stored in both rows and
columns. 

Table 11 shows daily weather data from the Global Historical Climatology Network
for one weather station (MX17004) in Mexico for 5 months in 2010.

It has variables in 

- individual columns (id, year, month)
- spread across columns (day, d1-d31) 
- spread across rows (tmin, tmax) (minimum and maximum temperature).
- The element column is not a variable; it stores the names of variables.

| id      | year | month | element |  d1 |   d2 |   d3 |  d4 |   d5 |  d6 |  d7 |  d8 |
|:--------|-----:|------:|:--------|----:|-----:|-----:|----:|-----:|----:|----:|----:|
| MX17004 | 2010 |     1 | tmax    |  NA |   NA |   NA |  NA |   NA |  NA |  NA |  NA |
| MX17004 | 2010 |     1 | tmin    |  NA |   NA |   NA |  NA |   NA |  NA |  NA |  NA |
| MX17004 | 2010 |     2 | tmax    |  NA | 27.3 | 24.1 |  NA |   NA |  NA |  NA |  NA |
| MX17004 | 2010 |     2 | tmin    |  NA | 14.4 | 14.4 |  NA |   NA |  NA |  NA |  NA |
| MX17004 | 2010 |     3 | tmax    |  NA |   NA |   NA |  NA | 32.1 |  NA |  NA |  NA |
| MX17004 | 2010 |     3 | tmin    |  NA |   NA |   NA |  NA | 14.2 |  NA |  NA |  NA |
| MX17004 | 2010 |     4 | tmax    |  NA |   NA |   NA |  NA |   NA |  NA |  NA |  NA |
| MX17004 | 2010 |     4 | tmin    |  NA |   NA |   NA |  NA |   NA |  NA |  NA |  NA |
| MX17004 | 2010 |     5 | tmax    |  NA |   NA |   NA |  NA |   NA |  NA |  NA |  NA |
| MX17004 | 2010 |     5 | tmin    |  NA |   NA |   NA |  NA |   NA |  NA |  NA |  NA |

Table 11: Original weather dataset. There is a column for each possible
day in the month. Columns d9 to d31 have been omitted to conserve space.

To tidy this dataset we first melt it with `colvars` id, year, month and the column that contains
variable names, element. This yields Table 12(a).

This dataset is mostly tidy, but we have two variables stored in rows: tmin and tmax, the
type of observation.
Fixing the issue with the type of observation requires the `cast`, or unstack, operation.

This performs the inverse of melting by rotating the element
variable back out into the columns (Table 12(b)). This form is tidy. There is one variable in
each column, and each row represents a day's observations.


<table class="kable_wrapper">
<caption>
Table 12: (a) Molten weather dataset. This is almost tidy, but instead
of values, the element column contains names of variables. Missing
values are dropped to conserve space. (b) Tidy weather dataset. Each row
represents the meteorological measurements for a single day. There are
two measured variables, minimum (tmin) and maximum (tmax) temperature;
all other variables are fixed.
</caption>
<tbody>
<tr>
<td>

| id      | date       | element | value |
|:--------|:-----------|:--------|------:|
| MX17004 | 2010-01-30 | tmax    |  27.8 |
| MX17004 | 2010-01-30 | tmin    |  14.5 |
| MX17004 | 2010-02-02 | tmax    |  27.3 |
| MX17004 | 2010-02-02 | tmin    |  14.4 |
| MX17004 | 2010-02-03 | tmax    |  24.1 |
| MX17004 | 2010-02-03 | tmin    |  14.4 |
| MX17004 | 2010-02-11 | tmax    |  29.7 |
| MX17004 | 2010-02-11 | tmin    |  13.4 |
| MX17004 | 2010-02-23 | tmax    |  29.9 |
| MX17004 | 2010-02-23 | tmin    |  10.7 |

(a) Molten data

</td>
<td>

| id      | date       | tmax | tmin |
|:--------|:-----------|-----:|-----:|
| MX17004 | 2010-01-30 | 27.8 | 14.5 |
| MX17004 | 2010-02-02 | 27.3 | 14.4 |
| MX17004 | 2010-02-03 | 24.1 | 14.4 |
| MX17004 | 2010-02-11 | 29.7 | 13.4 |
| MX17004 | 2010-02-23 | 29.9 | 10.7 |
| MX17004 | 2010-03-05 | 32.1 | 14.2 |
| MX17004 | 2010-03-10 | 34.5 | 16.8 |
| MX17004 | 2010-03-16 | 31.1 | 17.6 |
| MX17004 | 2010-04-27 | 36.3 | 16.7 |
| MX17004 | 2010-05-27 | 33.2 | 18.2 |

(b) Tidy data

</td>
</tr>
</tbody>
</table>

### Multiple types in one table

During tidying, each type of observational unit should be stored in its own table.

The Billboard dataset described in Table 8 actually contains observations on two types of
observational units: the song and its rank in each week. 

This manifests itself through the
duplication of facts about the song: artist and time are repeated for every song in each
week. 

The Billboard dataset needs to be broken down into two datasets: a song dataset
which stores artist, song name and time, and a ranking dataset which gives the rank of
the song in each week. 

| year | artist       | time | track                 | date       | week | rank |
|-----:|:-------------|:-----|:----------------------|:-----------|-----:|-----:|
| 2000 | 2 Pac        | 4:22 | Baby Don’t Cry        | 2000-02-26 |    1 |   87 |
| 2000 | 2 Pac        | 4:22 | Baby Don’t Cry        | 2000-03-04 |    2 |   82 |
| 2000 | 2 Pac        | 4:22 | Baby Don’t Cry        | 2000-03-11 |    3 |   72 |
| 2000 | 2 Pac        | 4:22 | Baby Don’t Cry        | 2000-03-18 |    4 |   77 |
| 2000 | 2 Pac        | 4:22 | Baby Don’t Cry        | 2000-03-25 |    5 |   87 |
| 2000 | 2 Pac        | 4:22 | Baby Don’t Cry        | 2000-04-01 |    6 |   94 |
| 2000 | 2 Pac        | 4:22 | Baby Don’t Cry        | 2000-04-08 |    7 |   99 |
| 2000 | 2Ge+her      | 3:15 | The Hardest Part Of … | 2000-09-02 |    1 |   91 |
| 2000 | 2Ge+her      | 3:15 | The Hardest Part Of … | 2000-09-09 |    2 |   87 |
| 2000 | 2Ge+her      | 3:15 | The Hardest Part Of … | 2000-09-16 |    3 |   92 |
| 2000 | 3 Doors Down | 3:53 | Kryptonite            | 2000-04-08 |    1 |   81 |
| 2000 | 3 Doors Down | 3:53 | Kryptonite            | 2000-04-15 |    2 |   70 |
| 2000 | 3 Doors Down | 3:53 | Kryptonite            | 2000-04-22 |    3 |   68 |
| 2000 | 3 Doors Down | 3:53 | Kryptonite            | 2000-04-29 |    4 |   67 |
| 2000 | 3 Doors Down | 3:53 | Kryptonite            | 2000-05-06 |    5 |   66 |

Table 8: First fifteen rows of the tidied Billboard dataset. The date
column does not appear in the original table, but can be computed from
date.entered and week.

Table 13 shows these two datasets. You could also imagine a week
dataset which would record background information about the week, maybe the total number
of songs sold or similar demographic information. 

<table class="kable_wrapper">
<caption>
Table 13: Normalized Billboard dataset split up into song dataset (left)
and rank dataset (right). First 15 rows of each dataset shown; genre
omitted from song dataset, week omitted from rank dataset.
</caption>
<tbody>
<tr>
<td>

|  id | artist              | track                 | time |
|----:|:--------------------|:----------------------|:-----|
|   1 | 2 Pac               | Baby Don’t Cry        | 4:22 |
|   2 | 2Ge+her             | The Hardest Part Of … | 3:15 |
|   3 | 3 Doors Down        | Kryptonite            | 3:53 |
|   4 | 3 Doors Down        | Loser                 | 4:24 |
|   5 | 504 Boyz            | Wobble Wobble         | 3:35 |
|   6 | 98^0                | Give Me Just One Nig… | 3:24 |
|   7 | A\*Teens            | Dancing Queen         | 3:44 |
|   8 | Aaliyah             | I Don’t Wanna         | 4:15 |
|   9 | Aaliyah             | Try Again             | 4:03 |
|  10 | Adams, Yolanda      | Open My Heart         | 5:30 |
|  11 | Adkins, Trace       | More                  | 3:05 |
|  12 | Aguilera, Christina | Come On Over Baby     | 3:38 |
|  13 | Aguilera, Christina | I Turn To You         | 4:00 |
|  14 | Aguilera, Christina | What A Girl Wants     | 3:18 |
|  15 | Alice Deejay        | Better Off Alone      | 6:50 |

</td>
<td>

|  id | date       | rank |
|----:|:-----------|-----:|
|   1 | 2000-02-26 |   87 |
|   1 | 2000-03-04 |   82 |
|   1 | 2000-03-11 |   72 |
|   1 | 2000-03-18 |   77 |
|   1 | 2000-03-25 |   87 |
|   1 | 2000-04-01 |   94 |
|   1 | 2000-04-08 |   99 |
|   2 | 2000-09-02 |   91 |
|   2 | 2000-09-09 |   87 |
|   2 | 2000-09-16 |   92 |
|   3 | 2000-04-08 |   81 |
|   3 | 2000-04-15 |   70 |
|   3 | 2000-04-22 |   68 |
|   3 | 2000-04-29 |   67 |
|   3 | 2000-05-06 |   66 |

</td>
</tr>
</tbody>
</table>

### One type in multiple tables
A single type of observational unit spread out over multiple tables or files.

These tables and files are often split up by another variable, so that each represents a single year, person, or location.

1. Read the files into a list of tables.
2. For each table, add a new column that records the original file name (because the file
name is often the value of an important variable).
3. Combine all tables into a single table.

#### List of tables 

140 yearly baby name tables provided by the US Social Security Administration and combines them into a single file.

Popularity in 1880

| Rank | Male name | Percent of<br>total males | Female name | Percent of<br>total females |
| ---- | --------- | ------------------------- | ----------- | --------------------------- |
|  |
| 1    | John      | 8.1546%                   | Mary        | 7.2383%                     |
| 2    | William   | 8.0507%                   | Anna        | 2.6679%                     |
| 3    | James     | 5.0060%                   | Emma        | 2.0521%                     |
| 4    | Charles   | 4.5169%                   | Elizabeth   | 1.9866%                     |
| 5    | George    | 4.3294%                   | Minnie      | 1.7888%                     |
| 6    | Frank     | 2.7382%                   | Margaret    | 1.6167%                     |
| 7    | Joseph    | 2.2230%                   | Ida         | 1.5081%                     |
| 8    | Thomas    | 2.1402%                   | Alice       | 1.4487%                     |
| 9    | Henry     | 2.0642%                   | Bertha      | 1.3524%                     |
| 10   | Robert    | 2.0397%                   | Sarah       | 1.3196%                     |

Popularity in 2020

| Rank | Male name | Percent of<br>total males | Female name | Percent of<br>total females |
| ---- | --------- | ------------------------- | ----------- | --------------------------- |
|  |
| 1    | Liam      | 1.0734%                   | Olivia      | 1.0014%                     |
| 2    | Noah      | 0.9966%                   | Emma        | 0.8898%                     |
| 3    | Oliver    | 0.7725%                   | Ava         | 0.7472%                     |
| 4    | Elijah    | 0.7117%                   | Charlotte   | 0.7426%                     |
| 5    | William   | 0.6848%                   | Sophia      | 0.7410%                     |
| 6    | James     | 0.6689%                   | Amelia      | 0.7255%                     |
| 7    | Benjamin  | 0.6627%                   | Isabella    | 0.6891%                     |
| 8    | Lucas     | 0.6160%                   | Mia         | 0.6372%                     |
| 9    | Henry     | 0.5845%                   | Evelyn      | 0.5394%                     |
| 10   | Alexander | 0.5543%                   | Harper      | 0.5013%                     |

#### Single table

Baby names

| year | name    | percent  | sex |
| ---- | ------- | -------- | --- |
| 1880 | John    | 0.081541 | boy |
| 1880 | William | 0.080511 | boy |
| 1880 | James   | 0.050057 | boy |
| 1880 | Charles | 0.045167 | boy |
| 1880 | George  | 0.043292 | boy |
| 1880 | Frank   | 0.02738  | boy |
| 1880 | Joseph  | 0.022229 | boy |
| 1880 | Thomas  | 0.021401 | boy |
| 1880 | Henry   | 0.020641 | boy |
| 1880 | Robert  | 0.020404 | boy |
| 1880 | Edward  | 0.019965 | boy |
| 1880 | Harry   | 0.018175 | boy |
| 1880 | Walter  | 0.014822 | boy |
| 1880 | Arthur  | 0.013504 | boy |

## Tidy tools
Tidy tools, tools that take tidy datasets as input and return tidy datasets as output.

### Manipulation
- Filter: subsetting or removing observations based on some condition.
- Transform: adding or modifying variables. These modifications can involve either a
single variable (e.g., log-transformation), or multiple variables (e.g., computing density
from weight and volume).
- Aggregate: collapsing multiple values into a single value (e.g., by summing or taking
means).
- Sort: changing the order of observations.

### Visualization
- base plot()
- ggplot2

### Modeling
- y ~ a + b + c * d

<!---
## Case study
The case study uses individual-level mortality data from Mexico. 
**The goal is to find causes of death with unusual temporal patterns within a day.** 
Figure 1 shows the temporal pattern,
the number of deaths per hour, for all causes of death. 

**Find the diseases that differ most from this pattern.**

![Figure 1: Temporal pattern of all causes of death.](week1/REUtidydata/tidydata_files/figure-gfm/figure1-1.png)



The full dataset has information on 539,530 deaths in Mexico in 2008 and 55 variables,
including the location and time of death, the cause of death, and demographics of the deceased.
Table 15 shows a small sample of the dataset, focusing on variables related to time of death
(year, month, day and hour), and cause of death (cod).

To achieve our goal of finding unusual temporal patterns, we do the following. 

First, we count
the number of deaths in each hour (hod) for each cause (cod). 

Then we remove missing (and hence uninformative for our purpose) values. This gives Table 16(a). 

To provide informative labels for disease, we next join the dataset to
the codes dataset, connected by the cod variable. This adds a new variable, disease, shown
in Table 16(b).

<table class="kable_wrapper">
<caption>
Table 16: A sample of four diseases and four hours from hod2 data frame.
</caption>
<tbody>
<tr>
<td>

|      | hod | cod | freq |
|:-----|----:|:----|-----:|
| 4638 |   8 | B16 |    4 |
| 4787 |   8 | E84 |    3 |
| 4852 |   8 | I21 | 2205 |
| 5028 |   8 | N18 |  315 |
| 5305 |   9 | B16 |    7 |
| 5473 |   9 | E84 |    1 |
| 5536 |   9 | I21 | 2209 |
| 5707 |   9 | N18 |  333 |
| 5994 |  10 | B16 |   10 |
| 6153 |  10 | E84 |    7 |
| 6217 |  10 | I21 | 2434 |
| 6392 |  10 | N18 |  343 |
| 6689 |  11 | B16 |    6 |
| 6856 |  11 | E84 |    3 |
| 6915 |  11 | I21 | 2128 |

a

</td>
<td>

|      | disease                     |
|:-----|:----------------------------|
| 4638 | Acute hepatitis B           |
| 4787 | Cystic fibrosis             |
| 4852 | Acute myocardial infarction |
| 5028 | Chronic renal failure       |
| 5305 | Acute hepatitis B           |
| 5473 | Cystic fibrosis             |
| 5536 | Acute myocardial infarction |
| 5707 | Chronic renal failure       |
| 5994 | Acute hepatitis B           |
| 6153 | Cystic fibrosis             |
| 6217 | Acute myocardial infarction |
| 6392 | Chronic renal failure       |
| 6689 | Acute hepatitis B           |
| 6856 | Cystic fibrosis             |
| 6915 | Acute myocardial infarction |

b

</td>
<td>

|      |   prop |
|:-----|-------:|
| 4638 | 0.0381 |
| 4787 | 0.0294 |
| 4852 | 0.0471 |
| 5028 | 0.0412 |
| 5305 | 0.0667 |
| 5473 | 0.0098 |
| 5536 | 0.0472 |
| 5707 | 0.0436 |
| 5994 | 0.0952 |
| 6153 | 0.0686 |
| 6217 | 0.0520 |
| 6392 | 0.0449 |
| 6689 | 0.0571 |
| 6856 | 0.0294 |
| 6915 | 0.0455 |

c

</td>
<td>

|      | freq\_all | prop\_all |
|:-----|----------:|----------:|
| 4638 |     21915 |    0.0427 |
| 4787 |     21915 |    0.0427 |
| 4852 |     21915 |    0.0427 |
| 5028 |     21915 |    0.0427 |
| 5305 |     22401 |    0.0436 |
| 5473 |     22401 |    0.0436 |
| 5536 |     22401 |    0.0436 |
| 5707 |     22401 |    0.0436 |
| 5994 |     24321 |    0.0474 |
| 6153 |     24321 |    0.0474 |
| 6217 |     24321 |    0.0474 |
| 6392 |     24321 |    0.0474 |
| 6689 |     23843 |    0.0465 |
| 6856 |     23843 |    0.0465 |
| 6915 |     23843 |    0.0465 |

d

</td>
</tr>
</tbody>
</table>

|       |  yod | mod | dod | hod | cod |
|:------|-----:|----:|----:|----:|:----|
| 11938 | 2008 |   1 |   1 |   1 | B20 |
| 13937 | 2008 |   1 |   2 |   4 | I67 |
| 15937 | 2008 |   1 |   3 |   8 | I50 |
| 17937 | 2008 |   1 |   4 |  12 | I50 |
| 19937 | 2008 |   1 |   5 |  16 | K70 |
| 21937 | 2008 |   1 |   6 |  18 | I21 |
| 23937 | 2008 |   1 |   7 |  20 | I21 |
| 25937 | 2008 |   1 |   8 |  NA | K74 |
| 27937 | 2008 |   1 |  10 |   5 | K74 |
| 29937 | 2008 |   1 |  11 |   9 | I21 |
| 31937 | 2008 |   1 |  12 |  15 | I25 |
| 33937 | 2008 |   1 |  13 |  20 | R54 |
| 35937 | 2008 |   1 |  15 |   2 | I61 |
| 37937 | 2008 |   1 |  16 |   7 | I21 |
| 39937 | 2008 |   1 |  17 |  13 | I21 |

Table 15: A sample of 16 rows and 5 columns from the original dataset of
539,530 rows and 55 columns.





![Figure 2: (a) Plot of n vs. deviation. Variability of deviation is
dominated by sample size: small samples have large variability. (b)
Log-log plot makes it easy to see the pattern of variation as well as
unusually high values. The blue line is a robust line of best
fit.](week1/REUtidydata/tidydata_files/figure-gfm/fig2-1.png)

![Figure 3: Residuals from a robust linear model predicting log(dist) by
log(n). Horizontal line at 1.5 shows threshold for further
exploration.](week1/REUtidydata/tidydata_files/figure-gfm/figure3-1.png)

![](week1/REUtidydata/tidydata_files/figure-gfm/unnamed-chunk-12-1.png)

![Figure 4: Causes of death with unusual temporal courses. Overall
hourly death rate shown in gray. (Top) Causes of death with more than
350 deaths over a year. (Bottom) Causes of death with fewer than 350
deaths. Note that the y-axes are on different
scales.](week1/REUtidydata/tidydata_files/figure-gfm/figure4-1.png)
-->