## ---- include = FALSE---------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## -----------------------------------------------------------------------------
# first, attach the package if you haven't already
library(daiquiri)

# this is where the example file is located
path <- system.file("extdata", "example_prescriptions.csv", package = "daiquiri")

# load the data into a data.frame without doing any datatype conversion
example_prescriptions <- read_data(
  path,
  delim = ",",
  col_names = TRUE,
  show_progress = FALSE
)

head(example_prescriptions)

## -----------------------------------------------------------------------------
# set up a field_types specification for use later
fts <- field_types(
  PrescriptionID = ft_uniqueidentifier(),
  PrescriptionDate = ft_timepoint(),
  AdmissionDate = ft_datetime(includes_time = FALSE),
  Drug = ft_freetext(),
  Dose = ft_numeric(),
  DoseUnit = ft_categorical(),
  PatientID = ft_ignore(),
  Location = ft_categorical(aggregate_by_each_category = TRUE)
)

## ---- include=FALSE-----------------------------------------------------------
# quietly test can create the report from an rmd but show the code in the next chunk in the vignette
daiq_obj <- daiquiri_report(
  df = example_prescriptions,
  field_types = fts,
  override_column_names = FALSE,
  na = c("", "NULL"),
  dataset_description = "Example prescription data",
  aggregation_timeunit = "day",
  report_title = "daiquiri data quality report",
  save_directory = tempdir(),
  save_filename = "example_prescriptions_report",
  show_progress = FALSE,
  log_directory = NULL
)
# clean up
file.remove(daiq_obj$report_filename)

## ---- eval=FALSE--------------------------------------------------------------
#  daiq_obj <- daiquiri_report(
#    df = example_prescriptions,
#    field_types = fts,
#    override_column_names = FALSE,
#    na = c("", "NULL"),
#    dataset_description = "Example prescription data",
#    aggregation_timeunit = "day",
#    report_title = "daiquiri data quality report",
#    save_directory = ".",
#    save_filename = "example_prescriptions_report",
#    show_progress = TRUE,
#    log_directory = NULL
#  )

## ---- eval=FALSE--------------------------------------------------------------
#  # load your dataset into a source_data object
#  prescriptions_source_data <- prepare_data(
#    example_prescriptions,
#    fieldtypes = fts,
#    na = c("", "NULL")
#  )
#  
#  # aggregate the source_data object by desired granularity
#  prescriptions_byday <- aggregate_data(
#    prescriptions_source_data,
#    aggregation_timeunit = "day"
#  )
#  
#  # aggregate the same source_data object by a different granularity
#  prescriptions_byweek <- aggregate_data(
#    prescriptions_source_data,
#    aggregation_timeunit = "week"
#  )
#  
#  # generate and save the reports
#  report_data(
#    source_data = prescriptions_source_data,
#    aggregated_data = prescriptions_byday,
#    report_title = "Daily prescriptions",
#    save_directory = ".",
#    save_filename = "example_prescriptions_byday"
#  )
#  
#  report_data(
#    source_data = prescriptions_source_data,
#    aggregated_data = prescriptions_byweek,
#    report_title = "Weekly prescriptions",
#    save_directory = ".",
#    save_filename = "example_prescriptions_byweek"
#  )

