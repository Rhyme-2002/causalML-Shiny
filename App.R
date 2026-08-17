library(shiny)
library(DT)
library(ggplot2)
library(dplyr)
library(causalML)


# ============================================================
# OPTIONAL DEPENDENCY CHECKS
# ============================================================

required_packages <- c(
  "grf",
  "bcf",
  "BART",
  "gbm",
  "randomForest",
  "class"
)

missing_packages <- required_packages[
  !vapply(
    required_packages,
    requireNamespace,
    logical(1),
    quietly = TRUE
  )
]


# MODEL LABELS

causal_model_choices <- c(
  "Causal MARS" = "causalMARS",
  "Causal Boosting" = "causal_boosting",
  "Causal Forest" = "causal_forest",
  "Causal BART - Without PS" = "causal_BART",
  "Causal BART - With PS" = "causal_BART_PS",
  "Additive Causal Forest" = "causal_Additive_Forest",
  "Parametric Standardization" = "parametric_standardization")

# SIMULATION MODELS
simulation_choices <- c("Logistic Regression" ="logit",
                        "BART" = "BART",
                        "GBM" = "GBM",
                        "Random Forest" = "Random_Forest",
                        "KNN" = "KNN")

# CSS
custom_css <- "
body {
  background: linear-gradient(
    135deg,
    #f8fafc 0%,
    #eef4ff 100%
  );

  font-family:
    'Segoe UI',
    Arial,
    sans-serif;

  color: #172033;
}

.container-fluid {
  padding-left: 25px;
  padding-right: 25px;
}

.app-header {

  background:
    linear-gradient(
      135deg,
      #0f172a 0%,
      #1e3a8a 45%,
      #2563eb 100%
    );

  color: white;

  padding:
    35px
    38px;

  margin:
    -15px
    -15px
    28px
    -15px;

  border-radius:
    0
    0
    28px
    28px;

  box-shadow:
    0 10px 35px
    rgba(15,23,42,0.20);
}

.app-title {

  font-size: 38px;

  font-weight: 800;

  letter-spacing: -1px;

  margin-bottom: 5px;
}

.app-subtitle {

  font-size: 16px;

  opacity: 0.90;
}

.header-badge {

  display: inline-block;

  margin-top: 15px;

  padding:
    7px
    14px;

  border-radius: 30px;

  background:
    rgba(255,255,255,0.15);

  border:
    1px solid
    rgba(255,255,255,0.25);

  font-size: 12px;
}

.well {

  background: transparent;

  border: none;

  box-shadow: none;

  padding: 0;
}

.sidebar-card {

  background:
    rgba(255,255,255,0.96);

  border-radius: 18px;

  padding: 20px;

  margin-bottom: 18px;

  box-shadow:
    0 8px 25px
    rgba(15,23,42,0.07);

  border:
    1px solid
    #e5eaf3;
}

.sidebar-card:hover {

  box-shadow:
    0 12px 30px
    rgba(15,23,42,0.10);
}

.section-title {

  color: #172554;

  font-size: 18px;

  font-weight: 750;

  margin-bottom: 17px;
}

.stage-number {

  display: inline-flex;

  align-items: center;

  justify-content: center;

  width: 31px;

  height: 31px;

  border-radius: 50%;

  background:
    linear-gradient(
      135deg,
      #2563eb,
      #4f46e5
    );

  color: white;

  font-weight: 800;

  margin-right: 8px;
}

.result-card {

  background:
    rgba(255,255,255,0.98);

  border-radius: 20px;

  padding: 25px;

  margin-bottom: 22px;

  border:
    1px solid
    #e5eaf3;

  box-shadow:
    0 8px 30px
    rgba(15,23,42,0.07);
}

.result-card:hover {

  box-shadow:
    0 12px 35px
    rgba(15,23,42,0.10);
}

.metric-card {

  background:
    linear-gradient(
      135deg,
      #ffffff,
      #f8fbff
    );

  border:
    1px solid
    #dbe5f5;

  border-radius: 18px;

  padding: 23px;

  min-height: 125px;

  box-shadow:
    0 7px 22px
    rgba(15,23,42,0.06);
}

.metric-label {

  color: #64748b;

  font-size: 13px;

  font-weight: 650;

  text-transform: uppercase;

  letter-spacing: 0.7px;
}

.metric-value {

  color: #1e3a8a;

  font-size: 26px;

  font-weight: 800;

  margin-top: 8px;
}

.upload-box {

  background:
    linear-gradient(
      135deg,
      #eff6ff,
      #eef2ff
    );

  border:
    2px dashed
    #93c5fd;

  border-radius: 15px;

  padding: 14px;
}

.btn {

  border-radius:
    10px !important;

  font-weight: 650;

  border: none !important;

  padding:
    9px
    16px;
}

.btn-primary {

  background:
    linear-gradient(
      135deg,
      #2563eb,
      #4f46e5
    ) !important;
}

.btn-success {

  background:
    linear-gradient(
      135deg,
      #059669,
      #16a34a
    ) !important;
}

.btn-info {

  background:
    linear-gradient(
      135deg,
      #0284c7,
      #0891b2
    ) !important;
}

.shiny-download-link {

  display: inline-block;

  margin-top: 10px;

  padding:
    9px
    16px;

  border-radius: 9px;

  background:
    linear-gradient(
      135deg,
      #0f766e,
      #0d9488
    );

  color: white !important;

  text-decoration: none;

  font-weight: 650;
}

.checkbox {

  margin-top: 8px;

  margin-bottom: 8px;
}

.checkbox label {

  font-weight: 500;

  color: #334155;
}

.checkbox input[type='checkbox'] {

  margin-right: 8px;
}

.nav-tabs {

  border-bottom:
    2px solid
    #e2e8f0;

  margin-bottom: 20px;
}

.nav-tabs > li > a {

  border: none !important;

  border-radius:
    10px
    10px
    0
    0;

  color: #64748b;

  font-weight: 700;

  padding:
    13px
    18px;
}

.nav-tabs > li.active > a,
.nav-tabs > li.active > a:hover {

  color:
    #1d4ed8 !important;

  background:
    #eff6ff !important;

  border: none !important;
}

.form-control,
.selectize-input {

  border-radius:
    9px !important;

  border:
    1px solid
    #d7deea !important;

  box-shadow: none !important;
}

.form-control:focus,
.selectize-input.focus {

  border-color:
    #60a5fa !important;
}

.dataTables_wrapper {

  font-size: 13px;
}

table.dataTable thead th {

  background:
    #eff6ff;

  color:
    #1e3a8a;

  font-weight: 750;
}

.dataTables_filter input {

  border-radius:
    8px !important;
}

.info-box {

  background:
    #f8fafc;

  border-left:
    4px solid
    #3b82f6;

  border-radius:
    10px;

  padding:
    13px
    16px;

  color:
    #475569;

  font-size:
    13px;

  margin-bottom:
    15px;
}

.small-note {

  color:
    #64748b;

  font-size:
    12px;
}

.status-box {

  padding:
    12px
    15px;

  border-radius:
    10px;

  background:
    #f0fdf4;

  border:
    1px solid
    #bbf7d0;

  color:
    #166534;

  font-weight:
    600;
}

.model-box {

  background:
    #f8fafc;

  border:
    1px solid
    #e2e8f0;

  border-radius:
    12px;

  padding:
    12px
    15px;

  margin-bottom:
    10px;
}

"

# UI
ui <- fluidPage(tags$head(tags$style(HTML(custom_css))),
                
  # HEADER
  div(class = "app-header",
      div(class = "app-title", "causalML"),
      div(class = "app-subtitle", "Causal Machine Learning Analysis & Simulation Platform"),
      div(class = "header-badge",
          icon("project-diagram")," Causal Inference • Machine Learning • Simulation")),
sidebarLayout(
    # SIDEBAR
    sidebarPanel(width = 3,
      # DATA
      div(class = "sidebar-card",
          div(class = "section-title",
              span(class = "stage-number", "1"),
          "Data"),
          div(class = "upload-box", fileInput("file", "Upload CSV dataset",
                                              accept = c(".csv", "text/csv"),
            width = "100%"),
          div(class = "small-note", "Upload a CSV file to begin."))),
      
      # DATA PREPARATION
      div(class = "sidebar-card", 
          div(class = "section-title",
              span(class = "stage-number", "2"),
              "Data Preparation"),
          uiOutput("outcome_ui"),
          uiOutput("treatment_ui"),
          uiOutput("confounder_ui")),

      # MODEL COMPARISON
      div(class = "sidebar-card", 
          div(class = "section-title",
              span(class = "stage-number", "3"),
          "Model Comparison"),

        radioButtons("simulation_model", "Simulation model:",
                     choices = simulation_choices,
                     selected =  "logit",
                     inline = FALSE),
        conditionalPanel(condition = "input.simulation_model == 'KNN'", numericInput(
            "knn_k", "KNN k:", value = 5, min = 1, max = 99, step = 2)),
        checkboxInput("use_or", "Use fixed odds ratio (OR)", value = FALSE),
        
        
        conditionalPanel(condition = "input.use_or == true",
                         numericInput("OR", "Odds ratio (OR):", value = 1.5, min = 0.01, step = 0.1)),
        numericInput("sim", "Number of simulations:", value = 10, min = 1, max = 5000, step = 1),
        div(class = "small-note", " "), ## RMSE and ARB are calculated separately for every simulation. No mean RMSE or mean ARB is displayed.
        br(),
        checkboxGroupInput("compare_models", "Select causal models:",
                           choices = causal_model_choices, 
                           selected = c("causalMARS", "causal_boosting", "causal_forest", "causal_BART", "causal_Additive_Forest", "parametric_standardization")),
        actionButton("run_comparison", "Run Model Comparison",
                     icon = icon("play"), class = "btn-primary", width = "100%")
        ),

      # CAUSAL EFFECT
      div(class = "sidebar-card",
          div(class = "section-title", span(class = "stage-number", "4"),
          "Causal Effect"),
        uiOutput("estimate_model_ui"),
        uiOutput("bart_ps_ui"),
        actionButton("estimate_effect", "Estimate Causal Effect", icon = icon("calculator"),
                     class = "btn-success", width = "100%"))
    ),

    # MAIN PANEL
    mainPanel(width = 9, tabsetPanel(
      
        # DATA
        tabPanel("Data", br(), uiOutput("data_page_ui")),

        # DATA PREPARATION
        tabPanel("Data Preparation", br(),
                 div(class = "result-card",
                     div(class = "section-title", "Analysis Variables"),
                     DTOutput("selected_variables_table"),
                     downloadButton("download_selected_variables", "Download Selected Variables", class = "btn-info")),
                 div(class = "result-card", div(class = "section-title", "Design Matrix"),
            DTOutput("model_matrix_table"),
            downloadButton("download_model_matrix", "Download Design Matrix", class = "btn-info"))),

        # MODEL COMPARISON
        tabPanel("Model Comparison", br(),
                 div(class = "result-card",
                     div(class = "section-title", "Simulation Results"),
                     div(class = "info-box", icon("info-circle"),
                         " Each row represents one simulation-model combination."),
                     DTOutput("comparison_table"), br(),
                     downloadButton("download_comparison", "Download All Simulation Results", class = "btn-info")),
                 fluidRow(column(6, div(class = "metric-card",
                                        div(class = "metric-label", "Best RMSE Model"),
                                        div(class = "metric-value", textOutput("best_rmse")))),
                          column(6, div(class = "metric-card",
                                        div(class = "metric-label", "Best ARB Model"),
                                        div(class = "metric-value", textOutput("best_arb"))))),
                 br(),
                 div(class = "result-card",
                     div(class = "section-title", "Model Ranking"),
                     div(class = "info-box", icon("info-circle"),
                         "Ranking uses the median RMSE and median ARB across simulations."),
                     DTOutput("model_ranking_table"),
                     downloadButton("download_model_ranking", "Download Model Ranking",
                                    class = "btn-info")),
                 div(class = "result-card",
                     div(class = "section-title", "RMSE Across Simulations"),
                     plotOutput( "rmse_plot", height = "500px"),
                     downloadButton("download_rmse_plot", "Download RMSE Plot", class = "btn-info")),
                 div(class = "result-card",
                     div(class = "section-title", "ARB Across Simulations"), 
                     plotOutput("arb_plot", height = "500px"),
                     downloadButton("download_arb_plot", "Download ARB Plot", class = "btn-info"))),

        # CAUSAL EFFECT
        tabPanel("Causal Effect", br(), 
                 div(class = "result-card",
                     div(class = "section-title", "Selected Causal Method"),
                     verbatimTextOutput("selected_model")),
                 fluidRow(column(6, div(class = "metric-card",
                                        div(class = "metric-label", "Average Treatment Effect"),
                                        div(class = "metric-value", textOutput("ate_metric")))),
                          column(6, div(class = "metric-card", div(class = "metric-label", "Mean CATE"),
                                        div(class = "metric-value", textOutput("mean_cate_metric"))))),
                 br(), div(class = "result-card", 
                           div(class = "section-title", "Estimated ATE"),
                           verbatimTextOutput("ate_result"),
                           downloadButton("download_ate", "Download ATE", class = "btn-info")),
                 div(class = "result-card",
                     div(class = "section-title", "CATE"),
                     DTOutput("cate_table"),
                     downloadButton("download_cate", "Download CATE", class = "btn-info")),
                 div(class = "result-card",
                     div(class = "section-title", "CATE Distribution"),
                     plotOutput("cate_plot", height = "500px"),
                     downloadButton("download_cate_plot", "Download CATE Plot", class = "btn-info")),
                 div(class = "result-card",
                     div(class = "section-title", "Complete Causal Model Result"),
                     verbatimTextOutput("complete_result"),
                     downloadButton("download_complete_result", "Download Complete Result", class = "btn-info"))),
        
        ## ABOUT
        tabPanel("About", br(),
                 div(class = "result-card",
                     h2("About causalML"),
                     p("causalML is an interactive and general purpose causal machine learning dashboard developed in R. It provides an integrated framework for data preparation, empirical-data-based simulation, causal treatment-effect estimation, model comparison, and performance evaluation."),
                     p("The dashboard is designed for researchers, students, and practitioners who want to investigate causal machine learning methods using observational data. It is not restricted to a specific dataset, population, treatment, outcome, or research topic."),
                     p("Users can upload their own dataset, select the outcome, treatment, and confounding variables, identify categorical confounders, choose a simulation model, specify the number of simulation replications, and compare multiple causal machine learning methods."),
                     h4("General Causal Framework"),
                     p("Let Y denote a binary outcome, Z ∈ {0,1} denote a binary treatment indicator, and X denote a vector of observed covariates or confounders."),
                     div(class = "info-box",
                         HTML("<strong>Y ∈ {0,1}, &nbsp;&nbsp; Z ∈ {0,1}, &nbsp;&nbsp; X = observed covariates</strong>")),
                     p("The framework considers two potential outcomes corresponding to the treatment and control conditions. The objective is to estimate heterogeneous treatment effects while allowing the relationship between covariates and the outcome to be flexible and potentially nonlinear."),
                     h4("Simulation Experiments"),
                     p("The simulation framework uses the uploaded empirical dataset as the basis for generating simulated outcomes. The observed covariates and treatment assignment are retained from the empirical data, while the binary outcome is repeatedly generated from an estimated conditional outcome probability surface."),
                     p("This empirical-data-based simulation approach allows the simulation experiment to preserve the observed covariate structure and treatment assignment of the uploaded dataset while introducing a controlled treatment effect."),
                     h4("Data-Generating Procedure"),
                     p("The simulation procedure consists of four main steps."),
                     h5("Step 1: Estimation of Conditional Outcome Probabilities"),
                     p("For each treatment level z, the conditional probability of the binary outcome is estimated using the selected simulation model:"),
                     div(class = "info-box",
                         HTML("<strong>π<sub>z</sub>(x) = P(Y = 1 | X = x, Z = z)</strong>")),
                     p("Two conditional outcome probability surfaces are obtained:"),
                     div(class = "info-box",
                         HTML("<strong>π<sub>0</sub>(x) = P(Y = 1 | X = x, Z = 0)</strong><br><br>",
                              "<strong>π<sub>1</sub>(x) = P(Y = 1 | X = x, Z = 1)</strong>")),
                     p("Here, π₀(x) represents the estimated probability of the outcome under control, while π₁(x) represents the estimated probability under treatment."),
                     h5("Step 2: Construction of the Treatment Effect on the Logit Scale"),
                     p("The estimated conditional probabilities are transformed to the logit scale. The treatment-effect function is defined as:"),
                     div(class = "info-box",
                         HTML("<strong>γ(x) = logit[π<sub>1</sub>(x)] − logit[π<sub>0</sub>(x)] + c</strong>")),
                     p("where c is a calibration constant. The constant is determined iteratively so that the mean of γ(x) corresponds to the specified marginal treatment effect on the log-odds scale."),
                     p("When a fixed odds ratio is specified, the target log-odds ratio is used for calibration:"),
                     div(class = "info-box",
                         HTML("<strong>log(OR) = log-odds ratio</strong>")),
                     p("This calibration allows the simulation procedure to control the overall treatment effect while retaining heterogeneity across individual covariate profiles."),
                     h5("Step 3: Adjusted Treatment Probability and CATE"),
                     p("The treatment probability is recalculated using the constructed treatment-effect function:"),
                     div(class = "info-box",
                         HTML("<strong>π<sub>1,adjusted</sub>(x) = logit<sup>−1</sup>[logit{π<sub>0</sub>(x)} + γ(x)]</strong>")),
                     p("The conditional average treatment effect is then expressed on the probability scale as a risk difference:"),
                     div(class = "info-box",
                         HTML("<strong>τ(x) = π<sub>1,adjusted</sub>(x) − π<sub>0</sub>(x)</strong>")),
                     p("The function τ(x) represents the true conditional treatment effect used as the reference value when evaluating the causal machine learning methods."),
                     h5("Step 4: Generation of the Factual Outcome Probability"),
                     p("For each observation, only one treatment condition is observed. Therefore, the probability used to generate the observed or factual outcome depends on the observed treatment assignment Z."),
                     div(class = "info-box",
                         HTML("<strong>π<sub>factual</sub>(x) = Zπ<sub>1,adjusted</sub>(x) + (1 − Z)π<sub>0</sub>(x)</strong>")),
                     p("Consequently, when Z = 1, the factual probability is the adjusted treatment probability, whereas when Z = 0, the factual probability is the control probability:"),
                     div(class = "info-box",
                         HTML(
                           "<strong>π<sub>factual</sub>(x) = π<sub>1,adjusted</sub>(x)</strong> &nbsp; when &nbsp; <strong>Z = 1</strong><br><br>",
                           "<strong>π<sub>factual</sub>(x) = π<sub>0</sub>(x)</strong> &nbsp; when &nbsp; <strong>Z = 0</strong>")),
                     p("Finally, the binary factual outcome is generated from a Bernoulli distribution:"),
                     div(class = "info-box",
                         HTML("<strong>Y<sub>sim</sub> ~ Bernoulli(π<sub>factual</sub>(x))</strong>")),
                     h4("Simulation Workflow"),
                     p("The complete data-generating process can be summarized as:"),
                     div(class = "info-box",
                         HTML("<strong>X, Z</strong> → <strong>π<sub>0</sub>(x), π<sub>1</sub>(x)</strong> → <strong>γ(x)</strong> → <strong>π<sub>1,adjusted</sub>(x)</strong> → <strong>τ(x)</strong> → <strong>π<sub>factual</sub>(x)</strong> → <strong>Y<sub>sim</sub></strong>")),
                     tags$ol(
                       tags$li("Retain the observed covariates X and treatment assignment Z."),
                       tags$li("Estimate the conditional probabilities π₀(x) and π₁(x)."),
                       tags$li("Construct the treatment-effect function γ(x) on the logit scale."),
                       tags$li("Calibrate the treatment effect using the specified odds ratio when applicable."),
                       tags$li("Calculate the adjusted treatment probability π₁,adjusted(x)."),
                       tags$li("Calculate the true conditional treatment effect τ(x)."),
                       tags$li("Construct the factual probability according to the observed treatment assignment."),
                       tags$li("Generate the binary simulated outcome from a Bernoulli distribution."),
                       tags$li("Repeat the outcome-generation process for the user-specified number of simulations."),
                       tags$li("Fit the selected causal machine learning models to each simulated dataset."),
                       tags$li("Compare the estimated treatment effects with the known true treatment effects.")),
                     h4("Simulation Models"),
                     p("The simulation model determines how the conditional outcome probability surface is estimated. The dashboard currently supports the following models:"),
                     tags$ul(
                       tags$li(
                         strong("Logistic Regression: "),
                         "a parametric logistic regression model for estimating the conditional outcome probability."),
                       tags$li(
                         strong("BART: "),
                         "Bayesian Additive Regression Trees for flexible and nonlinear probability estimation."),
                       tags$li(
                         strong("GBM: "),
                         "Gradient Boosting Machine for nonlinear outcome modelling."),
                       tags$li(
                         strong("Random Forest: "),
                         "an ensemble tree-based machine learning method for estimating outcome probabilities."),
                       tags$li(
                         strong("KNN: "),
                         "k-Nearest Neighbours for estimating conditional outcome probabilities, where the value of k is specified by the user.")),
                     p("The simulation model is separate from the causal estimation model. Therefore, users can investigate how different causal methods perform under different outcome-generating mechanisms."),
                     h4("Causal Machine Learning Models"),
                     p("After each simulated outcome is generated, the selected causal models are fitted to estimate heterogeneous treatment effects."),
                     tags$ul(
                       tags$li(strong("Causal MARS")),
                       tags$li(strong("Causal Boosting")),
                       tags$li(strong("Causal Forest")),
                       tags$li(strong("Causal BART - Without PS")),
                       tags$li(strong("Causal BART - With PS")),
                       tags$li(strong("Additive Causal Forest")),
                       tags$li(strong("Parametric Standardization"))),
                     h4("Performance Evaluation"),
                     p("The simulation framework evaluates causal model performance using both heterogeneous treatment effects and average treatment effects."),
                     h5("CATE Evaluation: Root Mean Squared Error"),
                     p("The Root Mean Squared Error (RMSE) measures the discrepancy between the estimated CATE and the known true CATE:"),
                     div(
                       class = "info-box",
                       HTML(
                         "<div style='font-size:18px; text-align:center; padding:12px;'>
                             <strong>RMSE</strong> =
                             <span style='font-size:24px;'>√</span>
                             <span style='border-top:2px solid #333; padding-top:3px;'>
                             <span style='font-size:16px;'>1</span>/<span style='font-size:16px;'>n</span>
                             &nbsp;Σ<sub>i=1</sub><sup>n</sup>
                             (CATE<sub>estimated,i</sub> − CATE<sub>true,i</sub>)<sup>2</sup>
                             </span>
                             </div>")),
                     p("A smaller RMSE indicates more accurate recovery of the heterogeneous treatment-effect function."),
                     h5("ATE Evaluation: Absolute Relative Bias"),
                     div(
                       class = "info-box",
                       HTML(
                         "<div style='font-size:18px; text-align:center; padding:12px;'>
                             <strong>ARB</strong> =
                             <span style='font-size:22px;'>|</span>
                             <span style='display:inline-block; text-align:center; vertical-align:middle;'>
                             <span style='border-bottom:2px solid #333; padding:0 8px;'>
                             ATE<sub>estimated</sub> − ATE<sub>true</sub>
                             </span>
                             <br>
                             <span style='padding:0 8px;'>ATE<sub>true</sub></span>
                             </span>
                             <span style='font-size:22px;'>| × 100%</span>
                             </div>")),
                     p("A smaller ARB indicates that the estimated ATE is closer to the known true ATE."),
                     h4("Repeated Simulation Experiments"),
                     p("The user can specify the number of simulation replications. For each replication, a new binary outcome is generated from the same estimated probability surface while the empirical covariates and treatment assignment are retained."),
                     p("Each selected causal model is then fitted independently to the simulated dataset. RMSE and ARB are calculated separately for each simulation-model combination."),
                     p("The dashboard does not replace the simulation-level results with mean RMSE or mean ARB. Instead, model performance can be summarized using median RMSE and median ARB across completed simulations."),
                     h4("Data Preparation"),
                     p("The dashboard accepts user-provided CSV datasets. Users select an outcome variable, treatment variable, and one or more confounding variables."),
                     p("Categorical confounders can be explicitly identified by the user. Categorical variables are converted to factors and subsequently represented through a design matrix for model fitting."),
                     p("The resulting design matrix contains the numerical representation of the selected confounding variables and is used by the simulation and causal estimation procedures."),
                     h4("General Purpose Framework"),
                     p("causalML is designed as a general purpose methodological framework. It can be used with different observational datasets and research questions, provided that the selected variables satisfy the assumptions and input requirements of the implemented methods."),
                     p("The separation between the simulation model and the causal estimation model provides a flexible environment for methodological evaluation. Researchers can therefore investigate whether a causal method remains accurate under different probability-generating mechanisms."),
                     h4("causalML R Package"),
                     p("This dashboard is built using the ",
                       strong("causalML"),
                       " R package. The package provides functions for causal machine learning, causal data simulation, CATE estimation, prediction, and model comparison."),
                     p("The package's source code & documentation are available on GitHub:"),
                     tags$p(
                       tags$a(href = "https://github.com/Rhyme-2002/causalML",
                              target = "_blank", "causalML GitHub Repository")),
                     h5("Installation in R / RStudio"),
                     tags$pre("install.packages(\"remotes\")\nremotes::install_github(\"Rhyme-2002/causalML\")"),
                     p("After installation, load the package using:"),
                     tags$pre("library(causalML)"),
                     h4("Questions and Support"),
                     p("For questions, methodological clarification, error reporting, or feedback regarding the dashboard or causalML package, please contact:"),
                     div(class = "info-box", icon("envelope"), " ",
                         tags$a(href = "mailto:asrhyme@isrt.ac.bd", "asrhyme@isrt.ac.bd")),
                     p(class = "small-note",
                       "This dashboard is intended for research, educational, and methodological evaluation of causal machine learning methods. Simulation and estimation results depend on the uploaded data, selected variables, simulation model, causal model, treatment-effect specification, and simulation settings.")
                 ))))))

# SERVER
server <- function(input, output, session){
  # READ DATA
  data <- reactive({
    req(input$file)
    tryCatch({
      dat <- read.csv(input$file$datapath, stringsAsFactors = FALSE, check.names = FALSE)
      validate(need(nrow(dat) > 0, "The uploaded CSV contains no observations."))
      validate(need(ncol(dat) > 0, "The uploaded CSV contains no variables."))
      names(dat) <- make.unique(ifelse(names(dat) == "", paste0("Variable_", seq_along(names(dat))), names(dat)))
      dat
      },
    
    error = function(e){
      showNotification(paste0("Unable to read CSV: ", conditionMessage(e)), type = "error", duration = 10)
      NULL
      })
    })
  
  # DATA PAGE
  output$data_page_ui <- renderUI({
    dat <- data()
    if(is.null(dat)){
      return(div(class = "result-card",
                 div(class = "section-title", "Welcome to causalML"),
                 div(class = "info-box", icon("upload"),
                     " Upload a CSV dataset from the left panel to begin." ),
          h4("Workflow"),
          tags$ol(tags$li("Upload CSV."),
            tags$li("Select outcome."),
            tags$li("Select treatment."),
            tags$li("Select confounders."),
            tags$li("Select categorical confounders."),
            tags$li("Select simulation model."),
            tags$li("Enter simulation number."),
            tags$li("Select causal models."),
            tags$li("Run model comparison."),
            tags$li("Select one causal-effect method."))))
      }
    tagList(div(class = "result-card",
                div(class = "section-title", "Uploaded Dataset"),
                div(class = "status-box", icon("check-circle"),
                    paste0(" Dataset successfully uploaded: ", nrow(dat), " observations × ", ncol(dat), " variables.")),
        
        br(),
        DTOutput("data_table"),
        downloadButton("download_data", "Download Dataset", class = "btn-info")),
        div(class = "result-card",
            div(class = "section-title", "Dataset Information"),
        DTOutput("data_info_table"),
        downloadButton("download_data_info", "Download Data Information", class = "btn-info")))
  })
 # DATA TABLE
  output$data_table <- renderDT({
    req(data())
    datatable(data(), rownames = FALSE, options = list( pageLength = 10, scrollX = TRUE,
                                                        autoWidth = TRUE, searching = TRUE,
                                                        ordering = TRUE, lengthMenu = c(5, 10, 25, 50)))
    
  })
  
  # DATA INFORMATION
  data_info <- reactive({
    dat <- data()
    req(dat)
    data.frame(Property = c("Number of observations", "Number of variables",
                            "Missing values", "Numeric variables", "Categorical variables"),
               Value = c(nrow(dat), ncol(dat), sum(is.na(dat)), sum(vapply(dat, is.numeric, logical(1))),
                         sum(vapply(dat, function(x){is.factor(x) || is.character(x)}, logical(1)))))
    
  })
  
  output$data_info_table <- renderDT({
    datatable(data_info(), rownames = FALSE, options = list(dom = "t"))
  })
  
  # DOWNLOAD DATA
  output$download_data <- downloadHandler(
    filename = function(){paste0("uploaded_data_", Sys.Date(), ".csv")},
    content = function(file){
      write.csv(data(), file, row.names = FALSE)
    }
  )
  
  output$download_data_info <- downloadHandler(
    filename = function(){paste0("data_information_", Sys.Date(), ".csv")
    },
    content = function(file){
      write.csv(data_info(), file, row.names = FALSE)
    }
  )
  
  # OUTCOME
  output$outcome_ui <- renderUI({
    dat <- data()
    req(dat)
    selectInput("outcome", "Outcome variable (Y):",
                choices = names(dat), selected = names(dat)[1], width = "100%")
    
  })
  
  # TREATMENT
  output$treatment_ui <- renderUI({
    dat <- data()
    req(dat)
    nm <- names(dat)
    selectInput("treatment", "Treatment variable (Z):",
      choices = nm, selected = if(length(nm) >= 2)
          nm[2]
      else
        nm[1],
      width =
        "100%"
    )
    
  })
  
  # CONFOUNDERS
  output$confounder_ui <- renderUI({
    dat <- data()
    req(dat)
    tagList(checkboxGroupInput( "confounders", "Select confounders (X):",
        choices = names(dat), selected = NULL),
      uiOutput("categorical_confounders_ui"))
  })
  ## CATEGORICAL CONFOUNDERS
  output$categorical_confounders_ui <- renderUI({
    dat <- data()
    req(dat)
    selected <- input$confounders
    if(is.null(selected) || length(selected) == 0){
      return(div(class = "small-note", icon("info-circle")," Select confounders first."))
    }
    detected <- selected[vapply(dat[selected], function(x){is.character(x) || is.factor(x)}, logical(1))]
    checkboxGroupInput("categorical_confounders", "Categorical confounders:",
                       choices = selected, selected = detected)
    
  })
  
  # ESTIMATION MODEL
  output$estimate_model_ui <- renderUI({
    selectInput("estimate_model", "Select ONE causal method:",
                choices = causal_model_choices, selected = "parametric_standardization",
                width = "100%")
  })
  
  # BART PS OPTION
  output$bart_ps_ui <- renderUI({
    req(input$estimate_model)
    if(input$estimate_model == "causal_BART"){
      checkboxInput("bart_ps", "Use propensity-score adjustment", value = FALSE)
      }
  })
  
  # ANALYSIS DATA
  analysis_data <- reactive({
    dat <- data()
    req(dat)
    req(input$outcome)
    req(input$treatment)
    req(input$confounders)
    validate(need(length(input$confounders) > 0, "Please select at least one confounder."))
    validate(need(input$outcome != input$treatment, "Outcome and treatment cannot be the same."))
    validate(need(!(input$outcome %in% input$confounders), "Outcome cannot be a confounder."))
    validate(need(!(input$treatment %in% input$confounders), "Treatment cannot be a confounder."))
    Y <- dat[[input$outcome]]
    A <- dat[[input$treatment]]
    X_raw <- dat[ , input$confounders, drop = FALSE]

    # CATEGORICAL VARIABLES
    categorical <- intersect(input$categorical_confounders, names(X_raw))
    if(length(categorical) > 0){
      for(v in categorical){
        X_raw[[v]] <- factor(X_raw[[v]])
      }
    }
    
    # COMPLETE CASE
    complete <- complete.cases(Y, A, X_raw)
    validate(need(sum(complete) >= 20, paste0("Only ", sum(complete),
                                              " complete observations remain. ",
                                              "At least 20 observations are required.")))
    Y <- Y[complete]
    A <- A[complete]
    X_raw <- X_raw[complete, , drop = FALSE]
    
    # TREATMENT
    if(is.factor(A) || is.character(A)){
      A <- factor(A)
      validate(need(nlevels(A) == 2, "Treatment must have exactly two levels."))
      A <- as.numeric(A) - 1
    }
    A <- as.numeric(A)
    validate(need(all(A %in% c(0, 1)),
                  paste0("Treatment must contain only 0 and 1. Observed values: ",
                         paste(unique(A), collapse = ", "))))
    validate(need(length(unique(A)) == 2, "Both treatment groups 0 and 1 must be present."))
    
    # OUTCOME
    if(is.factor(Y) || is.character(Y)){
      Y <- factor(Y)
      validate(need(nlevels(Y) == 2, "Outcome must have exactly two levels."))
      Y <- as.numeric(Y) - 1
    }
    Y <- as.numeric(Y)
    validate(need(all(Y %in% c(0, 1)), "The current causalML models require a binary outcome coded 0/1."))
    # MODEL MATRIX
    mm <- tryCatch({
      model.matrix( ~ ., data = X_raw)
        },
        error = function(e){
          stop(paste("Model matrix failed:", conditionMessage(e)))
        })
    if("(Intercept)" %in% colnames(mm)){
      mm <- mm[ , colnames(mm) != "(Intercept)", drop = FALSE]
    }
    X <- as.matrix(mm)
    storage.mode(X) <-  "numeric"
    validate(need(ncol(X) > 0, "The model matrix contains no predictors."))
    
    # Remove zero variance columns
    keep <- apply(X, 2, 
                  function(z){length(unique(z)) > 1
        })
    X <- X[ , keep, drop = FALSE]
    validate(need(ncol(X) > 0, 
                  "No non-constant confounder remains after Design-matrix construction."))

    list(Y = Y, treatment = A, X = X, X_raw = X_raw, n = length(Y))
    
  })

  ## SELECTED VARIABLES
  selected_variables <- reactive({
    dat <- analysis_data()
    conf <- input$confounders
    categorical <- if(is.null(input$categorical_confounders))
        character(0)
    else
      input$categorical_confounders
    data.frame(Role = c("Outcome", "Treatment", rep("Confounder", length(conf))),
      Variable = c(input$outcome, input$treatment, conf),
      Categorical = c(if(input$outcome %in% categorical)
          "Yes"
        else
          "No",
        if(input$treatment %in% categorical)
          "Yes"
        else
          "No",
        ifelse(conf %in% categorical, "Yes", "No")),
      stringsAsFactors = FALSE)
  })
  
  output$selected_variables_table <- renderDT({
    datatable(selected_variables(), rownames = FALSE, options = list(dom = "t"))
    })
  
  output$download_selected_variables <- downloadHandler(
    filename = function(){
      paste0("selected_variables_", Sys.Date(), ".csv")
      },
      content = function(file){
        write.csv(selected_variables(),
                  file, row.names = FALSE)
        }
    )

  # MODEL MATRIX
  output$model_matrix_table <- renderDT({
    dat <- analysis_data()
    datatable(as.data.frame(dat$X),
              rownames = FALSE,
              options = list(pageLength = 10, scrollX = TRUE))
    })
  
  output$download_model_matrix <- downloadHandler(
      filename = function(){
        paste0("Design_matrix_", Sys.Date(), ".csv")
      },
      content = function(file){
        write.csv(as.data.frame(analysis_data()$X), file, row.names = FALSE)
      }
    )
  

  ## MANUAL CAUSAL MODEL FITTING
  fit_causal_model_manual <- function(model_name, X, Y, treatment){
    # CAUSAL MARS
    if(model_name == "causalMARS"){
      fit <- causalML::causalMARS(x = X, treatment = treatment, y = Y, verbose = FALSE)
      cate <- as.numeric(fit$cate)
      ate <- as.numeric(fit$ate)
      
      return(list(fit = fit, CATE = cate, ATE = ate))
    }
    # CAUSAL BOOSTING
    if(model_name == "causal_boosting"){
      fit <- causalML::causal_boosting(X = X, y = Y, treatment = treatment, verbose = FALSE)
      cate <- as.numeric(fit$cate)
      ate <- as.numeric(fit$ate)
      
      return(list(fit = fit, CATE = cate, ATE = ate))
    }
    # CAUSAL FOREST
    if(model_name == "causal_forest"){
      validate(need(requireNamespace("grf", quietly = TRUE), 
                    "Causal Forest requires the grf package."))
      fit <- causalML::causalForest(X = X, Y = Y, treatment = treatment)
      pred <- predict(fit, newdata = X)
      cate <- as.numeric(pred$predictions)
      ate <- mean(cate, na.rm = TRUE)
      
      return(list(fit = fit, CATE = cate, ATE = ate))
    }
    # CAUSAL BART WITHOUT PS
    if(model_name == "causal_BART"){
      validate(need(requireNamespace("BART", quietly = TRUE), 
                    "Causal BART requires the BART package."))
      fit <- causalML::causalBART(X = X, Y = Y, treatment = treatment, PS_adjusted = FALSE)
      cate <- as.numeric(fit$CATE)
      ate <- as.numeric(fit$ATE)
      return(list(fit = fit, CATE = cate, ATE = ate))
    }
    # CAUSAL BART WITH PS
    if(model_name == "causal_BART_PS"){
      validate(need(requireNamespace("BART", quietly = TRUE),
          "Causal BART requires the BART package."))
      fit <- causalML::causalBART(X = X, Y = Y, treatment = treatment, PS_adjusted = TRUE)
      
      cate <- as.numeric(fit$CATE)
      ate <- as.numeric(fit$ATE)
      
      
      return(list(fit = fit, CATE = cate, ATE = ate))
    }
    
    # ADDITIVE CAUSAL FOREST
    
    if(model_name == "causal_Additive_Forest"){
      validate(need(requireNamespace("bcf", quietly = TRUE),
                    "Additive Causal Forest requires the bcf package."))
      
      fit <- causalML::causal_Additive_Forest(X = X, Y = Y, treatment = treatment)
      cate <- as.numeric(fit$CATE)
      ate <- as.numeric(fit$ATE)

      return(list(fit = fit, CATE = cate, ATE = ate))
    }
    # PARAMETRIC STANDARDIZATION
    if(model_name == "parametric_standardization"){
      fit <- causalML::parametric_standardization(
        X = X, Y = Y, treatment = treatment)
      cate <- as.numeric(fit$CATE)
      ate <- as.numeric(fit$ATE)
      
      return(list(fit = fit, CATE = cate, ATE = ate))
    }

    stop(paste("Unknown causal model:", model_name))
  }
  # MANUAL SIMULATION + MODEL COMPARISON
  
  comparison_result <- eventReactive(
    input$run_comparison, {
      dat <- analysis_data()
      models <- input$compare_models
      
      validate(need(!is.null(models) &&  length(models) > 0,
                    "Please select at least one causal model."))
      
      nsim <- as.integer(input$sim)
      validate(need(!is.na(nsim) && nsim >= 1, 
                    "Number of simulations must be at least 1."))

      validate(need(nsim <= 5000, "Number of simulations cannot exceed 5000."))
 
      # REQUIRED DEPENDENCIES
      if("causal_forest" %in%  models){
        validate(need(requireNamespace("grf", quietly = TRUE),
            "Install grf before using Causal Forest."))
      }
      if(any(models %in% c("causal_BART", "causal_BART_PS"))){
        validate(need(requireNamespace("BART", quietly = TRUE),
                      "Install BART before using Causal BART."))
        }
      if("causal_Additive_Forest" %in% models){
        validate(need(requireNamespace("bcf", quietly = TRUE),
                      "Install bcf before using Additive Causal Forest."))
      }
      ## SIMULATION PARAMETERS
      sim_model <- input$simulation_model
      k_value <- as.integer(input$knn_k)
      OR_value <- if(isTRUE(input$use_or))
        
          as.numeric(input$OR)
      else
        NULL
      
      # SIMULATE POTENTIAL OUTCOME SURFACE
      #
      # causalML::simulate_causal_data()
      # supports:
      #
      # logit
      # BART
      # GBM
      # Random_Forest
      # KNN
      # ------------------------------------------------------
      
      withProgress(message = "Running causal model comparison...", value = 0,
        
        {incProgress(0.02, detail = "Generating simulation surface...")
          sim_surface <- tryCatch({causalML::simulate_causal_data(Y = dat$Y,
                X = dat$X, treatment = dat$treatment, model = sim_model,
                k = k_value,  OR = OR_value, seed = 12345)},
              error = function(e){
                stop(paste0("Simulation failed: ", conditionMessage(e)))
                })

          true_CATE <- as.numeric(sim_surface$TRUE_CATE)
          true_ATE <- as.numeric(sim_surface$TRUE_ATE)
          n <- length(dat$Y)
          
          ## RESULT STORAGE
          result_list <- vector("list", nsim * length(models))
          result_counter <- 0
          
          ## SIMULATION LOOP
          for(s in seq_len(nsim)){
            incProgress(1 / nsim, detail = paste("Simulation",s, "of", nsim))
            
            # Generate a new binary outcome
            Y_sim <- rbinom(n = n, size = 1, prob = sim_surface$pi_factual)

            # FIT EACH SELECTED MODEL
            for(model_name in models){
              result_counter <- result_counter + 1
              one_result <- tryCatch({
                fit_causal_model_manual(
                  model_name = model_name, X = dat$X, Y = Y_sim, treatment = dat$treatment)},
                  error = function(e){
                    list(ERROR = conditionMessage(e))
                  }
                )
              
              # Failed model
              if(!is.null(one_result$ERROR)){
                result_list[[result_counter]] <- data.frame(Simulation = s,
                                                            Model = model_name,
                                                            RMSE = NA_real_,
                                                            ARB = NA_real_,
                                                            Estimated_ATE = NA_real_,
                                                            True_ATE = true_ATE,
                                                            Status = paste0("FAILED: ", one_result$ERROR),
                                                            stringsAsFactors = FALSE)
                next
              }
              # Extract CATE
              estimated_CATE <- as.numeric(one_result$CATE)
              estimated_CATE <- estimated_CATE[seq_len(min(length(estimated_CATE), length(true_CATE)))]
              current_true_CATE <- true_CATE[seq_along(estimated_CATE)]

              # RMSE
              rmse <- sqrt(mean((estimated_CATE - current_true_CATE)^2, na.rm = TRUE))
              # ATE
              estimated_ATE <- mean(estimated_CATE, na.rm = TRUE)

              # ARB
              arb <- if(is.finite(true_ATE) && abs(true_ATE) >1e-12){
                (abs((estimated_ATE - true_ATE) / true_ATE)) * 100
                }else{
                  (abs(estimated_ATE - true_ATE)) * 100
                }
              
              result_list[[result_counter]] <- data.frame(Simulation = s, Model = model_name, 
                                                          RMSE = rmse, ARB = arb,
                                                          Estimated_ATE = estimated_ATE,
                                                          True_ATE = true_ATE,
                                                          Status = "OK",
                                                          stringsAsFactors = FALSE)
            }
            
          }
          comparison_df <- bind_rows(result_list)
          
          # MODEL LABELS
          comparison_df$Model_Label <- recode(comparison_df$Model,
                                              causalMARS = "Causal MARS",
                                              causal_boosting = "Causal Boosting",
                                              causal_forest = "Causal Forest",
                                              causal_BART = "Causal BART - Without PS",
                                              causal_BART_PS = "Causal BART - With PS",
                                              causal_Additive_Forest = "Additive Causal Forest",
                                              parametric_standardization = "Parametric Standardization")
          
          # RANKING
          # Median is used only to determine the best model
          ranking <- comparison_df %>%
            filter(Status == "OK") %>%
            group_by(Model, Model_Label) %>%
            summarise(Median_RMSE = median( RMSE, na.rm = TRUE), 
                      Median_ARB = median(ARB, na.rm = TRUE),
                      Simulations_Completed = sum(is.finite(RMSE) & is.finite(ARB)),
                      .groups = "drop") %>%
            arrange(Median_RMSE) %>%
            mutate(RMSE_Rank = row_number()) %>%
            arrange(Median_ARB) %>%
            mutate(ARB_Rank = row_number()) %>%
            arrange(RMSE_Rank)

          # BEST MODELS
          best_rmse_model <- ranking %>%
            filter(is.finite(Median_RMSE)) %>%
            arrange(Median_RMSE) %>%
            slice(1)
          
           best_arb_model <- ranking %>%
             filter(is.finite(Median_ARB)) %>%
             arrange(Median_ARB) %>%
             slice(1)
           
          list(results = comparison_df, ranking = ranking, best_rmse = best_rmse_model,
               best_arb = best_arb_model, simulation_model = sim_model, simulations = nsim,
               true_CATE = true_CATE, true_ATE = true_ATE, simulation_surface = sim_surface)
          
        })
    }, ignoreInit = TRUE)
 
  ## COMPARISON TABLE
  output$comparison_table <- renderDT({
    result <- comparison_result()
    req(result)
    dat <- result$results
    display_data <- dat %>%
      select(Simulation, Model = Model_Label, RMSE, ARB, Estimated_ATE, True_ATE, Status) %>%
      mutate(RMSE = ifelse(is.finite(RMSE), sprintf("%.4f", RMSE), NA),
             ARB = ifelse(is.finite(ARB), paste0(sprintf("%.4f", ARB), "%"), NA),
             Estimated_ATE = ifelse(is.finite(Estimated_ATE), sprintf("%.4f", Estimated_ATE), NA),
             True_ATE = ifelse(is.finite(True_ATE), sprintf("%.4f", True_ATE), NA))
    
      datatable(display_data, rownames = FALSE,
                options = list(pageLength = 15, scrollX = TRUE, autoWidth = TRUE),
                colnames = c("Simulation", "Causal Model", "RMSE", "ARB", "Estimated ATE", "True ATE", "Status"))
      })

  # MODEL RANKING
  output$model_ranking_table <- renderDT({
    result <- comparison_result()
    req(result)
    ranking <- result$ranking
    
    display_ranking <- ranking %>%
      select(Model = Model_Label, Median_RMSE, Median_ARB, Simulations_Completed, RMSE_Rank, ARB_Rank) %>%
      mutate(Median_RMSE = sprintf("%.4f", Median_RMSE),
        Median_ARB = paste0(sprintf("%.4f", Median_ARB), "%"))
    
    datatable(display_ranking, rownames = FALSE,
              options = list(pageLength = 20, scrollX = TRUE, autoWidth = TRUE),
      colnames = c("Causal Model", "Median RMSE", "Median ARB", "Completed Simulations", "RMSE Rank", "ARB Rank"))
  })
  ## BEST RMSE
  output$best_rmse <- renderText({
      result <- comparison_result()
      req(result)
      best <- result$best_rmse
      validate(need(nrow(best) > 0, "No valid result"))
      paste0(best$Model_Label, " | Median RMSE = ",
             format(round(best$Median_RMSE, 5), nsmall = 5))
    })
  ## BEST ARB
  output$best_arb <- renderText({
    result <- comparison_result()
    req(result)
    best <- result$best_arb
    validate(need(nrow(best) > 0, "No valid result"))
    paste0(best$Model_Label, " | Median ARB = ",
           sprintf("%.4f", best$Median_ARB), "%")
  })
  ## DOWNLOAD COMPARISON
  output$download_comparison <- downloadHandler(
      filename = function(){paste0("causalML_simulation_results_", Sys.Date(), ".csv")},
      content = function(file){result <- comparison_result()
      write.csv(result$results, file, row.names = FALSE)})
  
  ## DOWNLOAD RANKING
  output$download_model_ranking <- downloadHandler(
      filename = function(){paste0("causalML_model_ranking_", Sys.Date(), ".csv")},
      content = function(file){
        result <- comparison_result()
        write.csv(result$ranking, file, row.names = FALSE)})
  # RMSE PLOT
  output$rmse_plot <- renderPlot({
      result <- comparison_result()
      req(result)
      dat <- result$results %>%
        filter(Status == "OK")
      validate(need(nrow(dat) > 0, "No RMSE results are available."))
      ggplot(dat, aes(x = reorder(Model_Label, RMSE, FUN = median), y = RMSE)) +
        geom_boxplot(width = 0.65) +
        geom_jitter(width = 0.10, alpha = 0.35) +
        coord_flip() +
        labs(title = "CATE RMSE Across Simulations",
             subtitle = "Each point represents one simulation",
             x = "Causal Model", y = "RMSE") +
        theme_minimal(base_size = 14) +
        theme(plot.title = element_text(face = "bold", size = 19),
          panel.grid.major.y = element_blank())
    })
  
  ## DOWNLOAD RMSE PLOT
  output$download_rmse_plot <- downloadHandler(
      filename = function(){
        paste0("RMSE_across_simulations_",  Sys.Date(), ".png")},
      content = function(file){
        result <- comparison_result()
        dat <- result$results %>%
          filter(Status == "OK")
        p <- ggplot(dat, aes(x = reorder(Model_Label, RMSE, FUN = median), y = RMSE)) +
          geom_boxplot(width = 0.65) +
          geom_jitter(width = 0.10, alpha = 0.35) +
          coord_flip() +
          labs(title = "CATE RMSE Across Simulations", x = "Causal Model", y = "RMSE") +
          theme_minimal(base_size = 14)
        
        ggsave(file, p, width = 10, height = 6, dpi = 300)
      })
  
  ## ARB PLOT
  output$arb_plot <- renderPlot({
      result <- comparison_result()
      req(result)
      dat <- result$results %>%
        filter(Status == "OK")
   
      validate(need(nrow(dat) > 0, "No ARB results are available."))
      
      ggplot(dat, aes(x = reorder(Model_Label, ARB, FUN = median), y = ARB)) +
        geom_boxplot(width = 0.65) +
        geom_jitter(width = 0.10, alpha = 0.35) +
        coord_flip() +
        labs(title = "ATE Absolute Relative Bias Across Simulations",
             subtitle = "Each point represents one simulation",
             x ="Causal Model", y = "Absolute Relative Bias (ARB)") +
        theme_minimal(base_size = 14) +
        theme(plot.title = element_text(face = "bold", size = 19), panel.grid.major.y = element_blank())
    })

  ## DOWNLOAD ARB PLOT
  
  output$download_arb_plot <- downloadHandler(filename = function(){
    paste0("ARB_across_simulations_", Sys.Date(), ".png")},
      
      content = function(file){
        result <- comparison_result()
        dat <- result$results %>%
          filter(Status == "OK")
        
        p <- ggplot( dat, aes(x = reorder(Model_Label, ARB, FUN = median), y = ARB)) +
          geom_boxplot(width = 0.65) + 
          geom_jitter(width = 0.10, alpha = 0.35) +
          coord_flip() +
          labs(title = "ATE Absolute Relative Bias Across Simulations",
               x = "Causal Model", y = "ARB") +
          theme_minimal(base_size = 14)

        ggsave(file, p, width = 10, height = 6, dpi = 300)
        })

  ## CAUSAL EFFECT ESTIMATION
  
  causal_result <- eventReactive(
      input$estimate_effect,
      {dat <- analysis_data()
      model_name <- input$estimate_model
      validate(need(length(model_name) == 1, "Please select exactly ONE causal method."))

        ## BART PS SETTING
        if(model_name == "causal_BART"){
          if(isTRUE(input$bart_ps))
            {
            model_name <- "causal_BART_PS"
          }
        }
        
        withProgress(message = "Estimating causal effect...", value = 0,
          {
            incProgress(0.20, detail = "Fitting selected causal model...")
            result <- tryCatch({
              fit_causal_model_manual(
                model_name = model_name, X = dat$X, Y = dat$Y, treatment = dat$treatment)
                },
                error = function(e){
                  showNotification(paste0("Causal effect estimation failed: ", conditionMessage(e)),
                                   type = "error", duration = 15)
                  NULL
                })
            incProgress(1, detail = "Completed.")
            result
          })
      }, ignoreInit = TRUE)
  
  ## CATE
    cate_vector <- reactive({
      result <- causal_result()
      req(result)
      cate <- as.numeric(result$CATE)
      validate(need(length(cate) > 0, "CATE estimates could not be obtained."))

      cate[is.finite(cate)]
      })
  # ATE
  ate_value <- reactive({
    result <- causal_result()
    req(result)
    as.numeric(result$ATE)
    })
  # SELECTED MODEL
  output$selected_model <- renderPrint({
    req(input$estimate_model)
    model_name <- input$estimate_model
    label <- if(model_name == "causal_BART" && isTRUE(input$bart_ps)){
          "Causal BART - With PS"
        }else{
          recode(model_name, causalMARS = "Causal MARS",
                 causal_boosting = "Causal Boosting",
                 causal_forest = "Causal Forest",
                 causal_BART = "Causal BART - Without PS",
                 causal_Additive_Forest = "Additive Causal Forest",
                 parametric_standardization = "Parametric Standardization")
        }
      cat("Selected causal method:\n\n")
      cat(label)
    })
  ## ATE RESULT
  output$ate_result <- renderPrint({
      ate <- ate_value()
      cat("Estimated Average Treatment Effect (ATE):\n\n")
      cat(format(round(ate, 6), nsmall = 6))
    })
  ## ATE METRIC
  output$ate_metric <- renderText({
      format(round(ate_value(), 5), nsmall = 5)
    })
  ## MEAN CATE
  output$mean_cate_metric <- renderText({
    format(round(mean(cate_vector(), na.rm = TRUE), 5), nsmall = 5)
    })
# DOWNLOAD ATE
  output$download_ate <- downloadHandler(
      filename = function(){
        paste0("ATE_", input$estimate_model, "_", Sys.Date(), ".csv")
      },
      content = function(file){
        write.csv(data.frame(Model = input$estimate_model, ATE = ate_value()),
          file, row.names = FALSE)
      })
  ## CATE TABLE
  output$cate_table <- renderDT({
      cate <- cate_vector()
      cate_df <- data.frame(Observation = seq_along(cate), CATE = cate)
      datatable(cate_df, rownames = FALSE,
        options =list(pageLength = 15, scrollX = TRUE, autoWidth = TRUE))
    })
  ## DOWNLOAD CATE
  output$download_cate <- downloadHandler(
      filename = function(){
        paste0("CATE_", input$estimate_model, "_", Sys.Date(), ".csv")
      },content = function(file){
        cate <- cate_vector()
        write.csv(data.frame(Observation = seq_along(cate), CATE = cate),
                  file, row.names = FALSE)
        })

  ## CATE PLOT
  make_cate_plot <- function(cate){
      plot_data <- data.frame(CATE = cate)
      mean_cate <- mean(cate, na.rm = TRUE)
      ggplot(plot_data, aes(x = CATE)) +
      geom_histogram(bins = 35, alpha = 0.70, colour = "white") +
      geom_density(linewidth = 1.2, na.rm = TRUE) +
      geom_vline(xintercept = 0, linetype = "dotted", linewidth = 1) +
      geom_vline(xintercept = mean_cate, linetype = "dashed", linewidth = 1) +
      labs(title = "Distribution of Estimated CATE", 
           subtitle = paste("Mean CATE =", round(mean_cate, 5)),
          x = "Conditional Average Treatment Effect", y ="Frequency") +
      theme_minimal(base_size = 14) +
      theme(plot.title = element_text(face = "bold", size = 19),
            panel.grid.minor = element_blank())
    }
  output$cate_plot <- renderPlot({make_cate_plot(cate_vector())
    })

  ## DOWNLOAD CATE PLOT
  output$download_cate_plot <- downloadHandler(
      filename = function(){ 
        paste0("CATE_distribution_", input$estimate_model, "_", Sys.Date(), ".png")
      },
      content = function(file){
        ggsave(file,make_cate_plot(cate_vector()),
          width = 10, height = 6, dpi = 300)
      })

  ## COMPLETE RESULT
  output$complete_result <- renderPrint({
    result <- causal_result()
      req(result)
      cate <- cate_vector()
      cat("====================================================\n")
      cat("causalML - COMPLETE CAUSAL MODEL RESULT\n")
      cat("====================================================\n\n")
      cat("Selected Model:\n")
      print(input$estimate_model)
      cat("\n\nEstimated ATE:\n")
      print(ate_value())
      cat("\nNumber of CATE estimates:\n")
      cat(length(cate))
      cat("\n\nComplete Model Object:\n\n")
      print(result$fit)
      cat("\n====================================================\n")
    })

  ## DOWNLOAD COMPLETE RESULT
  output$download_complete_result <- downloadHandler(
    filename = function(){
      paste0("complete_causal_result_", input$estimate_model, "_", Sys.Date(), ".txt")
      },
      content = function(file){
        result <- causal_result()
        req(result)
        capture.output(
          {cat("====================================================\n")
            cat("causalML - COMPLETE CAUSAL MODEL RESULT\n")
            cat("====================================================\n\n")
            cat("Selected Model:\n")
            print(input$estimate_model)
            cat("\n\nEstimated ATE:\n")
            print(ate_value())
            cat("\n\nCATE:\n")
            print(cate_vector())
            cat("\n\nComplete Model Object:\n\n")
            print(result$fit)
          }, file = file)
      })
  
## SESSION INFORMATION
  output$session_info <- renderPrint({sessionInfo()})
}
# RUN APP
shinyApp(ui = ui, server = server)