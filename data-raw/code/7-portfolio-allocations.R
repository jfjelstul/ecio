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

# member state data
load("data/commissioners.RData")

# select variables
member_states_raw <- dplyr::select(
  member_states_raw,
  member_state, member_state_id, member_state_code
)

# select variables
commissioners <- dplyr::select(
  commissioners,
  full_name, commissioner_id
)

# full name
portfolios_raw$full_name <- stringr::str_c(portfolios_raw$first_name, portfolios_raw$last_name, sep = " ")
portfolios_raw$full_name_latin <- stringr::str_c(portfolios_raw$first_name_latin, portfolios_raw$last_name_latin, sep = " ")

# merge
portfolio_allocations <- dplyr::left_join(portfolios_raw, member_states_raw, by = "member_state")

# merge
portfolio_allocations <- dplyr::left_join(portfolio_allocations, commissioners, by = "full_name")

##################################################
# dates
##################################################

# format dates
portfolio_allocations$start_date <- lubridate::ymd(portfolio_allocations$start_date)
portfolio_allocations$end_date <- lubridate::ymd(portfolio_allocations$end_date)

# start year
portfolio_allocations$start_year <- lubridate::year(portfolio_allocations$start_date)

# start month
portfolio_allocations$start_month <- lubridate::month(portfolio_allocations$start_date)

# start day
portfolio_allocations$start_day <- lubridate::day(portfolio_allocations$start_date)

# end year
portfolio_allocations$end_year <- lubridate::year(portfolio_allocations$end_date)

# end month
portfolio_allocations$end_month <- lubridate::month(portfolio_allocations$end_date)

# end day
portfolio_allocations$end_day <- lubridate::day(portfolio_allocations$end_date)

##################################################
# make variables
##################################################

# portfolio change
portfolio_allocations$change_at_start <- portfolio_allocations$interval %>% stringr::str_detect("^change") %>% as.numeric()
portfolio_allocations$change_at_end <- portfolio_allocations$interval %>% stringr::str_detect("change$") %>% as.numeric()

##################################################
# organize
##################################################

# arrange
portfolio_allocations <- dplyr::arrange(portfolio_allocations, commission_id, start_date, last_name, first_name)

# key ID
portfolio_allocations$key_id <- 1:nrow(portfolio_allocations)

# select variables
portfolio_allocations <- dplyr::select(
  portfolio_allocations,
  key_id, commission_id, commission,
  commissioner_id, full_name, full_name_latin,
  last_name, last_name_latin, first_name, first_name_latin,
  member_state_id, member_state, member_state_code,
  national_party_code, national_party_name, national_party_name_english,
  political_group_code, political_group_name,
  start_date, start_year, start_month, start_day,
  end_date, end_year, end_month, end_day,
  portfolio, departments
)

# convert to a tibble
portfolio_allocations <- dplyr::as_tibble(portfolio_allocations)

# write data
save(portfolio_allocations, file = "data/portfolio_allocations.RData")

###########################################################################
# end R script
###########################################################################
