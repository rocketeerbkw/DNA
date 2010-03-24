/* doesemailexist

In: @email - email address to check
Result: No records returned if no user record matches
otherwise:
UserID - integer UID of user record
Cookie - GUID of record

Checks an email address to see if it exists in the database. returns an empty set
if it doesn't, otherwise returns one record for each entry in the table which matches.

*/

CREATE PROCEDURE doesemailexist @email varchar(255)
AS
SELECT UserID, Cookie From Users WHERE email = @email AND Status <> 0