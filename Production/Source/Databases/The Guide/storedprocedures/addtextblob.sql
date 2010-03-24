/*
Inputs: @text - text to store in the blob
@type - int indicating the type of data (default to 1 for now)
Result: Table containing blobid
Stores a text blob in the table and returns a table containing one row with the blobid

*/
CREATE  PROCEDURE addtextblob @text text, @type int
 AS
INSERT INTO blobs (type, text) VALUES(@type, @text)
SELECT 'blobid' = @@IDENTITY

