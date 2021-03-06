################################################################################
# Joshua C. Fjelstul, Ph.D.
# ecio R package
# automatically generated by the codebookr R package
################################################################################

#' Data on commissions
#' 
#' This dataset includes data on Commissions of the European Union
#' (1958-2021). There is one observation per Commission. The data indicates
#' the national party and European political group of the President of the
#' Commission and the start and end dates of each Commission. The Mansholt
#' Commission is treated as its own Commission. The Marín Commission is
#' treated as part of the Santer Commission.
#' 
#' @format A data frame with 25 variables:
#' \describe{
#' \item{key_id}{\code{numeric}. An ID number that uniquely identifies each
#' observation. Indicates the default sort order for the dataset.}
#' \item{commission_id}{\code{numeric}. The ID number that uniquely identifies
#' each Commission.}
#' \item{commission}{\code{string}. The name of the Commission.}
#' \item{full_name}{\code{string}. The full name of the President of the
#' Commission.}
#' \item{full_name_latin}{\code{string}. The full name of the President of the
#' Commission using only basic Latin characters.}
#' \item{last_name}{\code{string}. The last name of the President of the
#' Commission.}
#' \item{last_name_latin}{\code{string}. The last name of the President of the
#' Commission using only basic Latin characters.}
#' \item{first_name}{\code{string}. The first name of the President of the
#' Commission.}
#' \item{first_name_latin}{\code{string}. The first name of the President of
#' the Commission using only basic Latin characters.}
#' \item{member_state_id}{\code{numeric}. An ID number that uniquely
#' identifies each member state.}
#' \item{member_state}{\code{string}. The name of the President of the
#' Commission's member state.}
#' \item{member_state_code}{\code{string}. The two-letter code assigned by the
#' Commission to the President of the Commission's member state.}
#' \item{national_party_code}{\code{string}. The common abbreviation of the
#' President of the Commission's national political party.}
#' \item{national_party_name}{\code{string}. The name of the President of the
#' Commission's national political party in the President's member state's
#' official language.}
#' \item{national_party_name_english}{\code{string}. The name of the President
#' of the Commission's national political party in English.}
#' \item{political_group_code}{\code{string}. The common abbreviation of the
#' political group.}
#' \item{political_group_name}{\code{string}. The name of the President of the
#' Commission's political group.}
#' \item{start_date}{\code{date}. The start date of the Commission.}
#' \item{start_year}{\code{numeric}. The start year of the Commission.}
#' \item{start_month}{\code{numeric}. The start month of the Commission.}
#' \item{start_day}{\code{numeric}. The start day of the Commission.}
#' \item{end_date}{\code{date}. The end date of the Commission.}
#' \item{end_year}{\code{numeric}. The start year of the Commission.}
#' \item{end_month}{\code{numeric}. The start month of the Commission.}
#' \item{end_day}{\code{numeric}. The end day of the Commission.}
#' }
"commissions"

################################################################################
# end R script
################################################################################

