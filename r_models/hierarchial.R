options(warn = -1)
if (!requireNamespace("jsonlite", quietly = TRUE)) {
  install.packages("jsonlite", repos="https://cloud.r-project.org")
}
suppressMessages(library(jsonlite))

# 1. Read Data safely
dframe <- read.csv("data/data.csv")

# 2. Filter numeric dimensions for matrix parsing
numeric_cols <- sapply(dframe, is.numeric)
data_cluster <- dframe[, numeric_cols, drop = FALSE]

# 3. Eliminate non-features / identifiers
data_cluster$CustomerID <- NULL
data_cluster$id <- NULL
data_cluster$X <- NULL

# 4. Process hierarchical tree execution
distance <- dist(data_cluster)
hc <- hclust(distance, method = "complete")

# 5. Segment into 3 discrete clusters
dframe$Cluster <- cutree(hc, k = 3)

# 6. Check and generate static asset directory if missing
if (!dir.exists("static")) {
  dir.create("static")
}

# 7. Render and save the dendrogram plot quietly to disk
plot_path <- "static/hierarchical_plot.png"
png(filename = plot_path, width = 800, height = 600)

plot(
  hc, 
  main = "Hierarchical Clustering Dendrogram", 
  xlab = "Customer Samples", 
  sub = "", 
  labels = dframe$CustomerID
)

invisible(dev.off()) # Close device without printing text confirmations to stdout

# 8. Consolidate EVERYTHING into ONE final payload list structure
output_payload <- list(
  data = dframe,
  plot_url = paste0("/", plot_path)
)

# 9. Print ONLY a single valid JSON string back to Flask's interpreter pipeline
cat(toJSON(output_payload, auto_unbox = TRUE))
