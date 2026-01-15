# Healthcare-Claims---Where-Is-the-Money-Going?
Data Analyst at a health insurer: analyze a synthetic claims dataset (demographics; inpatient/outpatient/ER/pharmacy; ICD/CPT; billed vs. paid) to identify which services, procedures, and members drive the highest healthcare costs.

**Goal:** Find what drives healthcare spend and where reimbursement differs from billed amounts by analyzing claim types, CPT/ICD codes, members, and providers.

**What I built:**
- Claim type cost breakdown (ranked by total paid)
- Top CPT/ICD cost drivers (total paid + average paid per claim)
- Member-level spend (top high-cost members + claim-type drivers)
- Billed vs. paid ratios by claim type, CPT, and provider (weighted ratios)

**Key findings:**
- Highest total spend claim type: **Inpatient** ($**1,092,456.00** paid on $**1,478,601.25** billed across **99** claims)
- Next highest spend claim type: **Emergency** ($**294,441.36** paid across **88** claims)
- Largest ICD cost driver by total paid: **I10** ($**259,566.00** paid across **34** claims, avg $**7,634.29** per claim)
- Largest CPT cost driver by total paid (from your CPT table values): **67890** ($**242,735.00** paid across **25** claims, avg $**9,709.40** per claim)
- Highest average paid per claim CPT (min volume): **00123** (avg $**10,167.50** per claim across **12** claims, $**122,010.00** total paid)
- Highest-cost member: **member_id 6** ($**43,300.00** paid across **4** claims)
- Lowest paid ratio claim type: **Inpatient** (paid/billed = **0.738844**). Highest: **Lab** (**0.907810**)
- Outlier reimbursement flags: **CPT 10001** paid ratio **0.095238**; **Provider PRV00214** paid ratio **0.000000**


---

## Tech Stack

- **SQL Server** (T-SQL)
- **SQL Server Management Studio (SSMS)**
- Flat file import (CSV/Excel) into `dbo.claims`

---

## Dataset

This project assumes a claims flat file imported into a single table: `dbo.claims`.

### Core columns used
- `claim_type` (e.g., inpatient, outpatient, ER, pharmacy)
- `billed_amount`
- `paid_amount`
- `cpt_code`
- `icd_code`
- `member_id`
- `provider_id`

**Privacy note:** Dataset is synthetic/de-identified; no PHI included)
