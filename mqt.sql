CREATE MATERIALIZED VIEW public.total_sales_per_country AS
SELECT
    dc.country,
    SUM(fs.amount) AS total_sales
FROM
    public."FactSales" fs
JOIN
    public."DimCountry" dc ON fs.countryid = dc.countryid
GROUP BY
    dc.country;

