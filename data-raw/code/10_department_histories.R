###########################################################################
# Joshua C. Fjelstul, Ph.D.
# ecio R package
###########################################################################

# define pipe
`%>%` <- magrittr::`%>%`

##################################################
# read in data
##################################################

# read in data
load("data/departments_by_commission.RData")

# department dtaa
load("data/departments.RData")

# drop departments that don't correspond to a current department
departments_by_commission <- dplyr::filter(departments_by_commission, current_department != "None")

# separate departments
departments_by_commission <- tidyr::separate_rows(departments_by_commission, current_department, sep = "; ")

# collapse by current department
department_histories <- departments_by_commission %>%
  dplyr::group_by(department, current_department) %>%
  dplyr::summarize(
    department_id = unique(department_id),
    department_type_id = unique(department_type_id),
    department_type = unique(department_type),
    department_code = stringr::str_c(unique(department_code), collapse = ", "),
    commissions = stringr::str_c(unique(commission), collapse = ", "),
    count_commissions = length(unique(commission)),
    start_date = min(start_date),
    end_date = max(end_date),
    .groups = "drop_last"
  ) %>%
  dplyr::ungroup()

# select variables
departments <- dplyr::select(
  departments,
  department, department_id, department_code,
  department_type_id, department_type
)

# rename variables
departments <- dplyr::rename(
  departments,
  current_department = department,
  current_department_id = department_id,
  current_department_code = department_code,
  current_department_type_id = department_type_id,
  current_department_type = department_type
)

# merge
department_histories <- dplyr::left_join(department_histories, departments, by = "current_department")

##################################################
# dates
##################################################

# format dates
department_histories$start_date <- lubridate::ymd(department_histories$start_date)
department_histories$end_date <- lubridate::ymd(department_histories$end_date)

# start year
department_histories$start_year <- lubridate::year(department_histories$start_date)

# start month
department_histories$start_month <- lubridate::month(department_histories$start_date)

# start day
department_histories$start_day <- lubridate::day(department_histories$start_date)

# end year
department_histories$end_year <- lubridate::year(department_histories$end_date)

# end month
department_histories$end_month <- lubridate::month(department_histories$end_date)

# end day
department_histories$end_day <- lubridate::day(department_histories$end_date)

##################################################
# organize data
##################################################

# arrange
department_histories <- dplyr::arrange(department_histories, current_department_id, department_id, start_date)

# key ID
department_histories$key_id <- 1:nrow(department_histories)

# organize variables
department_histories <- dplyr::select(
  department_histories,
  key_id,
  current_department_id, current_department, current_department_code,
  current_department_type_id, current_department_type,
  department_id, department, department_code,
  department_type_id, department_type,
  commissions, count_commissions,
  start_date, start_year, start_month, start_day,
  end_date, end_year, end_month, end_day
)

# save
save(department_histories, file = "data/department_histories.RData")

###########################################################################
# end R script
###########################################################################
