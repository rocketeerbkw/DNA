using System;
using System.Collections.Generic;
using System.Text;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;

namespace BBC.Dna.Utils
{
    /// <summary>
    /// Dna representation of a cookie. Enables decoupling from the HttpContext.
    /// </summary>
	public class DnaCookie
	{
		private string _name;
        private string _value;

        /// <summary>
        /// Get/Set the name of the cookie.
        /// </summary>
		public string Name
		{
			get { return _name; }
			set { _name = value; }
		}

        /// <summary>
        /// Get/Set the value of the cookie.
        /// </summary>
        public string Value
        {
            get { return HttpUtility.UrlDecode(_value); }
            set { _value = HttpUtility.UrlEncode(value); }
        }

        /// <summary>
        /// Default constructor for the DnaCookie.
        /// </summary>
		public DnaCookie()
		{
		}

        /// <summary>
        /// Construct a DnaCookie from an HttpCookie.
        /// </summary>
        /// <param name="cookie"></param>
		public DnaCookie(HttpCookie cookie)
		{
            _name = cookie.Name;
            _value = cookie.Value;
		}
	}
}
