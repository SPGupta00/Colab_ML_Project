import json
import os
import subprocess
from flask import Flask, jsonify, render_template, request

app = Flask(__name__)
R_PATH = "Rscript"


# --- HTML Page Routes ---
@app.route("/")
def home():
    return render_template("index.html")


@app.route("/kmeans")
def kmeans_page():
    return render_template("kmeans.html")


@app.route("/hierarchical")
def hierarchical_page():
    return render_template("hierarchical.html")


@app.route("/anomaly_detection_z_score")
def pca_page():
    return render_template("pcanomaly_detection_z_score.html")


# --- API Execution Routes ---
@app.route("/run-kmeans", methods=["POST"])
def run_kmeans():
    clusters = request.form.get("clusters", "3")
    try:
        result = subprocess.run(
            [R_PATH, "r_models/kmeans.R", "data/data.csv", clusters],
            capture_output=True,
            text=True,
        )
        if result.returncode != 0:
            return jsonify({"error": result.stderr}), 500
        return jsonify(json.loads(result.stdout))
    except Exception as e:
        return jsonify({"error": str(e)}), 500


@app.route("/run-hierarchical", methods=["POST"])
def run_hierarchical():
    try:
        result = subprocess.run(
            [R_PATH, "r_models/hierarchical.R", "data/data.csv"],
            capture_output=True,
            text=True,
        )
        if result.returncode != 0:
            return jsonify({"error": result.stderr}), 500
        return jsonify(json.loads(result.stdout))
    except Exception as e:
        return jsonify({"error": str(e)}), 500


@app.route("/run-anomaly_detection_z_score", methods=["POST"])
def run_pca():
    try:
        result = subprocess.run(
            [
                R_PATH,
                "r_models/anomaly_detection_z_scoring.R",
                "data/data.csv",
            ],
            capture_output=True,
            text=True,
        )
        if result.returncode != 0:
            return jsonify({"error": result.stderr}), 500
        return jsonify(json.loads(result.stdout))
    except Exception as e:
        return jsonify({"error": str(e)}), 500


if __name__ == "__main__":
    app.run(debug=True)
