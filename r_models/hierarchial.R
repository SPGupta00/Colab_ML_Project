data <- read.csv("data/data.csv")

dframe <- data.frame(data)

distance <- dist(dframe)

print(distance)


hc <- hclust(distance, method = "complete")

print(hc)

plot(
  hc,
  main = "Hierarchial Clustering Tech",
  xlab = "Annual Income",
  ylab = "Spending Score"
)