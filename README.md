<div align="center">

# 🧬 causalML

### Causal Machine Learning Analysis & Simulation Platform

<p align="center">
  <strong>An interactive Shiny application for causal effect estimation, simulation studies, and causal machine learning model comparison.</strong>
</p>

<br>

<a href="https://rhyme-causalml.share.connect.posit.cloud/">
  <img src="https://img.shields.io/badge/🚀%20LIVE%20SHINY%20APP-Open%20Application-2ea44f?style=for-the-badge" alt="Live Shiny App">
</a>

<a href="https://github.com/Rhyme-2002/causalML-Shiny">
  <img src="https://img.shields.io/badge/GitHub-causalML--Shiny-181717?style=for-the-badge&logo=github" alt="GitHub">
</a>

<br><br>

<img src="https://img.shields.io/badge/R-4.0%2B-276DC3?style=flat-square&logo=r" alt="R">
<img src="https://img.shields.io/badge/Shiny-Interactive-blue?style=flat-square" alt="Shiny">
<img src="https://img.shields.io/badge/Causal%20ML-Research-orange?style=flat-square" alt="Causal ML">
<img src="https://img.shields.io/badge/License-MIT-green?style=flat-square" alt="MIT License">

</div>

---

## 🚀 Live Application

<div align="center">

### Try the application online

<a href="https://rhyme-causalml.share.connect.posit.cloud/">

<img src="https://img.shields.io/badge/▶%20LAUNCH%20CAUSALML%20SHINY-2ea44f?style=for-the-badge" alt="Launch causalML">

</a>

<br><br>

**No R installation required.**

The application is deployed using **Posit Connect Cloud** and can be accessed directly from a web browser.

</div>

---

# 🧬 About causalML

**causalML** is an interactive **Causal Machine Learning Analysis & Simulation Platform** developed using **R and Shiny**.

The platform provides an integrated environment for researchers, students, and practitioners to investigate:

* Causal treatment effects
* Heterogeneous treatment effects
* CATE estimation
* ATE estimation
* Simulation-based methodological evaluation
* Causal machine learning model comparison
* Model performance under different data-generating mechanisms

The application allows users to upload their own observational dataset and interactively perform data preparation, simulation, causal estimation, visualization, and model evaluation.

---

# ✨ Why causalML?

<div align="center">

<table>
<tr>
<td align="center" width="25%">

### 📊

### Data Analysis

Upload and prepare your own observational data.

</td>

<td align="center" width="25%">

### 🧪

### Simulation

Generate repeated causal simulation experiments.

</td>

<td align="center" width="25%">

### 🧠

### Causal ML

Compare modern causal machine learning methods.

</td>

<td align="center" width="25%">

### 📈

### Evaluation

Evaluate CATE and ATE estimation accuracy.

</td>
</tr>
</table>

</div>

---

# 🎯 Main Features

<div align="center">

|           Feature          | Description                                  |
| :------------------------: | -------------------------------------------- |
|      📂 **CSV Upload**     | Upload your own observational dataset        |
|  🎯 **Variable Selection** | Select outcome, treatment, and confounders   |
|    🔢 **Design Matrix**    | Automatically prepare categorical covariates |
|   🧪 **Simulation Study**  | Perform repeated causal simulations          |
| 🤖 **Multiple Simulators** | Logistic, BART, GBM, Random Forest, and KNN  |
|   🌳 **Causal ML Models**  | Compare multiple causal estimation methods   |
|   📐 **CATE Estimation**   | Estimate heterogeneous treatment effects     |
|    📊 **ATE Estimation**   | Estimate average treatment effects           |
|         📉 **RMSE**        | Evaluate CATE estimation accuracy            |
|         ⚖️ **ARB**         | Evaluate ATE estimation accuracy             |
|    🏆 **Model Ranking**    | Compare models using simulation performance  |
|      📥 **Downloads**      | Download tables, matrices, and results       |

</div>

---

# 🖥️ Application Workflow

<div align="center">

```text
┌──────────────────────┐
│      Upload CSV      │
└──────────┬───────────┘
↓
┌──────────────────────┐
│ Select Outcome (Y)   │
│ Select Treatment (Z) │
│ Select Confounders X │
└──────────┬───────────┘
↓
┌──────────────────────┐
│   Data Preparation   │
│    Design Matrix     │
└──────────┬───────────┘
↓
┌──────────────────────┐
│  Simulation Study    │
│ Logistic / BART /    │
│ GBM / RF / KNN       │
└──────────┬───────────┘
↓
┌──────────────────────┐
│ Causal ML Estimation │
└──────────┬───────────┘
↓
┌──────────────────────┐
│ CATE & ATE Estimates │
└──────────┬───────────┘
↓
┌──────────────────────┐
│ RMSE & ARB Evaluation│
└──────────┬───────────┘
↓
┌──────────────────────┐
│ Model Ranking & Plots│
└──────────────────────┘
```

</div>

---

# 📐 Causal Effect Framework

Let:

* `Y` = binary outcome
* `Z ∈ {0,1}` = binary treatment
* `X` = observed covariates/confounders

The application considers the conditional outcome probabilities:

```text
π₀(x) = P(Y = 1 | X = x, Z = 0)

π₁(x) = P(Y = 1 | X = x, Z = 1)
```

The Conditional Average Treatment Effect is defined as:

```text
τ(x) = π₁(x) − π₀(x)
```

Therefore, the platform focuses on estimating how the treatment effect varies across individuals with different covariate profiles.

---

# 🧪 Simulation Framework

One of the main objectives of the application is to evaluate causal machine learning methods under controlled data-generating mechanisms.

The uploaded empirical data are used to preserve the observed structure of:

* Covariates
* Treatment assignment
* Covariate distributions

The outcome is then repeatedly simulated under a specified treatment-effect structure.

### Simulation pipeline

```text
Observed Data
     │
     ├── X: Covariates
     │
     └── Z: Treatment
             │
             ▼
     Estimate π₀(x), π₁(x)
             │
             ▼
      Treatment Effect
          γ(x)
             │
             ▼
    Adjusted π₁(x)
             │
             ▼
       True CATE
          τ(x)
             │
             ▼
      Generate Ysim
             │
             ▼
      Fit Causal ML
             │
             ▼
     Estimate CATE / ATE
             │
             ▼
       RMSE / ARB
```

---

# 🧠 Simulation Models

The platform supports multiple outcome-generating mechanisms.

<div align="center">

| Model | Method                  | Main Characteristics                 |
| :---: | :---------------------- | :----------------------------------- |
|   📈  | **Logistic Regression** | Parametric outcome model             |
|   🌳  | **BART**                | Bayesian nonlinear tree-based model  |
|   🚀  | **GBM**                 | Gradient boosting                    |
|   🌲  | **Random Forest**       | Ensemble tree-based learning         |
|   📍  | **KNN**                 | Local neighbourhood-based estimation |

</div>

### KNN Configuration

When **KNN** is selected as the simulation model, the application dynamically displays an input for the number of neighbours:

```text
k = number of nearest neighbours
```

This allows users to control the flexibility of the KNN-based probability estimation.

---

# 🤖 Causal Machine Learning Models

The platform allows users to select and compare several causal estimation approaches.

<div align="center">

<table>
<tr>
<th>Method</th>
<th>Purpose</th>
</tr>

<tr>
<td>🌳 <b>Causal MARS</b></td>
<td>Flexible nonlinear treatment-effect estimation</td>
</tr>

<tr>
<td>🚀 <b>Causal Boosting</b></td>
<td>Boosting-based heterogeneous treatment effects</td>
</tr>

<tr>
<td>🌲 <b>Causal Forest</b></td>
<td>Forest-based CATE estimation</td>
</tr>

<tr>
<td>🧠 <b>Causal BART</b></td>
<td>Bayesian tree-based causal estimation</td>
</tr>

<tr>
<td>🌳 <b>Additive Causal Forest</b></td>
<td>Additive treatment-effect modelling</td>
</tr>

<tr>
<td>📊 <b>Parametric Standardization</b></td>
<td>Regression-based causal effect estimation</td>
</tr>

</table>

</div>

---

# 📊 Model Evaluation

The application evaluates causal models using two primary performance metrics.

## 1. CATE Accuracy — RMSE

The Root Mean Squared Error is calculated as:

```text
RMSE =
√[ 1/n Σᵢ (τ̂ᵢ − τᵢ)² ]
```

where:

* `τ̂ᵢ` = estimated CATE
* `τᵢ` = true CATE

### Interpretation

**Lower RMSE → Better CATE estimation**

---

## 2. ATE Accuracy — Absolute Relative Bias

The Absolute Relative Bias is calculated as:

```text
ARB =
|ATÊ − ATE|
────────────── × 100%
   |ATE|
```

where:

* `ATÊ` = estimated ATE
* `ATE` = true ATE

### Interpretation

**Lower ARB → Better ATE estimation**

---

# 🔁 Repeated Simulation Study

Users can specify the number of simulation replications.

For every replication:

```text
1. Generate simulated outcome
2. Fit selected causal models
3. Estimate CATE
4. Estimate ATE
5. Calculate RMSE
6. Calculate ARB
7. Store results
```

The application then summarizes model performance across simulations.

### Model ranking

Models can be compared using:

* Median RMSE
* Median ARB

This provides a more robust summary of repeated simulation performance.

---

# 🏆 Model Comparison

The **Model Comparison** section provides:

### 📋 Simulation Results

Detailed results from each simulation replication.

### 📉 RMSE Plot

Visual comparison of CATE estimation accuracy.

### ⚖️ ARB Plot

Visual comparison of ATE estimation accuracy.

### 🏅 Model Ranking

Models are ranked according to their simulation performance.

---

# 🎯 Causal Effect Estimation

After completing the simulation study, users can perform causal effect estimation on the selected data.

The application provides:

* Selected causal model
* Estimated ATE
* Mean CATE
* Individual CATE estimates
* CATE table
* CATE visualization

This allows researchers to investigate both overall and heterogeneous treatment effects.

---

# 📂 Data Requirements

The application accepts **CSV files**.

A typical dataset should contain:

```text
Outcome
Treatment
Confounder 1
Confounder 2
Confounder 3
...
```

### Outcome

The outcome should be binary:

```text
Y ∈ {0, 1}
```

### Treatment

The treatment should be binary:

```text
Z ∈ {0, 1}
```

### Confounders

The application supports numerical and categorical confounders.

Categorical variables are converted into an appropriate design matrix before model fitting.

---

# 🔢 Design Matrix

The application automatically constructs a model/design matrix for selected confounders.

Conceptually:

```text
X
│
├── Numeric variables
│
├── Binary variables
│
└── Categorical variables
          │
          ▼
    Dummy variables
          │
          ▼
    Design Matrix
```

The resulting matrix can be viewed and downloaded from the application.

---

# 📥 Downloadable Outputs

The platform provides several downloadable outputs.

<div align="center">

| Output                | Available |
| :-------------------- | :-------: |
| 📋 Data Preview       |     ✅     |
| 🔢 Design Matrix      |     ✅     |
| 📊 Simulation Results |     ✅     |
| 🏆 Model Ranking      |     ✅     |
| 📈 RMSE Results       |     ✅     |
| ⚖️ ARB Results        |     ✅     |
| 🎯 CATE Estimates     |     ✅     |
| 📊 ATE Results        |     ✅     |
| 📉 CATE Plot          |     ✅     |

</div>

---

# 🧰 Technology Stack

<div align="center">

<img src="https://img.shields.io/badge/R-276DC3?style=for-the-badge&logo=r&logoColor=white">
<img src="https://img.shields.io/badge/Shiny-0072B2?style=for-the-badge">
<img src="https://img.shields.io/badge/ggplot2-1F77B4?style=for-the-badge">
<img src="https://img.shields.io/badge/dplyr-2C3E50?style=for-the-badge">
<img src="https://img.shields.io/badge/DT-4B0082?style=for-the-badge">

</div>

The application is primarily developed using:

* **R**
* **Shiny**
* **DT**
* **ggplot2**
* **dplyr**
* **causalML**

Additional causal machine learning packages are used depending on the selected model.

---

# 📦 causalML R Package

This Shiny application uses the companion **causalML R package**.

### GitHub

<a href="https://github.com/Rhyme-2002/causalML">

https://github.com/Rhyme-2002/causalML

</a>

### Installation

```r
install.packages("remotes")

remotes::install_github("Rhyme-2002/causalML")
```

Load the package:

```r
library(causalML)
```

---

# 💻 Run Locally

Clone the repository:

```bash
git clone https://github.com/Rhyme-2002/causalML-Shiny.git
```

Move to the project directory:

```bash
cd causalML-Shiny
```

Open the project in RStudio and run:

```r
shiny::runApp()
```

Or simply open `App.R` and click:

```text
Run App
```

---

# 📁 Repository Structure

```text
causalML-Shiny/
│
├── App.R
├── manifest.json
├── README.md
└── data_data.csv
```

### `App.R`

Contains the complete Shiny application, including:

* UI
* Server
* Data processing
* Simulation framework
* Causal estimation
* Model comparison
* Visualization
* Download handlers

### `manifest.json`

Deployment configuration for Posit Connect Cloud.

### `README.md`

Project documentation and methodological description.

---

# ☁️ Deployment

The application is deployed through:

### Posit Connect Cloud

<div align="center">

<a href="https://rhyme-causalml.share.connect.posit.cloud/">

<img src="https://img.shields.io/badge/☁️%20Posit%20Connect%20Cloud-Live-447099?style=for-the-badge" alt="Posit Connect Cloud">

</a>

</div>

---

# ⚠️ Important Considerations

The results generated by the application depend on:

* The quality of the uploaded data
* Correct identification of treatment and outcome
* Selection of appropriate confounders
* Data preprocessing
* Simulation model
* Causal estimation method
* Treatment-effect specification
* Number of simulations
* Statistical assumptions

The application is intended primarily for:

> **Research, educational, exploratory, and methodological evaluation.**

Results should be interpreted according to the assumptions of the selected causal method and data-generating mechanism.

---

# 🔬 Research Applications

The platform can be useful for investigating questions such as:

> **Which causal machine learning method performs best under a particular data-generating mechanism?**

For example:

```text
Simulation Model
       ↓
   Logistic
       ↓
Causal ML Methods
       ↓
MARS / Boosting / Forest / BART
       ↓
Compare Performance
       ↓
RMSE + ARB
       ↓
Best Performing Model
```

The same framework can then be repeated under:

```text
BART
GBM
Random Forest
KNN
```

This makes the platform useful for systematic methodological simulation studies.

---

# 🌟 Project Highlights

<div align="center">

### One Platform

**Data → Simulation → Causal ML → Evaluation → Visualization**

<br>

| 🧪 Simulation |      🤖 Causal ML      | 📊 Evaluation |
| :-----------: | :--------------------: | :-----------: |
|    Logistic   |       Causal MARS      |      RMSE     |
|      BART     |     Causal Boosting    |      ARB      |
|      GBM      |      Causal Forest     |  Median RMSE  |
| Random Forest |       Causal BART      |   Median ARB  |
|      KNN      | Additive Causal Forest | Model Ranking |

</div>

---

# 🔗 Project Links

<div align="center">

### 🚀 Live Application

<a href="https://rhyme-causalml.share.connect.posit.cloud/">
https://rhyme-causalml.share.connect.posit.cloud/
</a>

<br><br>

### 💻 Shiny Source Code

<a href="https://github.com/Rhyme-2002/causalML-Shiny">
https://github.com/Rhyme-2002/causalML-Shiny
</a>

<br><br>

### 📦 causalML R Package

<a href="https://github.com/Rhyme-2002/causalML">
https://github.com/Rhyme-2002/causalML
</a>

</div>

---

# 👨‍💻 Developer

<div align="center">

## Abu Sufiun Rhyme

**Data Analyst | Statistician | Causal Machine Learning Researcher**

📧 **[asrhyme@isrt.ac.bd](mailto:asrhyme@isrt.ac.bd)**

</div>

---

# 📄 License

This project is released under the **MIT License**.

---

<div align="center">

### 🧬 causalML

**Causal Machine Learning Analysis & Simulation Platform**

<br>

⭐ If you find this project useful, consider giving the repository a star!

<br>

<a href="https://github.com/Rhyme-2002/causalML-Shiny">
<img src="https://img.shields.io/github/stars/Rhyme-2002/causalML-Shiny?style=for-the-badge&logo=github" alt="GitHub Stars">
</a>

<a href="https://github.com/Rhyme-2002/causalML-Shiny">
<img src="https://img.shields.io/github/forks/Rhyme-2002/causalML-Shiny?style=for-the-badge&logo=github" alt="GitHub Forks">
</a>

<br><br>

**Built with ❤️ using R + Shiny**

</div>
