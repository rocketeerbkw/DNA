CREATE VIEW VArticleVideoAssets WITH SCHEMABINDING
AS
	SELECT ma.SiteID, ama.EntryID, ama.MediaAssetID
	  FROM dbo.ArticleMediaAsset ama 
			INNER JOIN dbo.VideoAsset va ON ama.MediaAssetID = va.MediaAssetID
			INNER JOIN dbo.MediaAsset ma ON ama.MediaAssetID = ma.ID
	 WHERE ma.Hidden IS NULL
