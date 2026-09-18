if (!requireNamespace("jsonlite", quietly = TRUE)) install.packages("jsonlite", repos="https://r-project.org")
library(jsonlite)

dframe <- read.csv("data/data.csv")

numeric_cols <- sapply(dframe, is.numeric)
data_numeric <- dframe[, numeric_cols, drop = FALSE]

mean_values <- colMeans(data_numeric, na.rm = TRUE)
sd_values   <- apply(data_numeric, 2, sd, na.rm = TRUE)

z_scores <- scale(data_numeric, center = mean_values, scale = sd_values)

anomaly_matrix <- abs(z_scores) > 2
has_anomaly <- rowSums(anomaly_matrix, na.rm = TRUE) > 0

anomaly_rows <- dframe[has_anomaly, , drop = FALSE]
normal_rows  <- dframe[!has_anomaly, , drop = FALSE]

output_data <- list(
  total_records = nrow(dframe),
  anomaly_count = nrow(anomaly_rows),
  anomalies     = anomaly_rows,
  normal_data   = normal_rows
)

cat(toJSON(output_data, auto_unbox = TRUE, pretty = TRUE))
