# 🚀 GitHub Setup Guide
## How to Publish This Project to GitHub

---

### Step 1: Create a New Repository on GitHub

1. Go to [github.com](https://github.com) and sign in
2. Click the **"+"** icon → **"New repository"**
3. Set the following:
   - **Repository name:** `customer-shopping-behavior`
   - **Description:** `End-to-end data analytics project: Python cleaning, PostgreSQL, SQL EDA, Power BI`
   - **Visibility:** Public *(so recruiters can see it)*
   - ✅ Do NOT initialise with README (you already have one)
4. Click **"Create repository"**

---

### Step 2: Set Up Git Locally

Open a terminal/command prompt in your project folder and run:

```bash
# Initialise git
git init

# Stage all files
git add .

# First commit
git commit -m "Initial commit: full end-to-end customer shopping behavior analytics project"

# Connect to your GitHub repo (replace YOUR_USERNAME)
git remote add origin https://github.com/YOUR_USERNAME/customer-shopping-behavior.git

# Push to GitHub
git branch -M main
git push -u origin main
```

---

### Step 3: Add a Dashboard Screenshot

1. Take a screenshot of your Power BI dashboard
2. Save it as `assets/dashboard_preview.png`
3. The README.md already references this image

```bash
git add assets/dashboard_preview.png
git commit -m "Add dashboard preview screenshot"
git push
```

---

### Step 4: Handle the Data Files

The `.gitignore` excludes CSV files by default (to keep the repo lightweight).
To include them, edit `.gitignore` and remove these lines:

```
data/customer_shopping_behavior.csv
data/shopping_data_clean.csv
```

Then:
```bash
git add data/
git commit -m "Add dataset files"
git push
```

---

### Step 5: Add Topics to Your Repo (Important for Visibility!)

On GitHub, go to your repo → click the ⚙️ gear next to "About" → add topics:

```
python  pandas  postgresql  sql  power-bi  data-analytics
eda  data-cleaning  visualization  portfolio
```

---

### Step 6: Pin the Repo on Your Profile

1. Go to your GitHub profile page
2. Click "Customize your pins"
3. Select `customer-shopping-behavior`
4. Save

---

### Checklist Before Submitting for Presentation

- [ ] README.md is complete with your name, LinkedIn, and email filled in
- [ ] Dashboard screenshot added to `assets/`
- [ ] `.pbix` file uploaded to `reports/`
- [ ] All Python scripts are working and tested
- [ ] SQL file has all queries
- [ ] Project_Report.docx is in `reports/`
- [ ] Repo is Public
- [ ] Topics/tags added
- [ ] Repo is pinned on your GitHub profile

---

### Presentation Tips

When presenting this project:

1. **Start with the dashboard** — show the visual before the code
2. **Walk through the pipeline** — raw CSV → Python cleaning → PostgreSQL → SQL EDA → Power BI
3. **Highlight your fixes** — mention the `spend_tier` bin bug you caught and corrected
4. **Lead with insights** — present findings as business recommendations, not just numbers
5. **Show the SQL** — open pgAdmin and run a live query to demonstrate live DB connectivity

---

*Good luck with your presentation! 🎉*
