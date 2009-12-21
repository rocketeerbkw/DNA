using System;
using System.Data;
using System.Collections;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;

namespace ActionlessForm
{
	/// <summary>
	/// This class overrides the normal server-side form
	/// </summary>
	public class Form : System.Web.UI.HtmlControls.HtmlForm
	{
		/// <summary>
		/// Overrides the renderAttribute method, so it doesn't output an action attribute
		/// </summary>
		/// <param name="writer"></param>
		protected override void RenderAttributes(HtmlTextWriter writer)
		{
			string action = Context.Items["VirtualUrl"] as string;

			if (action == null)
				base.RenderAttributes(writer);

			using (ActionFormHtmlTextWriter virtualWriter = new ActionFormHtmlTextWriter(writer))
			{
				virtualWriter.ActionUrl = action;
				base.RenderAttributes(virtualWriter);
			}
		}

		private class ActionFormHtmlTextWriter : HtmlTextWriter
		{
			private string actionUrl;

			public ActionFormHtmlTextWriter(HtmlTextWriter writer)
				: base(writer)
			{
			}

			public ActionFormHtmlTextWriter(HtmlTextWriter writer, string tabString)
				: base(writer, tabString)
			{
			}

			public string ActionUrl
			{
				get { return actionUrl; }
				set { actionUrl = value; }
			}

			public override void WriteAttribute(string name, string value, bool fEncode)
			{
				if (value != null && String.Compare(name, "action", true) == 0)
					value = ActionUrl;

				HtmlTextWriter writer = (HtmlTextWriter)InnerWriter;
				writer.WriteAttribute(name, value, fEncode);
			}
		}



	}
}

