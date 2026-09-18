# Prevent R from printing warning messages or package loading text to stdout
options(warn = -1)
suppressMessages(library(jsonlite))

# 1. Parse arguments safely
args <- commandArgs(trailingOnly = TRUE)
data_path <- if (length(args) >= 1) args[1] else "data/data.csv"
num_clusters <- if (length(args) >= 2) as.numeric(args[2]) else 3

# 2. Load dataset 
data <- read.csv(data_path)
data_cluster <- data[, c("AnnualIncome", "SpendingScore")]

# 3. Process K-Means
set.seed(123)
kmeans_model <- kmeans(data_cluster, centers = num_clusters)

# 4. Generate and save the visualization plot quietly
if (!dir.exists("static")) {
  dir.create("static")
}
plot_path <- "static/kmeans_plot.png"

# Open the PNG engine silently
png(filename = plot_path, width = 800, height = 600)

plot(
  data$AnnualIncome, data$SpendingScore,
  col = kmeans_model$cluster,
  pch = 19,
  main = paste("Annual Income Vs Spending Score (K =", num_clusters, ")"),
  xlab = "Annual Income",
  ylab = "Spending Score"
)

points(
  kmeans_model$centers[, "AnnualIncome"],
  kmeans_model$centers[, "SpendingScore"],
  pch = 8,
  cex = 2,
  lwd = 2
)

invisible(dev.off()) # Close device without printing text output

# 5. Build clean list object
output_data <- list(
  model = "K-Means Clustering Analysis",
  total_points = as.numeric(nrow(data)),
  clusters = as.numeric(num_clusters),
  cluster_sizes = as.vector(kmeans_model$size),
  plot_url = paste0("/", plot_path)
)

# 6. Output ONLY the JSON string
cat(toJSON(output_data, auto_unbox = TRUE))