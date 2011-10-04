Create Procedure addexlinktomodqueue @uri VARCHAR(255), @callbackuri VARCHAR(255), @siteid INT, @complainttext NVARCHAR(MAX) = NULL, @notes VARCHAR(MAX) = NULL
As

INSERT INTO ExLinkMod ( uri, callbackuri,  status, siteid, DateQueued, complainttext, notes ) 
VALUES ( @uri, @callbackuri, 0, @siteid, CURRENT_TIMESTAMP, @complainttext, @notes )

