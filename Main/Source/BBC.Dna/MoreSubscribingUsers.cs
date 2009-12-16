using System;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using BBC.Dna.Component;

namespace BBC.Dna.Component
{
	/// <summary>
	/// Class handling the building of the MSU page
	/// </summary>
	public class MoreSubscribingUsers : DnaInputComponent
	{
		/// <summary>
		/// Constructor for page builder
		/// </summary>
		/// <param name="context">Input context for this request</param>
		public MoreSubscribingUsers(IInputContext context)
			: base(context)
		{
		}

		/// <summary>
		/// Process request to MSU page
		/// </summary>
		public override void ProcessRequest()
		{
			RootElement.RemoveAll();

			int userID = 0;
			int skip=0;
			int show=20;

			GetPageParams(ref userID, ref skip, ref show);

			CreateMoreSubscribedUsers(userID, skip, show);			
		}

		private void CreateMoreSubscribedUsers(int userID, int skip, int show)
		{
			SubscribingUsersList subscribingUsersList = new SubscribingUsersList(InputContext);
			subscribingUsersList.CreateSubscribingUsersList(userID, skip, show);
			XmlElement moreSubscribingUsers = AddElementTag(RootElement, "MORESUBSCRIBINGUSERS");
			AddAttribute(moreSubscribingUsers, "USERID", userID);
            AddAttribute(moreSubscribingUsers, "ACCEPTSUBSCRIPTIONS", Convert.ToInt32(subscribingUsersList.UserAcceptsSubscriptions));
			AddInside(moreSubscribingUsers, subscribingUsersList);
		}

		private void GetPageParams(ref int userID, ref int skip, ref int show)
		{
			userID = InputContext.GetParamIntOrZero("userid", "ID of user whose list of subscribed users we want to display");
			skip = InputContext.GetParamIntOrZero("skip", "Skip over this many items in the list");
			show = InputContext.GetParamIntOrZero("show", "Show this many items on the page");
			if (show > 200)
			{
				show = 200;
			}
			if (show == 0)
			{
				show = 25;
			}
			if (skip < 0)
			{
				skip = 0;
			}
		}

	}
}
