from fastapi import FastAPI
import pickle
import pandas as pd
from pydantic import BaseModel

# -------------------------------
# APP INIT
# -------------------------------
app = FastAPI(title="AI Job & Salary Prediction API 🚀")

# -------------------------------
# LOAD MODELS
# -------------------------------
salary_model = pickle.load(open("salary_model.pkl", "rb"))
salary_columns = pickle.load(open("columns.pkl", "rb"))

job_model = pickle.load(open("job_model.pkl", "rb"))
job_columns = pickle.load(open("job_columns.pkl", "rb"))

# -------------------------------
# INPUT SCHEMA
# -------------------------------
class InputData(BaseModel):
    experience_years: int
    skills_count: int
    location: str
    education_level: str
    company_size: str
    job_title: str

# -------------------------------
# HOME ROUTE
# -------------------------------
@app.get("/")
def home():
    return {"message": "API is running 🚀 Use /docs to test"}

# -------------------------------
# SALARY PREDICTION
# -------------------------------
@app.post("/predict-salary")
def predict_salary(data: InputData):
    try:
        df = pd.DataFrame([data.dict()])
        df = pd.get_dummies(df)
        df = df.reindex(columns=salary_columns, fill_value=0)

        pred = salary_model.predict(df)

        return {
            "Predicted Salary (₹)": round(float(pred[0]), 2)
        }

    except Exception as e:
        return {"error": str(e)}

# -------------------------------
# JOB CHANCE PREDICTION
# -------------------------------
@app.post("/job-chance")
def job_chance(data: InputData):
    try:
        df = pd.DataFrame([data.dict()])
        df = pd.get_dummies(df)
        df = df.reindex(columns=job_columns, fill_value=0)

        prob = job_model.predict_proba(df)[0][1]

        # 🔥 smoothing (minimum 15%)
        prob = max(0.15, prob)

        return {
            "Job Chance (%)": round(prob * 100, 2)
        }

    except Exception as e:
        return {"error": str(e)}

# -------------------------------
# FEATURE IMPORTANCE (SALARY MODEL)
# -------------------------------
@app.get("/salary-importance")
def salary_importance():
    try:
        imp = salary_model.feature_importances_

        df = pd.DataFrame({
            "Feature": salary_columns,
            "Importance": imp
        }).sort_values(by="Importance", ascending=False)

        return df.head(10).to_dict(orient="records")

    except:
        return {"message": "Feature importance not available for this model"}

# -------------------------------
# FEATURE IMPORTANCE (JOB MODEL)
# -------------------------------
@app.get("/job-importance")
def job_importance():
    try:
        imp = job_model.feature_importances_

        df = pd.DataFrame({
            "Feature": job_columns,
            "Importance": imp
        }).sort_values(by="Importance", ascending=False)

        return df.head(10).to_dict(orient="records")

    except Exception as e:
        return {"error": str(e)}