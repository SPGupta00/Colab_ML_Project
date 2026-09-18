#K-MEANS CLUSTERING
# 1. Create the dataset
data <- read.csv("data/data.csv")

# print(data)
dframe <- data.frame(data)
data_cluster <- dframe[, c("AnnualIncome", "SpendingScore")]

# 2. Set seed and run K-means
set.seed(123)
kmeans_model <- kmeans(data_cluster, centers = 3)

# 3. Print model details and centroids
print(kmeans_model)
print(kmeans_model$centers)

# 4. Save cluster assignments (Fixed the lowercase 'c' typo here)
dframe$Cluster <- kmeans_model$cluster

# 5. Plot the data points colored by cluster
plot(
  dframe$AnnualIncome, dframe$SpendingScore,
  col = dframe$Cluster,
  pch = 19,
  main = "Annual Income Vs Spending Score",
  xlab = "Annual Income",
  ylab = "Spending Score"
)

# 6. Add the centroid stars to the plot
points(
  kmeans_model$centers[,"AnnualIncome"],
  kmeans_model$centers[,"SpendingScore"],
  pch = 8,
  cex = 2,
  lwd = 2
)
