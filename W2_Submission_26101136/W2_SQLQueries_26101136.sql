-- ============================================================
-- TBI-GEU Summer Internship Program 2026
-- Week 2 SQL Practice Queries
-- Intern ID : 26101136
-- Domain    : AI-Enabled Business Intelligence
-- Dataset   : batch_yield_log (Essential Oil Distillation)
-- ============================================================


-- ── BASIC SELECT + WHERE ──────────────────────────────────

-- Query 1: List all batches where Plant Variety is Lavender
SELECT * FROM batch_yield_log
WHERE plant_variety = 'Lavender';


-- Query 2: List all batches where Yield Efficiency is greater than 5%
SELECT batch_id, plant_variety, harvest_season, yield_efficiency_pct
FROM batch_yield_log
WHERE yield_efficiency_pct > 5;


-- ── ORDER BY ─────────────────────────────────────────────

-- Query 3: Sort all batches by Yield Efficiency from highest to lowest
SELECT batch_id, plant_variety, yield_efficiency_pct
FROM batch_yield_log
ORDER BY yield_efficiency_pct DESC;


-- ── GROUP BY + AGGREGATE FUNCTIONS ───────────────────────

-- Query 4: Count the number of batches per Plant Variety
SELECT plant_variety, COUNT(*) AS total_batches
FROM batch_yield_log
GROUP BY plant_variety;


-- Query 5: Average Yield Efficiency per Harvest Season
SELECT harvest_season, ROUND(AVG(yield_efficiency_pct), 2) AS avg_yield_efficiency
FROM batch_yield_log
GROUP BY harvest_season;


-- ── HAVING ───────────────────────────────────────────────

-- Query 6: Show only Plant Varieties with average yield efficiency above 3.8%
SELECT plant_variety, ROUND(AVG(yield_efficiency_pct), 2) AS avg_yield
FROM batch_yield_log
GROUP BY plant_variety
HAVING AVG(yield_efficiency_pct) > 3.8;


-- ── INNER JOIN ───────────────────────────────────────────

-- Query 7: Inner Join - Match batches with high yield (above average)
-- Using a self-join approach to compare each batch to overall average
SELECT a.batch_id, a.plant_variety, a.yield_efficiency_pct
FROM batch_yield_log a
INNER JOIN batch_yield_log b
ON a.plant_variety = b.plant_variety
WHERE a.yield_efficiency_pct > 4.5
GROUP BY a.batch_id;


-- Query 8: Inner Join - List batches with Quality Grade A and high output
SELECT a.batch_id, a.plant_variety, a.output_ml, a.quality_grade
FROM batch_yield_log a
INNER JOIN batch_yield_log b
ON a.altitude_zone = b.altitude_zone
WHERE a.quality_grade = 'A' AND a.output_ml > 2000
GROUP BY a.batch_id;


-- ── LEFT JOIN ────────────────────────────────────────────

-- Query 9: Left Join - All batches and their yield category (preserving all records)
SELECT a.batch_id, a.plant_variety, a.yield_efficiency_pct,
       CASE
           WHEN a.yield_efficiency_pct >= 5 THEN 'High Yield'
           WHEN a.yield_efficiency_pct >= 3.5 THEN 'Medium Yield'
           ELSE 'Low Yield'
       END AS yield_category
FROM batch_yield_log a
LEFT JOIN batch_yield_log b
ON a.batch_id = b.batch_id
GROUP BY a.batch_id;


-- ── SUBQUERY ─────────────────────────────────────────────

-- Query 10: Find all batches with yield efficiency above the overall average (subquery)
SELECT batch_id, plant_variety, harvest_season, yield_efficiency_pct
FROM batch_yield_log
WHERE yield_efficiency_pct > (
    SELECT AVG(yield_efficiency_pct)
    FROM batch_yield_log
);


-- ============================================================
-- SQL MURDER MYSTERY SOLUTION
-- Source: mystery.knightlab.com
-- ============================================================

-- Step 1: Find the crime scene report
SELECT * FROM crime_scene_report
WHERE date = 20180115
AND type = 'murder'
AND city = 'SQL City';

-- Step 2: Find the two witnesses
SELECT * FROM person
WHERE address_street_name = 'Northwestern Dr'
ORDER BY address_number DESC
LIMIT 1;

SELECT * FROM person
WHERE name LIKE 'Annabel%'
AND address_street_name = 'Franklin Ave';

-- Step 3: Get witness interviews
SELECT * FROM interview
WHERE person_id = 14887;

SELECT * FROM interview
WHERE person_id = 16371;

-- Step 4: Find the suspect from gym check-ins and membership
SELECT gci.person_id, gci.check_in_date, gm.name, gm.membership_status
FROM get_fit_now_check_in gci
INNER JOIN get_fit_now_member gm ON gci.membership_id = gm.id
WHERE gci.check_in_date = 20180109
AND gci.membership_id LIKE '48Z%'
AND gm.membership_status = 'gold';

-- Step 5: Confirm suspect with license plate
SELECT p.name, dl.plate_number
FROM person p
INNER JOIN drivers_license dl ON p.license_id = dl.id
WHERE p.id = 67318;

-- SQL Murder Mystery Solution: The murderer is Jeremy Bowers
SELECT * FROM person WHERE name = 'Jeremy Bowers';
