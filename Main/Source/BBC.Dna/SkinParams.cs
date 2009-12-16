using System;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using BBC.Dna;
using BBC.Dna.Data;

namespace BBC.Dna.Component
{
	/// <summary>
	/// A class to get all the s_ params in the current query
	/// and put them in the XML
	/// </summary>
	public class SkinParams : DnaInputComponent
	{
		/// <summary>
		/// Constructor for SkinParams
		/// </summary>
		/// <param name="context">Input context for request</param>
		public SkinParams(IInputContext context)
			: base(context)
		{
		}

		/// <summary>
		/// <see cref="IDnaComponent"/>
		/// </summary>
		public override void ProcessRequest()
		{
			RootElement.RemoveAll();

			XmlNode paramList = AddElementTag(RootElement, "PARAMS");
			List<string> names = InputContext.GetAllParamNames();
			foreach (string paramname in names)
			{
				if (paramname.StartsWith("s_"))
				{
					XmlNode thisparam = AddElementTag(paramList, "PARAM");
					AddTextTag(thisparam, "NAME", paramname);
					AddTextTag(thisparam, "VALUE",InputContext.GetParamStringOrEmpty(paramname, "Parameters starting s_ are passed and used by the skin and generally have no effect on the server side"));
				}
			}
		}
	}
}
