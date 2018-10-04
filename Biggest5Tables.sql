SELECT top (5)
    '[' + (OBJECT_SCHEMA_NAME(tables.object_id,db_id()) 
	+ '].[' + tables.NAME + ']') AS TableName,
    sum(partitions.rows) as RowCounts
FROM 
    sys.tables tables
INNER JOIN      
    sys.indexes indexes ON tables.OBJECT_ID = indexes.object_id
INNER JOIN 
    sys.partitions partitions ON indexes.object_id = partitions.OBJECT_ID
		 AND indexes.index_id = partitions.index_id
INNER JOIN 
    sys.allocation_units allocation_units ON partitions.partition_id = allocation_units.container_id
WHERE 
   -- t.NAME NOT LIKE 'dt%' AND
    indexes.OBJECT_ID > 255 AND   
    indexes.index_id <= 1
GROUP BY 
    tables.object_id,tables.NAME, indexes.object_id, indexes.index_id, indexes.name 
ORDER BY 
    RowCounts desc