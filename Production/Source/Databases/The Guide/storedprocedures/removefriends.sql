CREATE PROCEDURE removefriends @userid int, @siteid int, 
					@friendid1 int,
					@friendid2 int,
					@friendid3 int,
					@friendid4 int,
					@friendid5 int,
					@friendid6 int,
					@friendid7 int,
					@friendid8 int,
					@friendid9 int,
					@friendid10 int,
					@friendid11 int,
					@friendid12 int,
					@friendid13 int,
					@friendid14 int,
					@friendid15 int,
					@friendid16 int
As

declare @name varchar(50)
select @name = 'Friend_' + CAST(@userid as varchar)
BEGIN TRANSACTION
declare @groupid int
select @groupid = GroupID FROM Groups where Name = @name AND System = 1 AND Owner = @userid

if @groupid IS NULL
BEGIN
ROLLBACK TRANSACTION
select 'GroupID' = @groupid
return 0
END

DELETE FROM GroupMembers
WHERE UserID IN (@friendid1,
				@friendid2,
				@friendid3,
				@friendid4,
				@friendid5,
				@friendid6,
				@friendid7,
				@friendid8,
				@friendid9,
				@friendid10,
				@friendid11,
				@friendid12,
				@friendid13,
				@friendid14,
				@friendid15,
				@friendid16)
COMMIT TRANSACTION
