if (!requireNamespace("jsonlite", quietly = TRUE)) install.packages("jsonlite", repos="https://r-project.org")
library(jsonlite)

args <- commandArgs(trailingOnly = TRUE)
data_path <- if (length(args) >= 1) args[1] else "data/data.csv"
num_clusters <- if (length(args) >= 2) as.integer(args[2]) else 3

dframe <- read.csv(data_path)

numeric_cols <- sapply(dframe, is.numeric)
data_cluster <- dframe[, numeric_cols, drop = FALSE]
data_cluster$id <- NULL
data_cluster$X <- NULL

set.seed(123)
kmeans_model <- kmeans(data_cluster, centers = num_clusters)

dframe$Cluster <- kmeans_model$cluster

output_payload <- list(
  centers = as.data.frame(kmeans_model$centers),
  data = dframe
)

cat(toJSON(output_payload, auto_unbox = TRUE, pretty = TRUE))
