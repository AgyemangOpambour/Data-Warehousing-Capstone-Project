SELECT
    dd.year,
    dc.country,
    SUM(fs.amount) AS totalsales
FROM
    public."FactSales" fs
JOIN
    public."DimDate" dd ON fs.dateid = dd.dateid
JOIN
    public."DimCountry" dc ON fs.countryid = dc.countryid
GROUP BY
    ROLLUP (dd.year, dc.country)
ORDER BY
    dd.year NULLS LAST,
    dc.country NULLS LAST;

