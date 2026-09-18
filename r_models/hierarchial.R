options(warn = -1)
if (!requireNamespace("jsonlite", quietly = TRUE)) {
  install.packages("jsonlite", repos="https://cloud.r-project.org")
}
suppressMessages(library(jsonlite))

# Read Data safely
dframe <- read.csv("data/data.csv")

# Clean numerical spaces
numeric_cols <- sapply(dframe, is.numeric)
data_cluster <- dframe[, numeric_cols, drop = FALSE]

# Safely eliminate identifier metrics if they exist
data_cluster$CustomerID <- NULL
data_cluster$id <- NULL
data_cluster$X <- NULL

# Clustering execution
distance <- dist(data_cluster)
hc <- hclust(distance, method = "complete")

# Split trees cleanly into 3 custom clusters
dframe$Cluster <- cutree(hc, k = 3)

# Build structure output
output_payload <- list(
  data = dframe
)

# Return clean JSON string
cat(toJSON(output_payload, auto_unbox = TRUE))
