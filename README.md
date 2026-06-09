# Spotify Track Popularity Analysis

**Tools:** MySQL Workbench · Python · Tableau Public · GitHub  
**Dataset:** 4,465 Spotify tracks across 35 genres  
**Live Dashboard:** [View on Tableau Public](https://public.tableau.com/app/profile/mallika.chand5175/viz/spotify_analysis_17809915550800/SpotifyTrackPopularityAnalysis)

---

## Problem Statement

A music streaming platform struggles to understand what makes a song truly popular. Which genres perform best? How do high-performing songs differ from low-performing ones in terms of audio characteristics like energy, acousticness, and loudness? By identifying the audio signals and genre patterns that predict track popularity, we can help the platform recommend the right songs to the right listeners — creating a more personalized and engaging experience.

---

## Goal

Identify the audio features and genre patterns that predict track popularity to power smarter, more personalized music recommendations.

---

## Audience

Music platform product managers, data analysts, and recommendation engine teams seeking data-driven insights to improve listener engagement.

---

## Approach

This project follows a full end-to-end analytics workflow:

1. **SQL (MySQL Workbench)** — Data cleaning, EDA, feature comparison, genre aggregation, and top-track ranking using CTEs, window functions, and UNION queries
2. **Python (Jupyter Notebook)** — Exploratory analysis, feature engineering, machine learning modeling, and CSV exports for Tableau
3. **Tableau Public** — Three-dashboard interactive visualization covering project overview, main analysis, and key conclusions

---

## Key Findings

### Finding 1 — Acousticness is the Biggest Differentiator
| Tier | Avg Acousticness |
|------|-----------------|
| High popularity | 0.228 |
| Low popularity | 0.410 |

Popular songs are significantly less acoustic — produced, studio-polished tracks consistently outperform raw, organic-sounding ones.

### Finding 2 — Loudness Separates the Tiers
| Tier | Avg Loudness |
|------|-------------|
| High popularity | -6.82 dB |
| Low popularity | -10.76 dB |

Louder, more mastered tracks perform better. A ~4 dB gap is substantial in audio production terms.

### Finding 3 — Genre Patterns Are Clear
| Tier | Top Genres |
|------|-----------|
| High popularity | Pop, Gaming, R&B, K-Pop, Latin |
| Low popularity | Korean, J-Pop, Indie, Metal |

Mainstream and heavily produced genres dominate high popularity. Niche and regional genres cluster in the low tier.

---

## Machine Learning Results

Three classification models were trained to predict popularity tier (high vs low):

| Model | Accuracy |
|-------|----------|
| Logistic Regression | 66.2% |
| XGBoost | 70.9% |
| **Random Forest** | **72.7% ✅ Best** |

**Top Predictive Features:** Loudness → Instrumentalness → Acousticness

Random Forest achieved the best performance at 72.7%, confirming that audio features carry meaningful signal for predicting popularity — but also highlighting the inherent complexity of what makes a song resonate with listeners.

---

## Business Recommendation

To maximize track popularity in recommendations:

- **Prioritize loud, low-acoustic, high-energy tracks** — these audio characteristics are the strongest predictors of high popularity
- **Focus genre curation on Pop, Gaming, R&B, and Latin** — these genres consistently produce high-popularity tracks
- **Use acousticness and loudness as primary ranking signals** in the recommendation engine, ahead of danceability and valence

---

## Dashboard Overview

The Tableau workbook contains three dashboards:

**Dashboard 1 — Project Overview**  
Problem statement, goal, audience, tools used, and dataset summary.

**Dashboard 2 — Main Analysis**  
Interactive exploration of genre popularity, audio feature comparisons (high vs low tier), energy tier distribution, and a searchable track explorer. Includes global filters for Popularity Tier, Playlist Genre, and Top N Genres.

**Dashboard 3 — Conclusions**  
Key findings summary, ML model results, and business recommendations in a clean, readable layout.

---

## Project Structure

```
spotify-track-popularity-analysis/
│
├── data/
│   ├── master.csv                  # 4,465 rows, 11 columns — main analysis file
│   ├── high_popularity.csv         # High tier tracks
│   └── low_popularity.csv          # Low tier tracks
│
├── sql/
│   └── spotify_analysis.sql        # All SQL queries (cleaning, EDA, advanced analysis)
│
├── notebooks/
│   └── spotify_analysis.ipynb      # Full Python notebook (EDA, ML, exports)
│
└── README.md
```

---

## How to Run

### SQL
1. Open MySQL Workbench
2. Run `spotify_analysis.sql` — creates database, loads data, runs all queries

### Python
1. Clone the repo
2. Install dependencies: `pip install pandas numpy scikit-learn xgboost matplotlib seaborn.`
3. Open `spotify_analysis.ipynb` in Jupyter Notebook
4. Run all cells top to bottom

### Tableau
View the live dashboard on [Tableau Public](https://public.tableau.com/app/profile/mallika.chand5175/viz/spotify_analysis_17809915550800/SpotifyTrackPopularityAnalysis) — no installation required.

---

## Next Steps

1. **SHAP Explainability** — Add SHAP waterfall and summary plots to explain *why* the Random Forest model makes each prediction, moving beyond feature importance rankings to per-prediction transparency
2. **Streamlit Deployment** — Build an interactive web app where users input audio feature values and receive a predicted popularity tier with confidence score
3. **Power BI Version** — Rebuild the dashboard in Power BI using DAX calculated columns and Power Query to demonstrate cross-tool BI fluency

---

## About

**Mallika Chand**  
M.S. Analytics, Saint Louis University (GPA 3.9)  
[LinkedIn](https://linkedin.com/in/mallikachand) · [GitHub](https://github.com/Mallika-434) · mallikachand113@gmail.com
