CREATE TABLE daily (
	date date,
	week_of date,
	day varchar,
	sales numeric,
	cc_tips numeric,
	cash numeric,
	wine numeric,
	hours numeric,
	pre_tax numeric,
	shift_type varchar
);


CREATE TABLE weekly (
	week_of date,
	cc_tips numeric,
	deposit numeric,
	total_hours numeric,
	avg_hourly numeric,
	cash numeric
);

SELECT * FROM weekly;