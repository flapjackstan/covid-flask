ALTER table StagingSurge ADD isDeleted BOOLEAN;

UPDATE StagingSurge
SET isDeleted = 0;

SELECT CONVERT_TZ(NOW(),'+00:00','-4:00');