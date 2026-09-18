import csv
import json
import math
import os
from flask import Flask, jsonify, render_template, request

app = Flask(__name__)


@app.route("/")
def home():
    return render_template("index.html")


@app.route("/kmeans")
def kmeans_page():
    return render_template("kmeans.html")


@app.route("/hierarchial")
def hierarchial_page():
    return render_template("hierarchial.html")


@app.route("/anomaly_detection_z_scoring")
def anomaly_detection_page():
    return render_template("anomaly_detection_z_scoring.html")


@app.route("/run-anomaly_detection_z_scoring", methods=["POST"])
def run_anomaly_model():
    try:
        csv_path = "data/data.csv"
        if not os.path.exists(csv_path):
            csv_path = os.path.join(os.path.dirname(__file__), "data/data.csv")

        customer_ids = []
        data_dict = {"Age": [], "AnnualIncome": [], "SpendingScore": []}

        with open(csv_path, mode="r", encoding="utf-8") as f:
            reader = csv.DictReader(f)
            for row in reader:
                customer_ids.append(int(row["CustomerID"]))
                data_dict["Age"].append(float(row["Age"]))
                data_dict["AnnualIncome"].append(float(row["AnnualIncome"]))
                data_dict["SpendingScore"].append(float(row["SpendingScore"]))

        results = {}

        for col_name, values in data_dict.items():
            n = len(values)
            mean_val = sum(values) / n
            variance = sum((x - mean_val) ** 2 for x in values) / (n - 1)
            sd_val = math.sqrt(variance)

            sorted_vals = sorted(values)
            median_val = (
                sorted_vals[n // 2]
                if n % 2 != 0
                else (sorted_vals[(n // 2) - 1] + sorted_vals[n // 2]) / 2.0
            )

            abs_deviations = [abs(x - median_val) for x in values]
            sorted_deviations = sorted(abs_deviations)
            mad_val = (
                sorted_deviations[n // 2]
                if n % 2 != 0
                else (
                    sorted_deviations[(n // 2) - 1] + sorted_deviations[n // 2]
                )
                / 2.0
            )
            mad_val = mad_val * 1.4826

            if mad_val == 0:
                mad_val = 1.0

            anomaly_ids = []
            anomaly_values = []

            for idx, val in enumerate(values):
                robust_z = (val - median_val) / mad_val
                if abs(robust_z) > 3.0:
                    anomaly_ids.append(customer_ids[idx])
                    anomaly_values.append(val)

            results[col_name] = {
                "mean": round(mean_val, 2),
                "sd": round(sd_val, 2),
                "has_anomalies": len(anomaly_ids) > 0,
                "anomaly_ids": anomaly_ids,
                "anomaly_values": anomaly_values,
            }

        return jsonify(results)

    except Exception as e:
        return jsonify({"error": str(e)}), 500


if __name__ == "__main__":
    app.run(debug=True)
