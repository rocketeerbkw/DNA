using System;
using System.Collections;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using BBC.Dna.Data;
using BBC.Dna.Utils;
using BBC.Dna.Moderation.Utils;
using BBC.Dna.Moderation;
using BBC.Dna.Common;

namespace BBC.Dna.Component
{
    /// <summary>
    /// Member List - A derived DnaComponent object
    /// </summary>
    public class UserReputationReportBuilder : DnaInputComponent
    {
        private int _modClassId, _modStatus, _days, _startIndex;
        private int _itemsPerPage = 20;
        private SortBy sortBy = SortBy.Created;
        private SortDirection sortDirection = SortDirection.Ascending;
       
        /// <summary>
        /// Default constructor for the Member List component
        /// </summary>
        /// <param name="context">The Context of the DnaPage the component is created in.</param>
        public UserReputationReportBuilder(IInputContext context)
            : base(context)
        {
        }

        /// <summary>
        /// Used to process the current request.
        /// </summary>
        public override void ProcessRequest()
        {
            RootElement.RemoveAll();
            if (InputContext.ViewingUser.IsSuperUser == false)
            {
                SerialiseAndAppend(new Error { Type = "Access Denied", ErrorMessage = "Access denied" }, "");
                return;
            }

            GetParameters();

            UpdateUserList();

            var userRepList = UserReputationList.GetUserReputationList(AppContext.ReaderCreator, _modClassId, _modStatus,
            _days, _startIndex, _itemsPerPage, sortBy, sortDirection);
            SerialiseAndAppend(userRepList, "");
        }


        private void GetParameters()
        {
            _modClassId = 0;
            if(InputContext.DoesParamExist("s_modclassid", "s_modclassid"))
            {
                _modClassId = InputContext.GetParamIntOrZero("s_modclassid", "s_modclassid");
            }

            _modStatus = (int)BBC.Dna.Moderation.Utils.ModerationStatus.UserStatus.Restricted;
            if(InputContext.DoesParamExist("s_modstatus", "s_modstatus"))
            {
                _modStatus = (int)Enum.Parse(typeof(BBC.Dna.Moderation.Utils.ModerationStatus.UserStatus), InputContext.GetParamStringOrEmpty("s_modstatus", "s_modstatus")); ;
            }

            _days =1;
            if(InputContext.DoesParamExist("s_days", "s_days"))
            {
                _days = InputContext.GetParamIntOrZero("s_days", "s_days");
            }

            _startIndex = 0;
            if (InputContext.DoesParamExist("s_startIndex", "startIndex"))
            {
                _startIndex = InputContext.GetParamIntOrZero("s_startIndex", "s_startIndex");
            }

            if (InputContext.DoesParamExist("s_sortby", "sortby"))
            {
                sortBy = (SortBy)Enum.Parse(typeof(SortBy), InputContext.GetParamStringOrEmpty("s_sortby", ""));
            }

            if (InputContext.DoesParamExist("s_sortdirection", "sortdirection"))
            {
                sortDirection = (SortDirection)Enum.Parse(typeof(SortDirection), InputContext.GetParamStringOrEmpty("s_sortdirection", "s_sortdirection"));
            }

        }

        private bool UpdateUserList()
        {
            if (InputContext.DoesParamExist("ApplyAction", "ApplyAction"))
            {
                bool applyToAll = InputContext.DoesParamExist("applyToAll", "applyToAll");

                for(int i=1; i <= _itemsPerPage; i++)
                {
                    string formvar = string.Format("applyto|{0}", i);
                    if (applyToAll || InputContext.DoesParamExist(formvar, formvar))
                    {
                        var userRep = new UserReputation();
                        userRep.UserId = InputContext.GetParamIntOrZero(string.Format("{0}|userid", i), "");
                        userRep.ModClass = new ModerationClass() { ClassId = InputContext.GetParamIntOrZero(string.Format("{0}|modclassid", i), "") };
                        userRep.ReputationDeterminedStatus = (ModerationStatus.UserStatus)Enum.Parse(typeof(ModerationStatus.UserStatus), InputContext.GetParamStringOrEmpty(string.Format("{0}|reputationdeterminedstatus", i), ""));
                        userRep.ApplyModerationStatus(AppContext.ReaderCreator, false, 0, String.Empty, InputContext.ViewingUser.UserID);
                    }
                }
                return true;
            }
            return false;
        }

    }
}
