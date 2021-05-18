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
commissions_raw <- read.csv("data-raw/commissions_raw.csv", stringsAsFactors = FALSE)

##################################################
# member state data
##################################################

# read in data
member_states_raw <- read.csv("data-raw/member_states_raw.csv", stringsAsFactors = FALSE)

# select variables
member_states_raw <- dplyr::select(
  member_states_raw,
  member_state_id, member_state, member_state_code
)

# merge
commissions <- dplyr::left_join(commissions_raw, member_states_raw, by = "member_state")

##################################################
# dates
##################################################

# format dates
commissions$start_date <- lubridate::ymd(commissions$start_date)
commissions$end_date <- lubridate::ymd(commissions$end_date)

# start year
commissions$start_year <- lubridate::year(commissions$start_date)

# start month
commissions$start_month <- lubridate::month(commissions$start_date)

# start day
commissions$start_day <- lubridate::day(commissions$start_date)

# end year
commissions$end_year <- lubridate::year(commissions$end_date)

# end month
commissions$end_month <- lubridate::month(commissions$end_date)

# end day
commissions$end_day <- lubridate::day(commissions$end_date)

##################################################
# oganize
##################################################

# full name
commissions$full_name <- stringr::str_c(commissions$first_name, commissions$last_name, sep = " ")
commissions$full_name_latin <- stringr::str_c(commissions$first_name_latin, commissions$last_name_latin, sep = " ")

##################################################
# oganize
##################################################

# key ID
commissions$key_id <- 1:nrow(commissions)

# select variables
commissions <- dplyr::select(
  commissions,
  key_id, commission_id, commission, full_name, full_name_latin,
  last_name, last_name_latin, first_name, first_name_latin,
  member_state_id, member_state, member_state_code,
  national_party_code, national_party_name, national_party_name_english,
  political_group_code, political_group_name,
  start_date, start_year, start_month, start_day,
  end_date, end_year, end_month, end_day
)

# convert to a tibble
commissions <- dplyr::as_tibble(commissions)

# write data
save(commissions, file = "data/commissions.RData")

###########################################################################
# end R script
###########################################################################
