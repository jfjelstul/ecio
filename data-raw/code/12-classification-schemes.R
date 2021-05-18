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
classification_schemes_raw <- read.csv("data-raw/classification_schemes_raw.csv", stringsAsFactors = FALSE)

# policy areas
load("data/policy_areas.RData")

# select variables
policy_areas <- dplyr::select(
  policy_areas,
  policy_area_id, policy_area
)

# merge
classification_schemes <- dplyr::left_join(classification_schemes_raw, policy_areas, by = "policy_area")

# fill in missing
classification_schemes$policy_area_id[is.na(classification_schemes$policy_area_id)] <- 0

##################################################
# oganize
##################################################

# key ID
classification_schemes$key_id <- 1:nrow(classification_schemes)

# select variables
classification_schemes <- dplyr::select(
  classification_schemes,
  key_id, scheme_id, scheme, code_id,
  major_code, major_code_topic, minor_code, minor_code_topic,
  policy_area_id, policy_area
)

# convert to a tibble
classification_schemes <- dplyr::as_tibble(classification_schemes)

# write data
save(classification_schemes, file = "data/classification_schemes.RData")

###########################################################################
# end R script
###########################################################################
