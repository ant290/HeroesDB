SELECT top (5)
    '[' + (OBJECT_SCHEMA_NAME(tables.object_id,db_id()) 
	+ '].[' + tables.NAME + ']') AS TableName,
    indexes.name as indexName,
    sum(partitions.rows) as RowCounts,
    sum(allocation_units.total_pages) as TotalPages,
    sum(allocation_units.used_pages) as UsedPages,
    sum(allocation_units.data_pages) as DataPages,
    (sum(allocation_units.total_pages) * 8) / 1024 as TotalSpaceMB,
    (sum(allocation_units.used_pages) * 8) / 1024 as UsedSpaceMB,
    (sum(allocation_units.data_pages) * 8) / 1024 as DataSpaceMB,
	GETDATE() AS Datemodified
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
    TotalSpaceMB desc