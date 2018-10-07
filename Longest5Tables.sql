SELECT Top
5 TABL.name AS table_name,

SUM(PART.rows) 
AS rows_count

FROM sys.tables 
AS TABL

INNER JOIN sys.indexes 
AS INDX

ON TABL.object_id 
= INDX.object_id

INNER JOIN sys.partitions 
AS PART

ON INDX.object_id 
= PART.object_id

AND INDX.index_id 
= PART.index_id

INNER JOIN sys.allocation_units 
AS ALOC

ON PART.partition_id 
= ALOC.container_id

WHERE

INDX.object_id > 
255

AND INDX.index_id 
<= 1

GROUP BY TABL.name,

INDX.object_id,

INDX.index_id,

INDX.name

ORDER BY

SUM(PART.rows) 
DESC
