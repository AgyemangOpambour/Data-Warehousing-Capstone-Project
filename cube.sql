SELECT
    dd.year,
    dc.country,
    AVG(fs.amount) AS averagesales
FROM
    public."FactSales" fs
JOIN
    public."DimDate" dd ON fs.dateid = dd.dateid
JOIN
    public."DimCountry" dc ON fs.countryid = dc.countryid
GROUP BY
    CUBE (dd.year, dc.country)
ORDER BY
    dd.year NULLS LAST,
    dc.country NULLS LAST;
