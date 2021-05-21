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
portfolios_raw <- read.csv("data-raw/portfolios_raw.csv", stringsAsFactors = FALSE)

# member state data
member_states_raw <- read.csv("data-raw/member_states_raw.csv", stringsAsFactors = FALSE)

# select variables
commissioners <- dplyr::select(
  portfolios_raw,
  last_name, first_name, last_name_latin, first_name_latin, member_state,
  commission_id, commission,
  political_group_code, political_group_name,
  national_party_code, national_party_name, national_party_name_english,
  start_date, end_date
)

# select variables
member_states_raw <- dplyr::select(
  member_states_raw,
  member_state, member_state_id, member_state_code
)

# merge
commissioners <- dplyr::left_join(commissioners, member_states_raw, by = "member_state")

# start date
commissioners$start_date <- lubridate::ymd(commissioners$start_date)

# end date
commissioners$end_date <- lubridate::ymd(commissioners$end_date)

# group by commissioner
commissioners <- commissioners %>%
  dplyr::arrange(commission_id) %>%
  dplyr::group_by(last_name, first_name) %>%
  dplyr::summarize(
    last_name_latin = unique(last_name_latin),
    first_name_latin = unique(first_name_latin),
    commissions = stringr::str_c(unique(commission), collapse = ", "),
    member_state = unique(member_state),
    member_state_id = unique(member_state_id),
    member_state_code = unique(member_state_code),
    political_group_code = stringr::str_c(unique(political_group_code), collapse = ", "),
    political_group_name = stringr::str_c(unique(political_group_name), collapse = ", "),
    national_party_code = stringr::str_c(unique(national_party_code), collapse = ", "),
    national_party_name = stringr::str_c(unique(national_party_name), collapse = ", "),
    national_party_name_english = stringr::str_c(unique(national_party_name_english), collapse = ", "),
    start_date = min(start_date),
    end_date = max(end_date),
    .groups = "drop_last"
  ) %>%
  dplyr::ungroup()

# full name
commissioners$full_name <- stringr::str_c(commissioners$first_name, commissioners$last_name, sep = " ")
commissioners$full_name_latin <- stringr::str_c(commissioners$first_name_latin, commissioners$last_name_latin, sep = " ")

# count commissions
commissioners$count_commissions <- stringr::str_count(commissioners$commissions, ",") + 1

##################################################
# dates
##################################################

# format dates
commissioners$start_date <- lubridate::ymd(commissioners$start_date)
commissioners$end_date <- lubridate::ymd(commissioners$end_date)

# start year
commissioners$start_year <- lubridate::year(commissioners$start_date)

# start month
commissioners$start_month <- lubridate::month(commissioners$start_date)

# start day
commissioners$start_day <- lubridate::day(commissioners$start_date)

# end year
commissioners$end_year <- lubridate::year(commissioners$end_date)

# end month
commissioners$end_month <- lubridate::month(commissioners$end_date)

# end day
commissioners$end_day <- lubridate::day(commissioners$end_date)

##################################################
# oganize
##################################################

# arrange
commissioners <- dplyr::arrange(commissioners, start_date, last_name, first_name)

# key ID
commissioners$key_id <- 1:nrow(commissioners)

# commissioner ID
commissioners$commissioner_id <- 1:nrow(commissioners)

# select variables
commissioners <- dplyr::select(
  commissioners,
  key_id, commissioner_id,
  full_name, full_name_latin,
  last_name, last_name_latin, first_name, first_name_latin,
  member_state_id, member_state, member_state_code,
  national_party_code, national_party_name, national_party_name_english,
  political_group_code, political_group_name,
  commissions, count_commissions,
  start_date, start_year, start_month, start_day,
  end_date, end_year, end_month, end_day
)

# write data
save(commissioners, file = "data/commissioners.RData")

###########################################################################
# end R script
###########################################################################
