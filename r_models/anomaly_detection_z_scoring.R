if (!requireNamespace("jsonlite", quietly = TRUE)) install.packages("jsonlite", repos="https://r-project.org")
library(jsonlite)

data <- read.csv("data/data.csv")

numeric_cols <- sapply(data, is.numeric)
data_numeric <- data[, numeric_cols, drop = FALSE]
data_numeric$id <- NULL
data_numeric$X <- NULL

results_list <- list()
all_anomaly_indices <- logical(nrow(data))

for (col_name in colnames(data_numeric)) {
  target_column <- data_numeric[[col_name]]
  
  mean_value <- mean(target_column, na.rm = TRUE)
  sd_value <- sd(target_column, na.rm = TRUE)
  
  if (sd_value > 0) {
    z_scores <- (target_column - mean_value) / sd_value
    anomaly_logical <- abs(z_scores) > 2
    all_anomaly_indices <- all_anomaly_indices | anomaly_logical
    
    results_list[[col_name]] <- list(
      mean = round(mean_value, 2),
      sd = round(sd_value, 2),
      anomaly_values = target_column[anomaly_logical]
    )
  }
}

output_payload <- list(
  column_metrics = results_list,
  anomaly_rows = data[all_anomaly_indices, , drop = FALSE],
  normal_rows = data[!all_anomaly_indices, , drop = FALSE]
)

cat(toJSON(output_payload, auto_unbox = TRUE, pretty = TRUE))
