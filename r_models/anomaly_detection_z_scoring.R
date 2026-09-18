dframe <- read.csv("data/data.csv")

data <- data.frame(dframe)

# Display the data
print(data)


# Step 2: Calculate the mean
# Mean = average value

mean_value <- mean(data)

# Display mean
print(mean_value)


# Step 3: Calculate standard deviation

sd_value <- sd(data)

# Display standard deviation
print(sd_value)


# Step 4: Calculate Z-score for every value
# Z-score tells us how far a value is from the mean

z_score <- (data - mean_value) / sd_value

# Display Z-scores
print(z_score)


# Step 5: Find anomalies
# If the absolute Z-score is greater than 2,
# we consider it an anomaly

anomaly <- abs(z_score) > 2


# Step 6: Display the anomaly result

print(anomaly)


# Step 7: Display only the anomaly values

print(data[anomaly])


# Step 8: Display normal values

print(data[!anomaly])

cat("Anomaly values are:\n")
print(data[anomaly])