SELECT 
    dc.country,
    dcat.category,
    SUM(fs.amount) AS totalsales
FROM 
    public."FactSales" fs
JOIN 
    public."DimCountry" dc ON fs.countryid = dc.countryid
JOIN 
    public."DimCategory" dcat ON fs.categoryid = dcat.categoryid
GROUP BY 
    GROUPING SETS (
        (dc.country, dcat.category),
        (dc.country),
        (dcat.category),
        ()
    )
ORDER BY
    dc.country,
    dcat.category;


----- Roll up 

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


--- cube query

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
