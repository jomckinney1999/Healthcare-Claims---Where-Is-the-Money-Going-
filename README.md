# Healthcare-Claims---Where-Is-the-Money-Going-
Data Analyst at a health insurer: analyze a synthetic claims dataset (demographics; inpatient/outpatient/ER/pharmacy; ICD/CPT; billed vs. paid) to identify which services, procedures, and members drive the highest healthcare costs.

**Goal:** Find what drives healthcare spend and where reimbursement differs from billed amounts by analyzing claim types, CPT/ICD codes, members, and providers.

**What I built:**
- Claim type cost breakdown (ranked by total paid)
- Top CPT/ICD cost drivers (total paid + average paid per claim)
- Member-level spend (top high-cost members + claim-type drivers)
- Billed vs. paid ratios by claim type, CPT, and provider (weighted ratios)

**Key findings:**
- Highest total spend claim type: **TODO** ($**TODO** total paid)
- Largest CPT cost driver: **TODO** ($**TODO** total paid; $**TODO** avg paid/claim)
- Largest ICD cost driver: **TODO** ($**TODO** total paid)
- Highest-cost member(s): **TODO** ($**TODO** total paid; main driver: **TODO**)
- Lowest paid ratio claim type(s): **TODO** (paid/billed ≈ **TODO**)

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

**Privacy note:** TODO (confirm dataset is synthetic/de-identified; no PHI included)
