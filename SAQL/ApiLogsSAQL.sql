SELECT [Deployment], [Url], [Elapsed], [Size], [CallTime]
INTO RawApiCalls
FROM ApiCalls

SELECT A.[Deployment], A.[Url], A.[Elapsed], A.[Size], A.[CallTime], B.[ElapsedAvg]
INTO RawApiCallsHeavy
FROM ApiCalls A
JOIN ApiCallsDefs B ON A.[Url] = B.[Url] AND DATEDIFF(day, A, B) BETWEEN 0 AND 6
-- WHERE A.Elapsed>=B.ElapsedAvg
--WHERE CAST(A.Elapsed as bigint)>=CAST(B.ElapsedAvg as bigint)

SELECT A.[Deployment], A.[Url], CALLTIME, CAST(Avg(A.[Elapsed]) as bigint) AS AvgElapsed, CAST(Sum(A.[Elapsed]) as bigint) AS SumElapsed, CAST(Avg(A.[Size]) as bigint) as AvgSize, CAST(Sum(A.[Size]) as  bigint) as SumSize
-- SELECT A.[Deployment], A.[Url], Avg(A.[Elapsed]) AS AvgElapsed, Sum(A.[Elapsed]) AS SumElapsed, Avg(A.[Size]) as AvgSize, Sum(A.[Size]) as SumSize
-- SELECT A.[Deployment], A.[Url], System.Timestamp as TSTime, CAST(Avg(A.[Elapsed]) as bigint) AS AvgElapsed, CAST(Sum(A.[Elapsed]) as bigint) AS SumElapsed, CAST(Avg(A.[Size]) as bigint) as AvgSize, CAST(Sum(A.[Size]) as  bigint) as SumSize
INTO [RawApiCallsStats]
FROM ApiCalls A
-- FROM ApiCalls A TIMESTAMP BY CALLTIME
JOIN ApiCallsDefs B ON A.Url = B.Url AND DATEDIFF(day, A, B) BETWEEN 0 AND 6
WHERE CAST(A.Elapsed as bigint)>=CAST(B.ElapsedAvg as bigint)
GROUP BY A.[Deployment], A.[Url], TumblingWindow(second, 60)

WITH Source AS (
    SELECT [Deployment], [Url], [Elapsed], [Size], [CallTime]
	FROM ApiCalls TIMESTAMP BY CallTime
)
, FilteredDecoded AS (
	SELECT A.[Deployment], A.[Url], A.[Elapsed], A.[Size], A.[CallTime], B.[ElapsedAvg]
	FROM Source A
	JOIN ApiCallsDefs B ON A.[Url] = B.[Url] AND DATEDIFF(day, A, B) BETWEEN 0 AND 6
	WHERE CAST(A.Elapsed as bigint)>=CAST(B.ElapsedAvg as bigint)
)
, Grouped AS (
	SELECT [Deployment], [Url], CallTime as TSTime, CAST(Avg([Elapsed]) as bigint) AS AvgElapsed, CAST(Sum([Elapsed]) as bigint) AS SumElapsed, CAST(Avg([Size]) as bigint) as AvgSize, CAST(Sum([Size]) as  bigint) as SumSize
	FROM FilteredDecoded
	GROUP BY [Deployment], [Url], CallTime, TumblingWindow(second, 60)
)
SELECT [Deployment], [Url], [Elapsed], [Size], [CallTime]
INTO RawApiCalls
FROM Source
SELECT [Deployment], [Url], [Elapsed], [Size], [CallTime], [ElapsedAvg]
INTO RawApiCallsHeavy
FROM FilteredDecoded 
SELECT [Deployment], [Url], TSTime, AvgElapsed, SumElapsed, AvgSize, SumSize
INTO RawApiCallsStats
FROM Grouped








WITH Source AS (
    SELECT [Deployment], [Url], [Elapsed], [Size], [CallTime]
	FROM ApiCalls TIMESTAMP BY CallTime
)
, FilteredDecoded AS (
	SELECT A.[Deployment], A.[Url], A.[Elapsed], A.[Size], A.[CallTime], B.[ElapsedAvg]
	FROM Source A
	JOIN ApiCallsDefs B ON A.[Url] = B.[Url] AND DATEDIFF(day, A, B) BETWEEN 0 AND 6
	WHERE CAST(A.Elapsed as bigint)>=CAST(B.ElapsedAvg as bigint)
)
, Grouped AS (
	SELECT [Deployment], [Url], CallTime as TSTime, CAST(Avg([Elapsed]) as bigint) AS AvgElapsed, CAST(Sum([Elapsed]) as bigint) AS SumElapsed, CAST(Avg([Size]) as bigint) as AvgSize, CAST(Sum([Size]) as  bigint) as SumSize
	FROM FilteredDecoded
	GROUP BY [Deployment], [Url], CallTime, TumblingWindow(second, 60)
)
, Cpu AS (
    SELECT [Deployment], System.Timestamp as TSTime, CAST(AVG([Load]) as bigint) As AvgLoad
    FROM CpuUsage
    GROUP BY [Deployment], HoppingWindow(second, 60, 5)
)
, ApiCpu AS (
    SELECT G.[Deployment], G.[Url], G.TSTime, G.AvgElapsed, C.AvgLoad
    FROM Grouped G
    JOIN Cpu C ON G.Deployment = C.Deployment AND DATEDIFF(second, G, C) BETWEEN 0 AND 5
)
SELECT [Deployment], [Url], [Elapsed], [Size], [CallTime]
INTO RawApiCalls
FROM Source
SELECT [Deployment], [Url], [Elapsed], [Size], [CallTime], [ElapsedAvg]
INTO RawApiCallsHeavy
FROM FilteredDecoded 
SELECT [Deployment], [Url], TSTime, AvgElapsed, SumElapsed, AvgSize, SumSize
INTO RawApiCallsStats
FROM Grouped
SELECT [Deployment], [Url], TSTime, AvgElapsed, AvgLoad
INTO RawApiCallsLoad
FROM ApiCpu


WITH Source AS (
    SELECT [Deployment], [Url], [Elapsed], [Size], [CallTime]
	FROM ApiCalls TIMESTAMP BY CallTime
)
, FilteredDecoded AS (
	SELECT A.[Deployment], A.[Url], A.[Elapsed], A.[Size], A.[CallTime], B.[ElapsedAvg]
	FROM Source A
	JOIN ApiCallsDefs B ON A.[Url] = B.[Url] AND DATEDIFF(day, A, B) BETWEEN 0 AND 6
	WHERE CAST(A.Elapsed as bigint)>=CAST(B.ElapsedAvg as bigint)
)
, Grouped AS (
	SELECT [Deployment], [Url], CallTime as TSTime, CAST(Avg([Elapsed]) as bigint) AS AvgElapsed, CAST(Sum([Elapsed]) as bigint) AS SumElapsed, CAST(Avg([Size]) as bigint) as AvgSize, CAST(Sum([Size]) as  bigint) as SumSize
	FROM FilteredDecoded
	GROUP BY [Deployment], [Url], CallTime, TumblingWindow(second, 60)
)
, Cpu AS (
    SELECT [Deployment], System.Timestamp as TSTime, CAST(AVG([Load]) as bigint) As AvgLoad
    FROM CpuUsage
    GROUP BY [Deployment], HoppingWindow(second, 60, 5)
)
, ApiCpu AS (
    SELECT G.[Deployment], G.[Url], G.TSTime, G.AvgElapsed, C.AvgLoad
    FROM Grouped G
    JOIN Cpu C ON G.Deployment = C.Deployment AND DATEDIFF(second, G, C) BETWEEN 0 AND 5
)
, Storage AS (
    SELECT [Deployment], System.Timestamp as TSTime, CAST(AVG([Bytes]) as bigint) As AvgBytes
    FROM StorageUsage
    GROUP BY [Deployment], HoppingWindow(second, 60, 5)
)
, ApiStorage AS (
    SELECT G.[Deployment], G.[Url], G.TSTime, G.AvgSize, S.AvgBytes
    FROM Grouped G
    JOIN Storage S ON G.Deployment = S.Deployment AND DATEDIFF(second, G, S) BETWEEN 0 AND 5
)
SELECT [Deployment], [Url], [Elapsed], [Size], [CallTime]
INTO RawApiCalls
FROM Source
SELECT [Deployment], [Url], [Elapsed], [Size], [CallTime], [ElapsedAvg]
INTO RawApiCallsHeavy
FROM FilteredDecoded 
SELECT [Deployment], [Url], TSTime, AvgElapsed, SumElapsed, AvgSize, SumSize
INTO RawApiCallsStats
FROM Grouped
SELECT [Deployment], [Url], TSTime, AvgElapsed, AvgLoad
INTO RawApiCallsLoad
FROM ApiCpu
SELECT [Deployment], [Url], TSTime, AvgSize, AvgBytes
INTO RawApiCallsStorage
FROM ApiStorage