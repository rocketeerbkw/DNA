using System;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using System.Threading;
using System.Diagnostics;
using System.Text.RegularExpressions;

using BBC.Dna.Utils;
using BBC.Dna.Data;

namespace BBC.Dna
{
    /// <summary>
    /// General class for handling the profanity list admin
    /// </summary>
    public class ProfanityAdmin : DnaInputComponent
    {
        /// <summary>
        /// Default constructor for the ProfanityAdmin component
        /// </summary>
        /// <param name="context">The Context of the DnaPage the component is created in.</param>
        public ProfanityAdmin(IInputContext context)
            : base(context)
        {
        }

        /// <summary>
        /// Used to process the current request.
        /// </summary>
        public override void ProcessRequest()
        {
        }

    }
}