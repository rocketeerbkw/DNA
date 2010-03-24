using System;
using System.Collections.Generic;
using System.Text;

namespace BBC.Dna
{
    /// <summary>
    /// Interface representing a Dna transformer object. Implement this to transform the xml representation of a dna component into an desired output format.
    /// </summary>
	public interface IDnaTransformer
	{
        /// <summary>
        /// Transform the xml of a Dna component.
        /// </summary>
        /// <param name="component">Dna component to transform.</param>
        /// <returns>true if component's xml is transformed, otherwise false.</returns>
		bool TransformXML(IDnaComponent component);

        /// <summary>
        /// Returns the cached output if avaliable, or null if there isn't any
        /// </summary>
        /// <returns>cached output, or null if none exists</returns>
        string GetCachedOutput();

		/// <summary>
		/// Determines whether, for this request, there is a fully cached output page available
		/// </summary>
		/// <returns>true if there is cached output available. false if not.</returns>
		bool IsCachedOutputAvailable();

		/// <summary>
		/// Writes the current request's cached output to the response. 
		/// </summary>
		void WriteCachedOutput();
	}
}
