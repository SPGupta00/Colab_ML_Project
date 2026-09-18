
data <- read.csv("data/data.csv")

dframe <- data.frame(data)
data_cluster <- dframe[, c("AnnualIncome", "SpendingScore")]

set.seed(123)
kmeans_model <- kmeans(data_cluster, centers = 3)

print(kmeans_model)
print(kmeans_model$centers)

dframe$Cluster <- kmeans_model$cluster

plot(
  dframe$AnnualIncome, dframe$SpendingScore,
  col = dframe$Cluster,
  pch = 19,
  main = "Annual Income Vs Spending Score",
  xlab = "Annual Income",
  ylab = "Spending Score"
)

points(
  kmeans_model$centers[,"AnnualIncome"],
  kmeans_model$centers[,"SpendingScore"],
  pch = 8,
  cex = 2,
  lwd = 2
)
