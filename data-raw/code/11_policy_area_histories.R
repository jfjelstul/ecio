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

# policy area dtaa
load("data/policy_areas.RData")

# drop departments that don't correspond to a policy area
departments_by_commission <- dplyr::filter(departments_by_commission, policy_area != "None")

# separate policy areas
departments_by_commission <- tidyr::separate_rows(departments_by_commission, policy_area, sep = ", ")

# collapse by policy area
policy_area_histories <- departments_by_commission %>%
  dplyr::group_by(department, policy_area) %>%
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
policy_areas <- dplyr::select(
  policy_areas,
  policy_area, policy_area_id
)

# merge
policy_area_histories <- dplyr::left_join(policy_area_histories, policy_areas, by = "policy_area")

##################################################
# dates
##################################################

# format dates
policy_area_histories$start_date <- lubridate::ymd(policy_area_histories$start_date)
policy_area_histories$end_date <- lubridate::ymd(policy_area_histories$end_date)

# start year
policy_area_histories$start_year <- lubridate::year(policy_area_histories$start_date)

# start month
policy_area_histories$start_month <- lubridate::month(policy_area_histories$start_date)

# start day
policy_area_histories$start_day <- lubridate::day(policy_area_histories$start_date)

# end year
policy_area_histories$end_year <- lubridate::year(policy_area_histories$end_date)

# end month
policy_area_histories$end_month <- lubridate::month(policy_area_histories$end_date)

# end day
policy_area_histories$end_day <- lubridate::day(policy_area_histories$end_date)

##################################################
# organize data
##################################################

# arrange
policy_area_histories <- dplyr::arrange(policy_area_histories, policy_area_id, department_id, start_date)

# key ID
policy_area_histories$key_id <- 1:nrow(policy_area_histories)

# organize variables
policy_area_histories <- dplyr::select(
  policy_area_histories,
  key_id,
  policy_area_id, policy_area,
  department_id, department, department_code,
  department_type_id, department_type,
  commissions, count_commissions,
  start_date, start_year, start_month, start_day,
  end_date, end_year, end_month, end_day
)

# save
save(policy_area_histories, file = "data/policy_area_histories.RData")

###########################################################################
# end R script
###########################################################################
