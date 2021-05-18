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
load("data/portfolio_allocations.RData")

# load department data
load("data/departments.RData")

# split departments into rows
department_allocations <- tidyr::separate_rows(portfolio_allocations, departments, sep = "; ")

# rename variable
department_allocations <- dplyr::rename(department_allocations, department_name = departments)

# select variables
departments <- dplyr::select(
  departments,
  department_id, department_name,
  department_code, policy_area
)

# merge
department_allocations <- dplyr::left_join(department_allocations, departments, by = "department_name")

##################################################
# collapse
##################################################

# drop portfolios without a department
department_allocations <- dplyr::filter(department_allocations, department_name != "None")

# collapse by commission, commissioner, and department
# this handles cases where there's a portfolio change but the departments don't change (e.g., sharing)
department_allocations <- department_allocations %>%
  dplyr::group_by(commission, commission_id, full_name, department_name) %>%
  dplyr::summarize(
    commissioner_id = unique(commissioner_id),
    full_name_latin = unique(full_name_latin),
    last_name = unique(last_name),
    last_name_latin = unique(last_name_latin),
    first_name = unique(first_name),
    first_name_latin = unique(first_name_latin),
    member_state_id = unique(member_state_id),
    member_state = unique(member_state),
    member_state_code = unique(member_state_code),
    national_party_code = unique(national_party_code),
    national_party_name = unique(national_party_name),
    national_party_name_english = unique(national_party_name_english),
    political_group_code = unique(political_group_code),
    political_group_name = unique(political_group_name),
    start_date = min(start_date),
    end_date = max(end_date),
    department_id = unique(department_id),
    department_code = unique(department_code),
    policy_area = unique(policy_area),
    .groups = "drop_last"
  ) %>%
  dplyr::ungroup()

##################################################
# dates
##################################################

# format dates
department_allocations$start_date <- lubridate::ymd(department_allocations$start_date)
department_allocations$end_date <- lubridate::ymd(department_allocations$end_date)

# start year
department_allocations$start_year <- lubridate::year(department_allocations$start_date)

# start month
department_allocations$start_month <- lubridate::month(department_allocations$start_date)

# start day
department_allocations$start_day <- lubridate::day(department_allocations$start_date)

# end year
department_allocations$end_year <- lubridate::year(department_allocations$end_date)

# end month
department_allocations$end_month <- lubridate::month(department_allocations$end_date)

# end day
department_allocations$end_day <- lubridate::day(department_allocations$end_date)

##################################################
# organize
##################################################

# arrange
department_allocations <- dplyr::arrange(
  department_allocations,
  commission_id, start_date
)

# key ID
department_allocations$key_id <- 1:nrow(department_allocations)

# select variables
department_allocations <- dplyr::select(
  department_allocations,
  key_id, commission_id, commission,
  commissioner_id, full_name, full_name_latin,
  last_name, last_name_latin, first_name, first_name_latin,
  member_state_id, member_state, member_state_code,
  national_party_code, national_party_name, national_party_name_english,
  political_group_code, political_group_name,
  start_date, start_year, start_month, start_day,
  end_date, end_year, end_month, end_day,
  department_id, department_name, department_code, policy_area
)

# write data
save(department_allocations, file = "data/department_allocations.RData")

###########################################################################
# end R script
###########################################################################
