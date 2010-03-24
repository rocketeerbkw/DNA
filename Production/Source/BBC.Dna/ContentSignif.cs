using System;
using System.Globalization;
using System.Collections;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using System.Text.RegularExpressions;

namespace BBC.Dna.Component
{
    /// <summary>
    /// Summary of the ContentSignif Page object
    /// </summary>
    public class ContentSignif : DnaInputComponent
    {
        private const string _docDnaDecrementContentSignif = @"Decrease the significance of this content.";

        /// <summary>
        /// Default constructor for the ContentSignif component
        /// </summary>
        /// <param name="context">The Context of the DnaPage the component is created in.</param>
        public ContentSignif(IInputContext context)
            : base(context)
        {
        }

        /// <summary>
        /// Used to process the current request.
        /// </summary>
        public override void ProcessRequest()
        {
            SignifContent signifContent = new SignifContent(InputContext);
            if (InputContext.DoesParamExist("decrementcontentsignif", _docDnaDecrementContentSignif))
            {
                signifContent.DecrementContentSignif(InputContext.CurrentSite.SiteID);
            }
            signifContent.GetMostSignifContent(InputContext.CurrentSite.SiteID);
            AddInside(signifContent);
        }
    }
}