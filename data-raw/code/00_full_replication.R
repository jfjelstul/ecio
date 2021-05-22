###########################################################################
# Joshua C. Fjelstul, Ph.D.
# ecio R package
###########################################################################

##################################################
# run replication scripts
##################################################

# commissions
# one observation per commission
source("data-raw/code/01_commissions.R")
rm(list = ls())
# input: data-raw/commissions_raw.csv (source of raw data)
# input: data-raw/member_states_raw.csv (for member state ID)
# output: data/commissions.RData

# departments
# one observation per unique department name
source("data-raw/code/02_departments.R")
rm(list = ls())
# input: data-raw/departments_raw.csv (source of raw data)
# output: data/departments.RData

# departments by commission
# one observation per department per commission
source("data-raw/code/03_departments_by_commission.R")
rm(list = ls())
# input: data-raw/departments_raw.csv (source of raw data)
# input: data/commissions.RData (for commission dates)
# input: data/departments.RData (for department ID)
# output: data/departments_by_commission.RData

# commissioners
# one observation per unique individual
source("data-raw/code/04_commissioners.R")
rm(list = ls())
# input: data-raw/portfolios_raw.csv (source of raw data)
# input: data-raw/member_states_raw.csv (for member state ID)
# output: data/commissioners.RData

# commissioners by commission
# one observation per individual per commission
source("data-raw/code/05_commissioners_by_commission.R")
rm(list = ls())
# input: data-raw/portfolios_raw.csv (source of raw data)
# input: data/commissions.RData (for commission dates)
# input: data-raw/member_states_raw.csv (for member state ID)
# input: data/commissioners.RData (for commissioner ID)
# output: data/commissioners_by_commission.RData

# policy areas
# one observation per policy area
source("data-raw/code/06_policy_areas.R")
rm(list = ls())
# input: data-raw/policy_areas_raw.csv (source of raw data)
# input: data-raw/classification_schemes_raw.csv (source of raw data)
# output: data/policy_areas.RData

# portfolio allocations
# one observation per unique portfolio allocation per commission
source("data-raw/code/07_portfolio_allocations.R")
rm(list = ls())
# input: data-raw/portfolios_raw.csv (source of raw data)
# input: data-raw/member_states.csv (for member state ID)
# input: data/commissioners.RData (for commissioner ID)
# output: data/portfolio_allocations.RData

# department allocations
# one observation per unique department allocation per commission
source("data-raw/code/08_department_allocations.R")
rm(list = ls())
# input: data/portfolio_allocations.RData (source of data)
# input: data/departments.RData (for department ID)
# output: data/department_allocations.RData

# policy area allocations
# one observation per unique policy area allocation per commission
source("data-raw/code/09_policy_area_allocations.R")
rm(list = ls())
# input: data/department_portfolios.RData (source of data)
# input: data/policy_areas.RData (for department ID)
# output: data/policy_area_allocations.RData

# department histories
# one observation per former department per current department
source("data-raw/code/10_department_histories.R")
rm(list = ls())
# input: data/departments_by_commission.RData (source of data)
# input: data/departments.RData (for department ID)
# output: data/department_histories.RData

# policy area histories
# one observation per unique department name per policy area
source("data-raw/code/11_policy_area_histories.R")
rm(list = ls())
# input: data/departments_by_commission.RData (source of data)
# input: data/policy_areas.RData (for policy area ID)
# output: data/policy_area_histories.RData

# classifications
# on observation per classification code per scheme
source("data-raw/code/12_classification_schemes.R")
rm(list = ls())
# input: data-raw/classification_schemes_raw.csv (source of raw data)
# input: data/policy_areas.RData (for policy area ID)
# output: data/classification_schemes.RData

##################################################
# codebook
##################################################

# read in data
codebook <- read.csv("data-raw/codebook/codebook.csv", stringsAsFactors = FALSE)

# convert to a tibble
codebook <- dplyr::as_tibble(codebook)

# save
save(codebook, file = "data/codebook.RData")

# documentation
codebookr::document_data(
  path = "R/",
  codebook_file = "data-raw/codebook/codebook.csv",
  markdown_file = "data-raw/codebook/descriptions.txt",
  author = "Joshua C. Fjelstul, Ph.D.",
  package = "ecio"
)

##################################################
# read in data
##################################################

load("data/commissions.RData")
load("data/departments.RData")
load("data/departments_by_commission.RData")
load("data/commissioners.RData")
load("data/commissioners_by_commission.RData")
load("data/policy_areas.RData")
load("data/portfolio_allocations.RData")
load("data/department_allocations.RData")
load("data/policy_area_allocations.RData")
load("data/policy_area_histories.RData")
load("data/department_histories.RData")
load("data/classification_schemes.RData")
load("data/codebook.RData")

##################################################
# check class
##################################################

class(commissions)
class(departments)
class(departments_by_commission)
class(commissioners)
class(commissioners_by_commission)
class(policy_areas)
class(portfolio_allocations)
class(department_allocations)
class(policy_area_allocations)
class(department_histories)
class(policy_area_histories)
class(classification_schemes)
class(codebook)

##################################################
# check for missing data
##################################################

table(is.na(commissions))
table(is.na(departments))
table(is.na(departments_by_commission))
table(is.na(commissioners))
table(is.na(commissioners_by_commission))
table(is.na(policy_areas))
table(is.na(portfolio_allocations))
table(is.na(department_allocations))
table(is.na(policy_area_allocations))
table(is.na(policy_area_histories))
table(is.na(department_histories))
table(is.na(classification_schemes))
table(is.na(codebook))

##################################################
# build
##################################################

write.csv(commissions, "build/ecio_commissions.csv", row.names = FALSE, quote = TRUE)
write.csv(departments, "build/ecio_deprtments.csv", row.names = FALSE, quote = TRUE)
write.csv(departments_by_commission, "build/ecio_deparments_by_commission.csv", row.names = FALSE, quote = TRUE)
write.csv(commissioners, "build/ecio_commissioners.csv", row.names = FALSE, quote = TRUE)
write.csv(commissioners_by_commission, "build/ecio_commissioners_by_commission.csv", row.names = FALSE, quote = TRUE)
write.csv(policy_areas, "build/ecio_policy_areas.csv", row.names = FALSE, quote = TRUE)
write.csv(portfolio_allocations, "build/ecio_portfolio_allocations.csv", row.names = FALSE, quote = TRUE)
write.csv(department_allocations, "build/ecio_department_allocations.csv", row.names = FALSE, quote = TRUE)
write.csv(policy_area_allocations, "build/ecio_policy_area_allocations.csv", row.names = FALSE, quote = TRUE)
write.csv(department_histories, "build/ecio_department_histories.csv", row.names = FALSE, quote = TRUE)
write.csv(policy_area_histories, "build/ecio_policy_area_histories.csv", row.names = FALSE, quote = TRUE)
write.csv(classification_schemes, "build/ecio_classification_schemes.csv", row.names = FALSE, quote = TRUE)
write.csv(codebook, "build/ecio_codebook.csv", row.names = FALSE, quote = TRUE)

##################################################
# server
##################################################

write.csv(commissions, "server/ecio_commissions.csv", row.names = FALSE, quote = TRUE, na = "\\N")
write.csv(departments, "server/ecio_deprtments.csv", row.names = FALSE, quote = TRUE, na = "\\N")
write.csv(departments_by_commission, "server/ecio_deparments_by_commission.csv", row.names = FALSE, quote = TRUE, na = "\\N")
write.csv(commissioners, "server/ecio_commissioners.csv", row.names = FALSE, quote = TRUE, na = "\\N")
write.csv(commissioners_by_commission, "server/ecio_commissioners_by_commission.csv", row.names = FALSE, quote = TRUE, na = "\\N")
write.csv(policy_areas, "server/ecio_policy_areas.csv", row.names = FALSE, quote = TRUE, na = "\\N")
write.csv(portfolio_allocations, "server/ecio_portfolio_allocations.csv", row.names = FALSE, quote = TRUE, na = "\\N")
write.csv(department_allocations, "server/ecio_department_allocations.csv", row.names = FALSE, quote = TRUE, na = "\\N")
write.csv(policy_area_allocations, "server/ecio_policy_area_allocations.csv", row.names = FALSE, quote = TRUE, na = "\\N")
write.csv(department_histories, "server/ecio_department_histories.csv", row.names = FALSE, quote = TRUE, na = "\\N")
write.csv(policy_area_histories, "server/ecio_policy_area_histories.csv", row.names = FALSE, quote = TRUE, na = "\\N")
write.csv(classification_schemes, "server/ecio_classification_schemes.csv", row.names = FALSE, quote = TRUE, na = "\\N")
write.csv(codebook, "server/ecio_codebook.csv", row.names = FALSE, quote = TRUE, na = "\\N")

###########################################################################
# end R script
###########################################################################
