CREATE PROCEDURE updateprolificscribegroup @userid int, @solocount int, @oldgroupid int OUTPUT,  @newgroupid int OUTPUT, @refreshgroups int OUTPUT
AS
	DECLARE  @PSLevel0 int
	DECLARE  @PSLevel1 int
	DECLARE  @PSLevel2 int
	DECLARE  @PSLevel3 int
	DECLARE  @PSLevel4 int
	DECLARE  @PSLevel5 int
	DECLARE  @PSLevel6 int
	DECLARE  @PSLevel7 int
	DECLARE  @PSLevel8 int
	DECLARE  @PSLevel9 int

	DECLARE  @PSLevel0Group nvarchar(50)
	DECLARE  @PSLevel1Group nvarchar(50)
	DECLARE  @PSLevel2Group nvarchar(50)
	DECLARE  @PSLevel3Group nvarchar(50)
	DECLARE  @PSLevel4Group nvarchar(50)
	DECLARE  @PSLevel5Group nvarchar(50)
	DECLARE  @PSLevel6Group nvarchar(50)
	DECLARE  @PSLevel7Group nvarchar(50)
	DECLARE  @PSLevel8Group nvarchar(50)
	DECLARE  @PSLevel9Group nvarchar(50)
	
	DECLARE  @PSLevel0GroupID int
	DECLARE  @PSLevel1GroupID int
	DECLARE  @PSLevel2GroupID int
	DECLARE  @PSLevel3GroupID int
	DECLARE  @PSLevel4GroupID int
	DECLARE  @PSLevel5GroupID int
	DECLARE  @PSLevel6GroupID int
	DECLARE  @PSLevel7GroupID int
	DECLARE  @PSLevel8GroupID int
	DECLARE  @PSLevel9GroupID int

	SELECT @PSLevel0 = dbo.udf_getsiteoptionsetting(1, 'ProlificScribe', 'Level0')
	SELECT @PSLevel1 = dbo.udf_getsiteoptionsetting(1, 'ProlificScribe', 'Level1')
	SELECT @PSLevel2 = dbo.udf_getsiteoptionsetting(1, 'ProlificScribe', 'Level2')
	SELECT @PSLevel3 = dbo.udf_getsiteoptionsetting(1, 'ProlificScribe', 'Level3')
	SELECT @PSLevel4 = dbo.udf_getsiteoptionsetting(1, 'ProlificScribe', 'Level4')
	SELECT @PSLevel5 = dbo.udf_getsiteoptionsetting(1, 'ProlificScribe', 'Level5')
	SELECT @PSLevel6 = dbo.udf_getsiteoptionsetting(1, 'ProlificScribe', 'Level6')
	SELECT @PSLevel7 = dbo.udf_getsiteoptionsetting(1, 'ProlificScribe', 'Level7')
	SELECT @PSLevel8 = dbo.udf_getsiteoptionsetting(1, 'ProlificScribe', 'Level8')
	SELECT @PSLevel9 = dbo.udf_getsiteoptionsetting(1, 'ProlificScribe', 'Level9')


	SELECT @PSLevel0Group = dbo.udf_getsiteoptionsetting(1, 'ProlificScribe', 'Level0Group')
	SELECT @PSLevel1Group = dbo.udf_getsiteoptionsetting(1, 'ProlificScribe', 'Level1Group')
	SELECT @PSLevel2Group = dbo.udf_getsiteoptionsetting(1, 'ProlificScribe', 'Level2Group')
	SELECT @PSLevel3Group = dbo.udf_getsiteoptionsetting(1, 'ProlificScribe', 'Level3Group')
	SELECT @PSLevel4Group = dbo.udf_getsiteoptionsetting(1, 'ProlificScribe', 'Level4Group')
	SELECT @PSLevel5Group = dbo.udf_getsiteoptionsetting(1, 'ProlificScribe', 'Level5Group')
	SELECT @PSLevel6Group = dbo.udf_getsiteoptionsetting(1, 'ProlificScribe', 'Level6Group')
	SELECT @PSLevel7Group = dbo.udf_getsiteoptionsetting(1, 'ProlificScribe', 'Level7Group')
	SELECT @PSLevel8Group = dbo.udf_getsiteoptionsetting(1, 'ProlificScribe', 'Level8Group')
	SELECT @PSLevel9Group = dbo.udf_getsiteoptionsetting(1, 'ProlificScribe', 'Level9Group')
	
	SELECT @PSLevel0GroupID = GroupID FROM Groups WITH(NOLOCK) WHERE Name = @PSLevel0Group
	SELECT @PSLevel1GroupID = GroupID FROM Groups WITH(NOLOCK) WHERE Name = @PSLevel1Group
	SELECT @PSLevel2GroupID = GroupID FROM Groups WITH(NOLOCK) WHERE Name = @PSLevel2Group
	SELECT @PSLevel3GroupID = GroupID FROM Groups WITH(NOLOCK) WHERE Name = @PSLevel3Group
	SELECT @PSLevel4GroupID = GroupID FROM Groups WITH(NOLOCK) WHERE Name = @PSLevel4Group
	SELECT @PSLevel5GroupID = GroupID FROM Groups WITH(NOLOCK) WHERE Name = @PSLevel5Group
	SELECT @PSLevel6GroupID = GroupID FROM Groups WITH(NOLOCK) WHERE Name = @PSLevel6Group
	SELECT @PSLevel7GroupID = GroupID FROM Groups WITH(NOLOCK) WHERE Name = @PSLevel7Group
	SELECT @PSLevel8GroupID = GroupID FROM Groups WITH(NOLOCK) WHERE Name = @PSLevel8Group
	SELECT @PSLevel9GroupID = GroupID FROM Groups WITH(NOLOCK) WHERE Name = @PSLevel9Group


--	DECLARE @OldGroupID int
	
	SELECT @OldGroupID = GroupID FROM GroupMembers WHERE UserID = @userid AND SiteID = 1 
										AND GroupID IN (	@PSLevel0GroupID,
															@PSLevel1GroupID,
															@PSLevel2GroupID,
															@PSLevel3GroupID,
															@PSLevel4GroupID,
															@PSLevel5GroupID,
															@PSLevel6GroupID,
															@PSLevel7GroupID,
															@PSLevel8GroupID,
															@PSLevel9GroupID)
															
	SELECT @OldGroupID = ISNULL(@OldGroupID, 0)
--	PRINT @OldGroupID
	
--	DECLARE  @NewGroupID int

/*	DELETE FROM GroupMembers
	WHERE UserID = @userid AND SiteID = 1 AND GroupID IN (	@PSLevel0GroupID,
															@PSLevel1GroupID,
															@PSLevel2GroupID,
															@PSLevel3GroupID,
															@PSLevel4GroupID,
															@PSLevel5GroupID,
															@PSLevel6GroupID,
															@PSLevel7GroupID,
															@PSLevel8GroupID,
															@PSLevel9GroupID)
*/
	IF @solocount >= @PSLevel9
	BEGIN		
		SELECT @NewGroupID = @PSLevel9GroupID													
--		INSERT INTO GroupMembers (UserID, SiteID, GroupID) VALUES (@userid, 1, @PSLevel9GroupID)
	END
	ELSE IF @solocount >= @PSLevel8
	BEGIN
		SELECT @NewGroupID = @PSLevel8GroupID													
--		INSERT INTO GroupMembers (UserID, SiteID, GroupID) VALUES (@userid, 1, @PSLevel8GroupID)
	END
	ELSE IF @solocount >= @PSLevel7
	BEGIN
		SELECT @NewGroupID = @PSLevel7GroupID													
--		INSERT INTO GroupMembers (UserID, SiteID, GroupID) VALUES (@userid, 1, @PSLevel7GroupID)
	END
	ELSE IF @solocount >= @PSLevel6
	BEGIN
		SELECT @NewGroupID = @PSLevel6GroupID													
--		INSERT INTO GroupMembers (UserID, SiteID, GroupID) VALUES (@userid, 1, @PSLevel6GroupID)
	END
	ELSE IF @solocount >= @PSLevel5
	BEGIN
		SELECT @NewGroupID = @PSLevel5GroupID													
--		INSERT INTO GroupMembers (UserID, SiteID, GroupID) VALUES (@userid, 1, @PSLevel5GroupID)
	END
	ELSE IF @solocount >= @PSLevel4
	BEGIN
		SELECT @NewGroupID = @PSLevel4GroupID													
--		INSERT INTO GroupMembers (UserID, SiteID, GroupID) VALUES (@userid, 1, @PSLevel4GroupID)
	END
	ELSE IF @solocount >= @PSLevel3
	BEGIN
		SELECT @NewGroupID = @PSLevel3GroupID													
--		INSERT INTO GroupMembers (UserID, SiteID, GroupID) VALUES (@userid, 1, @PSLevel3GroupID)
	END
	ELSE IF @solocount >= @PSLevel2
	BEGIN
		SELECT @NewGroupID = @PSLevel2GroupID													
--		INSERT INTO GroupMembers (UserID, SiteID, GroupID) VALUES (@userid, 1, @PSLevel2GroupID)
	END
	ELSE IF @solocount >= @PSLevel1
	BEGIN
		SELECT @NewGroupID = @PSLevel1GroupID													
--		INSERT INTO GroupMembers (UserID, SiteID, GroupID) VALUES (@userid, 1, @PSLevel1GroupID)
	END
	ELSE IF @solocount >= @PSLevel0
	BEGIN
		SELECT @NewGroupID = @PSLevel0GroupID													
--		INSERT INTO GroupMembers (UserID, SiteID, GroupID) VALUES (@userid, 1, @PSLevel0GroupID)
	END

--	PRINT @NewGroupID

--	DECLARE @refreshgroups int
	SELECT @refreshgroups = 0
	IF @OldGroupID <> @NewGroupID
	BEGIN
		DELETE FROM GroupMembers
		WHERE UserID = @userid AND SiteID = 1 AND GroupID IN (	@PSLevel0GroupID,
																@PSLevel1GroupID,
																@PSLevel2GroupID,
																@PSLevel3GroupID,
																@PSLevel4GroupID,
																@PSLevel5GroupID,
																@PSLevel6GroupID,
																@PSLevel7GroupID,
																@PSLevel8GroupID,
																@PSLevel9GroupID)
																
		INSERT INTO GroupMembers (UserID, SiteID, GroupID) VALUES (@userid, 1, @NewGroupID)
		SELECT @refreshgroups = 1
	END

--	SELECT @OldGroupID 'OldGroup',  @NewGroupID 'NewGroup', @refreshgroups 'RefreshGroups'
	SELECT @userid 'UserID', @OldGroupID 'OldGroup',  @NewGroupID 'NewGroup', @refreshgroups 'RefreshGroups' 
