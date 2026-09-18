library(jsonlite)

args <- commandArgs(trailingOnly = TRUE)
data_path <- if (length(args) > 0) args[1] else "data/data.csv"

data <- read.csv(data_path)

numeric_cols <- sapply(data, is.numeric)
data_numeric <- data[, numeric_cols, drop = FALSE]
data_numeric$id <- NULL
data_numeric$X <- NULL

columns_to_check <- colnames(data_numeric)
results_list <- list()

for (col_name in columns_to_check) {
  target_column <- data_numeric[[col_name]]
  
  mean_value <- mean(target_column, na.rm = TRUE)
  sd_value <- sd(target_column, na.rm = TRUE)
  
  if (!is.na(sd_value) && sd_value > 0) {
    z_scores <- (target_column - mean_value) / sd_value
    anomaly_logical <- abs(z_scores) > 2
    
    id_vector <- data$id[anomaly_logical]
    value_vector <- target_column[anomaly_logical]
    
    if (length(id_vector) == 0) {
      id_vector <- vector()
      value_vector <- vector()
    }
    
    results_list[[col_name]] <- list(
      mean = round(mean_value, 2),
      sd = round(sd_value, 2),
      has_anomalies = any(anomaly_logical),
      anomaly_ids = as.vector(id_vector),
      anomaly_values = as.vector(value_vector)
    )
  }
}

cat(toJSON(results_list, auto_unbox = TRUE))
