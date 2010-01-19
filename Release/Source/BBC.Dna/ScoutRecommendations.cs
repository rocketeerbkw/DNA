using System;
using System.Collections;
using System.Collections.Generic;
using System.Text;
using System.Xml;

namespace BBC.Dna.Component
{
    /// <summary>
    /// Summary of the ScoutRecommendations Page object, holds the list of ScoutRecommendations of a scout
    /// </summary>
    public class ScoutRecommendations : DnaInputComponent
    {
        /// <summary>
        /// Default constructor for the ScoutRecommendations component
        /// </summary>
        /// <param name="context">The Context of the DnaPage the component is created in.</param>
        public ScoutRecommendations(IInputContext context)
            : base(context)
        {
        }

        /// <summary>
        /// Used to process the current request.
        /// </summary>
        public override void ProcessRequest()
        {
            //if not an editor or scout then return an error
            if (InputContext.ViewingUser.UserID == 0 || !(InputContext.ViewingUser.IsEditor || InputContext.ViewingUser.IsScout))
            {
                AddErrorXml("NOT-EDITOR", "You cannot allocate recommended entries to sub editors unless you are logged in as an Editor.", RootElement);
                return;
            }

            ArticleList recommendations = new ArticleList(InputContext);
            recommendations.CreateUndecidedRecommendationsList(0, 50);

            RootElement.RemoveAll();
            XmlElement undecidedRecommendations = AddElementTag(RootElement, "UNDECIDED-RECOMMENDATIONS");
            AddInside(undecidedRecommendations, recommendations);  
        }

        /// <summary>
        /// Creates the XML for a blank scout recommendations form.
        /// </summary>
        public void CreateBlankForm()
        {
            RootElement.RemoveAll();
            XmlElement blankForm = AddElementTag(RootElement, "SCOUT-RECOMMENDATIONS-FORM");
            AddElementTag(blankForm, "H2G2ID");
            AddElementTag(blankForm, "SUBJECT");
            AddElementTag(blankForm, "BODY");
            AddElementTag(blankForm, "COMMENTS");
            AddElementTag(blankForm, "AUTHOR");
            AddElementTag(blankForm, "SCOUT");
            AddElementTag(blankForm, "FUNCTIONS");

        }
    }
}