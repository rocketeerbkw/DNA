-- Indexes to test performance of ArticleSearch with. 
CREATE CLUSTERED INDEX IX_ArticleLocation_EntryID ON ArticleLocation (EntryID);

CREATE NONCLUSTERED INDEX IX_ArticleLocation_LatLong ON ArticleLocation (Latitude, Longitude); 