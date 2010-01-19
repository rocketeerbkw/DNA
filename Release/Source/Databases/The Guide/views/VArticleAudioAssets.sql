CREATE VIEW VArticleAudioAssets WITH SCHEMABINDING
AS
	SELECT ma.SiteID, ama.EntryID, ama.MediaAssetID
	  FROM dbo.ArticleMediaAsset ama 
			INNER JOIN dbo.AudioAsset aa ON ama.MediaAssetID = aa.MediaAssetID
			INNER JOIN dbo.MediaAsset ma ON ama.MediaAssetID = ma.ID
	 WHERE ma.Hidden IS NULL
