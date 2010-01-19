CREATE  PROCEDURE checksumcookie @cookie uniqueidentifier, @checksum int OUTPUT
AS
declare @chcookie varchar(40)
declare @position int
SELECT @position = 1
SELECT @chcookie = CONVERT(varchar(40),@cookie)
SELECT @checksum = 0
WHILE (LEN(@chcookie) > 0)
BEGIN
SELECT @checksum = @checksum + (ASCII(@chcookie) * @position)
/*SELECT @position = @position + 1*/
SELECT @chcookie = SUBSTRING(@chcookie, 2, LEN(@chcookie)-1)
END
SELECT @checksum = (1089799 % @checksum) + 9999 * @checksum