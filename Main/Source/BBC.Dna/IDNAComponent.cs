using System;
using System.Collections.Generic;
using System.Text;
using System.Xml;

namespace BBC.Dna
{
    /// <summary>
    /// Basic Interface for the DnaComponent class
    /// </summary>
	/// <remarks>
	/// 
	/// </remarks>
    public interface IDnaComponent
    {
		/// <summary>
		/// Property exposing the root element of this component.
		/// </summary>
		XmlElement RootElement
		{
			get;
		}
    }
}
