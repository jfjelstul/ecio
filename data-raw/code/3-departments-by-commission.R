###########################################################################
# Joshua C. Fjelstul, Ph.D.
# ecio R package
###########################################################################

# define pipe
`%>%` <- magrittr::`%>%`

##################################################
# read in data
##################################################

# commissioner data
departments_raw <- read.csv("data-raw/departments_raw.csv", stringsAsFactors = FALSE)

# commissions data
load("data/commissions.RData")

# select variables
commissions <- dplyr::select(
  commissions, commission,
  start_date, start_year, start_month, start_day,
  end_date, end_year, end_month, end_day,
)

# merge
departments_by_commission <- dplyr::left_join(departments_raw, commissions, by = "commission")

# read in department data
load("data/departments.RData")

# select variables
departments <- dplyr::select(departments, department_id, department_name)

# merge in department ID
departments_by_commission <- dplyr::left_join(departments_by_commission, departments, by = "department_name")

# drop abolished departments
departments_by_commission <- dplyr::filter(departments_by_commission, !stringr::str_detect(department_name, "ABOLISHED"))

##################################################
# organize
##################################################

# clean policy area
departments_by_commission$policy_area <- stringr::str_replace_all(departments_by_commission$policy_area, ";", ",")

# arrange
departments_by_commission <- dplyr::arrange(departments_by_commission, key_id)

# key ID
departments_by_commission$key_id <- 1:nrow(departments_by_commission)

# select variables
departments_by_commission <- dplyr::select(
  departments_by_commission,
  key_id, commission_id, commission,
  start_date, start_year, start_month, start_day,
  end_date, end_year, end_month, end_day,
  department_type_id, department_type,
  department_id, department_name, department_code, policy_area,
  current_department_name
)

# convert to a tibble
departments_by_commission <- dplyr::as_tibble(departments_by_commission)

# save
save(departments_by_commission, file = "data/departments_by_commission.RData")

###########################################################################
# end R script
###########################################################################
