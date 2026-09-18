# 1. Load the data from your text string (or file)
data <- read.csv("data/data.csv")

columns_to_check <- c("Age", "AnnualIncome", "SpendingScore")

for (col_name in columns_to_check) {
  cat("=========================================\n")
  cat("Analyzing Column:", col_name, "\n")
  cat("=========================================\n")
  
  target_column <- data[[col_name]]
  
  mean_value <- mean(target_column, na.rm = TRUE)
  sd_value <- sd(target_column, na.rm = TRUE)
  
  z_scores <- (target_column - mean_value) / sd_value
  anomaly_logical <- abs(z_scores) > 2
  
  cat("Mean:", round(mean_value, 2), " | SD:", round(sd_value, 2), "\n\n")
  
  if (any(anomaly_logical)) {
    cat(" Anomaly values found:\n")
    print(target_column[anomaly_logical])
  } else {
    cat("No anomalies found (all values fall within 2 standard deviations).\n")
  }
  cat("\n")
}
