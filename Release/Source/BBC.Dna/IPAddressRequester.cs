using BBC.Dna.Data;

namespace BBC.Dna
{
    /// <summary>
    /// 
    /// </summary>
    public class IPAddressRequester
    {
        /// <summary>
        /// Request the IP Address of a post.
        /// </summary>
        /// <param name="entryId"></param>
        /// <param name="reason"></param>
        /// <param name="context"></param>
        /// <param name="modId"></param>
        /// <returns></returns>
        public string RequestIPAddress(int entryId, string reason, int modId, IInputContext context)
        {
            using (IDnaDataReader reader = context.CreateDnaDataReader("getipaddressforthreadentry"))
            {
                reader.AddParameter("entryid", entryId);
                reader.AddParameter("userid", context.ViewingUser.UserID);
                reader.AddParameter("reason", reason);
                reader.AddParameter("modid", modId);
                reader.Execute();

                if (reader.HasRows)
                {
                    reader.Read();
					if (reader.DoesFieldExist("DatePosted") && !reader.IsDBNull("DatePosted"))
					{
						return string.Format("{0}\r\nPosted: {1}", reader[0].ToString(), reader["DatePosted"]);
					}
					else
					{
						return reader[0].ToString();
					}
                }
            }
            return "";
        }
    }
}
