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
policy_areas_raw <- read.csv("data-raw/policy_areas_raw.csv", stringsAsFactors = FALSE)

# read in classification scheme data
classification_schemes_raw <- read.csv("data-raw/classification_schemes_raw.csv", stringsAsFactors = FALSE)

# select variables
policy_areas <- dplyr::select(policy_areas_raw, policy_area_id, policy_area)

##################################################
# collapse classifications
##################################################

# code classifications
classification_schemes_raw$code <- classification_schemes_raw$minor_code
classification_schemes_raw$code[classification_schemes_raw$minor_code == "None"] <- classification_schemes_raw$major_code[classification_schemes_raw$minor_code == "None"]

# collapse old case law codes
case_law_old <- classification_schemes_raw %>%
  dplyr::filter(scheme == "Case law directory (old)") %>%
  dplyr::group_by(policy_area) %>%
  dplyr::summarize(
    case_law_old = stringr::str_c(unique(code), collapse = ", "),
    .groups = "drop_last"
  )

# collapse new case law codes
case_law_new <- classification_schemes_raw %>%
  dplyr::filter(scheme == "Case law directory (new)") %>%
  dplyr::group_by(policy_area) %>%
  dplyr::summarize(
    case_law_new = stringr::str_c(unique(code), collapse = ", "),
    .groups = "drop_last"
  )

# collapse legislation codes
legislation <- classification_schemes_raw %>%
  dplyr::filter(scheme == "Directory of legal acts") %>%
  dplyr::group_by(policy_area) %>%
  dplyr::summarize(
    legislation = stringr::str_c(unique(code), collapse = ", "),
    .groups = "drop_last"
  )

# merge in codes
policy_areas <- dplyr::left_join(policy_areas, case_law_old, by = "policy_area")
policy_areas <- dplyr::left_join(policy_areas, case_law_new, by = "policy_area")
policy_areas <- dplyr::left_join(policy_areas, legislation, by = "policy_area")

# code missing
policy_areas$case_law_new[is.na(policy_areas$case_law_new)] <- "None"
policy_areas$case_law_old[is.na(policy_areas$case_law_old)] <- "None"
policy_areas$legislation[is.na(policy_areas$legislation)] <- "None"

# clean workspace
rm(case_law_old, case_law_new, legislation)

##################################################
# organize
##################################################

# key ID
policy_areas$key_id <- 1:nrow(policy_areas)

# select variables
policy_areas <- dplyr::select(
  policy_areas,
  key_id, policy_area_id, policy_area,
  case_law_old, case_law_new, legislation
)

# convert to a tibble
policy_areas <- dplyr::as_tibble(policy_areas)

# save
save(policy_areas, file = "data/policy_areas.RData")

###########################################################################
# end R script
###########################################################################
