###########################################################################
# Joshua C. Fjelstul, Ph.D.
# ecio R package
###########################################################################

##################################################
# run replication scripts
##################################################

# commissions
# one observation per commission
source("replication/1-commissions.R")
rm(list=ls())
# input: data-raw/commissions_raw.csv (source of raw data)
# input: data-raw/member_states_raw.csv (for member state ID)
# output: data/commissions.RData

# departments
# one observation per unique department name
source("replication/2-departments.R")
rm(list=ls())
# input: data-raw/departments_raw.csv (source of raw data)
# output: data/departments.RData

# departments by commission
# one observation per department per commission
source("replication/3-departments-by-commission.R")
rm(list=ls())
# input: data-raw/departments_raw.csv (source of raw data)
# input: data/commissions.RData (for commission dates)
# input: data/departments.RData (for department ID)
# output: data/departments_by_commission.RData

# commissioners
# one observation per unique individual
source("replication/4-commissioners.R")
rm(list=ls())
# input: data-raw/portfolios_raw.csv (source of raw data)
# input: data-raw/member_states_raw.csv (for member state ID)
# output: data/commissioners.RData

# commissioners by commission
# one observation per individual per commission
source("replication/5-commissioners-by-commission.R")
rm(list=ls())
# input: data-raw/portfolios_raw.csv (source of raw data)
# input: data/commissions.RData (for commission dates)
# input: data-raw/member_states_raw.csv (for member state ID)
# input: data/commissioners.RData (for commissioner ID)
# output: data/commissioners_by_commission.RData

# policy areas
# one observation per policy area
source("replication/6-policy-areas.R")
rm(list=ls())
# input: data-raw/policy_areas_raw.csv (source of raw data)
# input: data-raw/classification_schemes_raw.csv (source of raw data)
# output: data/policy_areas.RData

# portfolio allocations
# one observation per unique portfolio allocation per commission
source("replication/7-portfolio-allocations.R")
rm(list=ls())
# input: data-raw/portfolios_raw.csv (source of raw data)
# input: data-raw/member_states.csv (for member state ID)
# input: data/commissioners.RData (for commissioner ID)
# output: data/portfolio_allocations.RData

# department allocations
# one observation per unique department allocation per commission
source("replication/8-department-allocations.R")
rm(list=ls())
# input: data/portfolio_allocations.RData (source of data)
# input: data/departments.RData (for department ID)
# output: data/department_allocations.RData

# policy area allocations
# one observation per unique policy area allocation per commission
source("replication/9-policy-area-allocations.R")
rm(list=ls())
# input: data/department_portfolios.RData (source of data)
# input: data/policy_areas.RData (for department ID)
# output: data/policy_area_allocations.RData

# department histories
# one observation per former department per current department
source("replication/10-department-histories.R")
rm(list=ls())
# input: data/departments_by_commission.RData (source of data)
# input: data/departments.RData (for department ID)
# output: data/department_histories.RData

# policy area histories
# one observation per unique department name per policy area
source("replication/11-policy-area-histories.R")
rm(list=ls())
# input: data/departments_by_commission.RData (source of data)
# input: data/policy_areas.RData (for policy area ID)
# output: data/policy_area_histories.RData

# classifications
# on observation per classification code per scheme
source("replication/12-classification-schemes.R")
rm(list=ls())
# input: data-raw/classification_schemes_raw.csv (source of raw data)
# input: data/policy_areas.RData (for policy area ID)
# output: data/classification_schemes.RData

##################################################
# codebook
##################################################

# read in data
codebook <- read.csv("codebook/codebook.csv", stringsAsFactors = FALSE)

# convert to a tibble
codebook <- dplyr::as_tibble(codebook)

# save
save(codebook, file = "data/codebook.RData")

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
# variables names
##################################################

names(commissions)
names(departments)
names(departments_by_commission)
names(commissioners)
names(commissioners_by_commission)
names(policy_areas)
names(portfolio_allocations)
names(department_allocations)
names(policy_area_allocations)
names(department_histories)
names(policy_area_histories)
names(classification_schemes)
names(codebooks)

###########################################################################
# end R script
###########################################################################
