library(jsonlite)

args <- commandArgs(trailingOnly = TRUE)
data_path <- if (length(args) > 0) args[1] else "data/data.csv"

data <- read.csv(data_path)
columns_to_check <- c("Age", "AnnualIncome", "SpendingScore")

results_list <- list()

for (col_name in columns_to_check) {
  target_column <- data[[col_name]]
  
  mean_value <- mean(target_column, na.rm = TRUE)
  sd_value <- sd(target_column, na.rm = TRUE)
  
  z_scores <- (target_column - mean_value) / sd_value
  anomaly_logical <- abs(z_scores) > 2
  
  # Find matching CustomerIDs for anomalies
  anomaly_customer_ids <- data$CustomerID[anomaly_logical]
  anomaly_values <- target_column[anomaly_logical]
  
  results_list[[col_name]] <- list(
    mean = round(mean_value, 2),
    sd = round(sd_value, 2),
    has_anomalies = any(anomaly_logical),
    anomaly_customer_ids = as.vector(anomaly_customer_ids),
    anomaly_values = as.vector(anomaly_values)
  )
}

# Print clean JSON back to Flask
cat(toJSON(results_list, auto_unbox = TRUE))
