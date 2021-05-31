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

# clean department name
departments_raw$department <- stringr::str_squish(departments_raw$department)

# collapse data
departments <- departments_raw %>%
  dplyr::filter(!stringr::str_detect(department, "ABOLISHED")) %>%
  dplyr::group_by(department) %>%
  dplyr::summarize(
    commissions = stringr::str_c(unique(commission), collapse = ", "),
    first_commission_id = commission_id[1],
    department_type_id = unique(department_type_id),
    department_type = unique(department_type),
    department_code = unique(department_code),
    policy_area = unique(policy_area),
    current_department = unique(current_department),
    .groups = "drop_last"
  ) %>%
  dplyr::ungroup()

# drop duplicate
departments <- dplyr::filter(departments, !(department == "Joint Research Centre" & department_type == "Service department"))

##################################################
# make variables
##################################################

# clean policy area
departments$policy_area <- stringr::str_replace_all(departments$policy_area, ";", ",")

# number of commissions
departments$count_commissions <- stringr::str_count(departments$commissions, ",") + 1

# current department
departments$is_current_department <- as.numeric(departments$department == departments$current_department)

##################################################
# organize
##################################################

# arrange
departments <- dplyr::arrange(departments, first_commission_id, department_type_id)

# key ID
departments$key_id <- 1:nrow(departments)

# department ID
departments$department_id <- 1:nrow(departments)

# select variables
departments <- dplyr::select(
  departments,
  key_id, department_id, department,
  commissions, count_commissions, is_current_department,
  department_type_id, department_type, department_code,
  policy_area, current_department
)

# save
save(departments, file = "data/departments.RData")

###########################################################################
# end R script
###########################################################################
