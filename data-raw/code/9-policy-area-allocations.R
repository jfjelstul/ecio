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
load("data/department_allocations.RData")

# load department data
load("data/policy_areas.RData")

# split policy areas into rows
policy_area_allocations <- tidyr::separate_rows(department_allocations, policy_area, sep = ", ")

# select variables
policy_areas <- dplyr::select(
  policy_areas,
  policy_area_id, policy_area
)

# merge
policy_area_allocations <- dplyr::left_join(policy_area_allocations, policy_areas, by = "policy_area")

##################################################
# collapse
##################################################

# drop portfolios without a department
policy_area_allocations <- dplyr::filter(policy_area_allocations, policy_area != "None")

# collapse by commission, commissioner, and policy
# this handles cases where there's a portfolio change but the policy areas don't change (e.g., sharing)
policy_area_allocations <- policy_area_allocations %>%
  dplyr::group_by(commission_id, commission, full_name, policy_area_id, policy_area) %>%
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
    department_name = stringr::str_c(unique(department_name), collapse = "; "),
    start_date = min(start_date),
    end_date = max(end_date),
    .groups = "drop_last"
  ) %>% dplyr::ungroup()

# # appearances
# policy_area_allocations <- policy_area_allocations %>%
#   dplyr::group_by(commission_id, policy_area_id) %>%
#   dplyr::mutate(
#     count_appearances = dplyr::n()
#   ) %>% dplyr::ungroup()

##################################################
# dates
##################################################

# format dates
policy_area_allocations$start_date <- lubridate::ymd(policy_area_allocations$start_date)
policy_area_allocations$end_date <- lubridate::ymd(policy_area_allocations$end_date)

# start year
policy_area_allocations$start_year <- lubridate::year(policy_area_allocations$start_date)

# start month
policy_area_allocations$start_month <- lubridate::month(policy_area_allocations$start_date)

# start day
policy_area_allocations$start_day <- lubridate::day(policy_area_allocations$start_date)

# end year
policy_area_allocations$end_year <- lubridate::year(policy_area_allocations$end_date)

# end month
policy_area_allocations$end_month <- lubridate::month(policy_area_allocations$end_date)

# end day
policy_area_allocations$end_day <- lubridate::day(policy_area_allocations$end_date)

##################################################
# organize
##################################################

# arrange
policy_area_allocations <- dplyr::arrange(
  policy_area_allocations,
  commission_id, start_date
)

# key ID
policy_area_allocations$key_id <- 1:nrow(policy_area_allocations)

# select variables
policy_area_allocations <- dplyr::select(
  policy_area_allocations,
  key_id, commission_id, commission,
  commissioner_id, full_name, full_name_latin,
  last_name, last_name_latin, first_name, first_name_latin,
  member_state_id, member_state, member_state_code,
  national_party_code, national_party_name, national_party_name_english,
  political_group_code, political_group_name,
  start_date, start_year, start_month, start_day,
  end_date, end_year, end_month, end_day,
  policy_area_id, policy_area
)

# write data
save(policy_area_allocations, file = "data/policy_area_allocations.RData")

###########################################################################
# end R script
###########################################################################
