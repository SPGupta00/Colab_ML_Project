library(jsonlite)

args <- commandArgs(trailingOnly = TRUE)

possible_paths <- c(
  "data/data.csv",
  "../data/data.csv",
  "Colab_ML_Project/data/data.csv"
)

data_path <- "data/data.csv"
for (p in possible_paths) {
  if (file.exists(p)) {
    data_path <- p
    break
  }
}

if (length(args) > 0 && file.exists(args[1])) {
  data_path <- args[1]
}

data <- read.csv(data_path)
id_vector_source <- data[, 1]

numeric_cols <- sapply(data, is.numeric)
data_numeric <- data[, numeric_cols, drop = FALSE]
data_numeric[, 1] <- NULL
if ("X" %in% colnames(data_numeric)) data_numeric$X <- NULL

results_list <- list()

for (col_name in colnames(data_numeric)) {
  target_column <- data_numeric[[col_name]]
  
  col_median <- median(target_column, na.rm = TRUE)
  col_mad <- mad(target_column, constant = 1.4826, na.rm = TRUE)
  
  if (is.na(col_mad) || col_mad == 0) {
    col_mad = col_median * 0.1
    if (col_mad == 0) col_mad <- 1
  }
  
  robust_z <- (target_column - col_median) / col_mad
  anomaly_logical <- abs(robust_z) > 3
  
  id_vector <- id_vector_source[anomaly_logical]
  value_vector <- target_column[anomaly_logical]
  
  results_list[[col_name]] <- list(
    mean = round(mean(target_column, na.rm = TRUE), 2),
    sd = round(sd(target_column, na.rm = TRUE), 2),
    has_anomalies = any(anomaly_logical),
    anomaly_ids = if(length(id_vector) > 0) as.list(id_vector) else list(),
    anomaly_values = if(length(value_vector) > 0) as.list(value_vector) else list()
  )
}

cat(toJSON(results_list, auto_unbox = TRUE))
