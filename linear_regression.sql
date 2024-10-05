-- Linear progression to predict deposit amount from cc tips made
-- Find difference between cc tips made and deposit, find outliers
WITH ordered_diff AS (
	SELECT
		cc_tips::numeric,
		deposit::numeric,
		cc_tips::numeric - deposit::numeric as difference
	FROM weekly
	WHERE deposit IS NOT NULL
	ORDER BY difference
),
median_value AS (
	SELECT PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY difference) AS median
	FROM ordered_diff
),
lower_half AS (
	SELECT difference
	FROM ordered_diff, median_value
	WHERE difference < median
),
upper_half AS (
	SELECT difference
	FROM ordered_diff, median_value
	WHERE difference > median
),
quartiles AS (
	SELECT
		PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY l.difference)::numeric AS first_quartile,
		PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY u.difference)::numeric AS third_quartile
	FROM
		lower_half l,
		upper_half u
),
inter_quart_range AS (
	SELECT third_quartile - first_quartile AS IQR
	FROM quartiles
),
desc_stats AS (
	SELECT 
		AVG(cc_tips) AS mean_x,
		AVG(deposit) AS mean_y,
		STDDEV_POP(cc_tips) AS std_dev_x,
		STDDEV_POP(deposit) AS std_dev_y
	FROM ordered_diff
	WHERE difference NOT IN (
		SELECT difference AS outliers
		FROM ordered_diff, quartiles, inter_quart_range
		WHERE difference < first_quartile - IQR * 1.5
		OR difference > third_quartile + IQR * 1.5)
)
SELECT
	ROUND(SUM((cc_tips - mean_x) * (deposit - mean_y)) / 
	SQRT(SUM((cc_tips - mean_x) * (cc_tips - mean_x)) *
	SUM((deposit - mean_y) * (deposit - mean_y))), 2) AS R_value
FROM ordered_diff, desc_stats
WHERE difference NOT IN (
	SELECT difference AS outliers
	FROM ordered_diff, quartiles, inter_quart_range
	WHERE difference < first_quartile - IQR * 1.5
	OR difference > third_quartile + IQR * 1.5);

