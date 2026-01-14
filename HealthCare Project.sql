/* ============================================================
   Claims Cost & Utilization Analysis (SQL Server / SSMS)
   Author: <Jojo McKinney>
   Notes:
   - Assumes dbo.claims with columns:
     claim_type, billed_amount, paid_amount, cpt_code, icd_code, member_id, provider_id
   - Uses COALESCE/NULLIF to handle NULLs and divide-by-zero
   - Uses decimal math to avoid integer division
   ============================================================ */


-- Claim Type Cost Breakdown 
SELECT
    claim_type,
    SUM(billed_amount) AS total_billed_amount,
    SUM(paid_amount)   AS total_paid_amount,
    COUNT(*)           AS claim_count
FROM claims
GROUP BY claim_type
ORDER BY total_paid_amount DESC;

-- CPT & ICD Cost Drivers
    -- TOP 10 CPT Codes by Total Paid Amount
SELECT TOP (10)
    cpt_code,
    SUM(paid_amount) AS total_paid_amount,
    COUNT(*)         AS claim_count,
    SUM(paid_amount) * 1.0 / COUNT(*) AS average_paid_per_claim
FROM dbo.claims
WHERE cpt_code IS NOT NULL
GROUP BY cpt_code
ORDER BY total_paid_amount DESC;

    -- TOP 10 ICD Codes by Total Paid AMount
    SELECT TOP (10)
    icd_code,
    SUM(paid_amount) AS total_paid_amount,
    COUNT(*)         AS claim_count,
    SUM(paid_amount) * 1.0 / COUNT(*) AS average_paid_per_claim
FROM dbo.claims
WHERE icd_code IS NOT NULL
GROUP BY icd_code
ORDER BY total_paid_amount DESC;

-- Identify CPT codes with a high paid amount per claim
SELECT TOP (10)
    cpt_code,
    SUM(paid_amount) AS total_paid_amount,
    COUNT(*)         AS claim_count,
    SUM(paid_amount) * 1.0 / COUNT(*) AS average_paid_per_claim
FROM dbo.claims
WHERE cpt_code IS NOT NULL
GROUP BY cpt_code
HAVING COUNT(*) >= 10  
ORDER BY average_paid_per_claim DESC;

-- Member Level Analysis
    -- Total Amount Paid per Member
SELECT
    member_id,
    SUM(COALESCE(paid_amount, 0)) AS total_paid_amount,
    COUNT(*) AS claim_count
FROM dbo.claims
GROUP BY member_id
ORDER BY total_paid_amount DESC;

    -- Top 10 Highest Cost Members
SELECT TOP (10)
    member_id,
    SUM(COALESCE(paid_amount, 0)) AS total_paid_amount,
    COUNT(*) AS claim_count
FROM dbo.claims
GROUP BY member_id
ORDER BY total_paid_amount DESC;

-- Breakdown of What Claims Drive Costs
WITH member_totals AS (
    SELECT
        member_id,
        SUM(COALESCE(paid_amount, 0)) AS total_paid_amount
    FROM dbo.claims
    GROUP BY member_id
),
top_members AS (
    SELECT TOP (10)
        member_id,
        total_paid_amount
    FROM member_totals
    ORDER BY total_paid_amount DESC
),
member_type_breakdown AS (
    SELECT
        c.member_id,
        c.claim_type,
        SUM(COALESCE(c.paid_amount, 0)) AS paid_amount_by_type,
        COUNT(*) AS claim_count_by_type
    FROM dbo.claims c
    INNER JOIN top_members tm
        ON c.member_id = tm.member_id
    GROUP BY c.member_id, c.claim_type
)
SELECT
    b.member_id,
    b.claim_type,
    b.paid_amount_by_type,
    b.claim_count_by_type,
    tm.total_paid_amount,
    CAST(b.paid_amount_by_type * 1.0 / NULLIF(tm.total_paid_amount, 0) AS decimal(9,4)) AS pct_of_member_spend
FROM member_type_breakdown b
INNER JOIN top_members tm
    ON b.member_id = tm.member_id
ORDER BY
    tm.total_paid_amount DESC,
    b.paid_amount_by_type DESC;

-- Billed Vs Paid Ratio
SELECT claim_type,
(SUM(paid_amount) / SUM(billed_amount)) AS paid_ratio
FROM claims
GROUP BY claim_type
ORDER BY paid_ratio ASC

SELECT cpt_code,
(SUM(paid_amount) / SUM(billed_amount)) AS paid_ratio
FROM claims
GROUP BY cpt_code
ORDER BY paid_ratio ASC

SELECT provider_id,
(SUM(paid_amount) / SUM(billed_amount)) AS paid_ratio
FROM claims
GROUP BY provider_id
ORDER BY paid_ratio ASC