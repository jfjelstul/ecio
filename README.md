# ecio

An `R` package for the European Commission Internal Organization (ECIO) Database. The ECIO Database includes 12 datasets on the European Commission (1958-2021), including data on Commissioners (including their national parties and European political groups), departments (including Directorates-General and service departments), portfolio allocations (i.e., the portfolio assigned to each Commissioner), department allocations (i.e., which Commissioner was responsible for each department), and policy area allocations (i.e., which Commissioner was responsible for various policy areas). It also includes data on the historical evolution of Commission departments and on the mapping of policy areas to departments. The datasets are primarily hand-coded based on information from the official directories of the Commission and other official sources. 

## Installation

You can install the latest development version from GitHub:

```r
# install.packages("devtools")
devtools::install_github("jfjelstul/ecio")
```

## Documentation

The codebook for the database is included as a `tibble` in the package: `ecio::codebook`. The same documentation is also available in the `R` documentation for each dataset. For example, you can see the codebook for the `ecio::commissioners` dataset by running `?ecio::commissioners`. You can also read the documentation on the [package website](https://jfjelstul.github.io/ecio/). 

## Citation

If you use data from the `ecio` package in a project or paper, please cite the `R` package:

> Joshua Fjelstul (2021). ecio: The European Commission Internal Organization (ECIO) Database. R package version 0.1.0.9000.

The `BibTeX` entry for the package is:

```
@Manual{,
  title = {ecio: The European Commission Internal Organization (ECIO) Database},
  author = {Joshua Fjelstul},
  year = {2021},
  note = {R package version 0.1.0.9000},
}
```

## Problems

If you notice an error in the data or a bug in the `R` package, please report the error [here](https://github.com/jfjelstul/ecio/issues).
