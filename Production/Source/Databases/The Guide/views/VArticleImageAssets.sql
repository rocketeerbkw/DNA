CREATE VIEW VArticleImageAssets WITH SCHEMABINDING
AS
	SELECT ma.SiteID, ama.EntryID, ama.MediaAssetID
	  FROM dbo.ArticleMediaAsset ama 
			INNER JOIN dbo.ImageAsset ia ON ama.MediaAssetID = ia.MediaAssetID
			INNER JOIN dbo.MediaAsset ma ON ama.MediaAssetID = ma.ID
	 WHERE ma.Hidden IS NULL