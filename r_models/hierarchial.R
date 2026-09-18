if (!requireNamespace("jsonlite", quietly = TRUE)) install.packages("jsonlite", repos="https://r-project.org")
library(jsonlite)

dframe <- read.csv("data/data.csv")

numeric_cols <- sapply(dframe, is.numeric)
data_cluster <- dframe[, numeric_cols, drop = FALSE]
data_cluster$id <- NULL
data_cluster$X <- NULL

distance <- dist(data_cluster)
hc <- hclust(distance, method = "complete")

dframe$Cluster <- cutree(hc, k = 3)

output_payload <- list(
  data = dframe
)

cat(toJSON(output_payload, auto_unbox = TRUE, pretty = TRUE))
