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

# commissioner data
load("data/commissioners.RData")

# commission data
load("data/commissions.RData")

##################################################
# collapse
##################################################

# start date
portfolios_raw$start_date <- lubridate::ymd(portfolios_raw$start_date)

# end date
portfolios_raw$end_date <- lubridate::ymd(portfolios_raw$end_date)

# collapse by commissioner and by commission
commissioners_by_commission <- portfolios_raw %>%
  dplyr::group_by(first_name, last_name, commission) %>%
  dplyr::summarize(
    commission_id = unique(commission_id),
    last_name_latin = unique(last_name_latin),
    first_name_latin = unique(first_name_latin),
    member_state = unique(member_state),
    national_party_code = unique(national_party_code),
    national_party_name = unique(national_party_name),
    national_party_name_english = unique(national_party_name_english),
    political_group_code = unique(political_group_code),
    political_group_name = unique(political_group_name),
    start_date = min(start_date),
    end_date = max(end_date),
    interval = stringr::str_c(unique(interval), collapse = ", "),
    full_term = sum(stringr::str_detect(interval, "^start - end$")),
    end_early = sum(stringr::str_detect(interval, "replacement$")),
    replaced = sum(stringr::str_detect(interval, "- replacement$")),
    not_replaced = sum(stringr::str_detect(interval, "- no replacement$")),
    start_late = sum(stringr::str_detect(interval, "^(replacement|enlargement)")),
    replacement = sum(stringr::str_detect(interval, "^replacement")),
    enlargement = sum(stringr::str_detect(interval, "^enlargement")),
    portfolio_change = as.numeric(dplyr::n() > 1),
    .groups = "drop_last"
  ) %>%
  dplyr::ungroup()

# full name
commissioners_by_commission$full_name <- stringr::str_c(commissioners_by_commission$first_name, commissioners_by_commission$last_name, sep = " ")
commissioners_by_commission$full_name_latin <- stringr::str_c(commissioners_by_commission$first_name_latin, commissioners_by_commission$last_name_latin, sep = " ")

##################################################
# merge in data
##################################################

# select variables
member_states_raw <- dplyr::select(
  member_states_raw,
  member_state, member_state_id, member_state_code
)

# merge
commissioners_by_commission <- dplyr::left_join(commissioners_by_commission, member_states_raw, by = "member_state")

# select variables
commissioners <- dplyr::select(commissioners, commissioner_id, full_name)

# merge
commissioners_by_commission <- dplyr::left_join(commissioners_by_commission, commissioners, by = "full_name")

##################################################
# dates
##################################################

# start year
commissioners_by_commission$start_year <- lubridate::year(commissioners_by_commission$start_date)

# start month
commissioners_by_commission$start_month <- lubridate::month(commissioners_by_commission$start_date)

# start day
commissioners_by_commission$start_day <- lubridate::day(commissioners_by_commission$start_date)

# end year
commissioners_by_commission$end_year <- lubridate::year(commissioners_by_commission$end_date)

# end month
commissioners_by_commission$end_month <- lubridate::month(commissioners_by_commission$end_date)

# end day
commissioners_by_commission$end_day <- lubridate::day(commissioners_by_commission$end_date)

##################################################
# organize
##################################################

# arrange
commissioners_by_commission <- dplyr::arrange(commissioners_by_commission, commission_id, start_date, last_name, first_name)

# key ID
commissioners_by_commission$key_id <- 1:nrow(commissioners_by_commission)

# select variables
commissioners_by_commission <- dplyr::select(
  commissioners_by_commission,
  key_id, commission_id, commission,
  commissioner_id, full_name, full_name_latin,
  last_name, last_name_latin, first_name, first_name_latin,
  member_state_id, member_state, member_state_code,
  national_party_code, national_party_name, national_party_name_english,
  political_group_code, political_group_name,
  start_date, start_year, start_month, start_day,
  end_date, end_year, end_month, end_day,
  full_term, end_early, replaced, not_replaced,
  start_late, replacement, enlargement, portfolio_change
)

# write data
save(commissioners_by_commission, file = "data/commissioners_by_commission.RData")

###########################################################################
# end R script
###########################################################################
