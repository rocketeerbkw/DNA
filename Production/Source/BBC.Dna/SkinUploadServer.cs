using System;
using System.Collections;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using System.IO;
using System.Web;

namespace BBC.Dna.Component
{
    /// <summary>
    /// Summary of the MoreComment Page object, holds the list of comments for a user
    /// </summary>
    public class SkinUploadServer : DnaInputComponent
    {
        private const string _docDnaSkinName = @"The skin name they're trying to upload to.";
        private const string _docDnaSkinPathStub = @"The directory stub of the skin falls.";

        /// <summary>
        /// Default constructor for the SkinUploadServer component
        /// </summary>
        /// <param name="context">The Context of the DnaPage the component is created in.</param>
        public SkinUploadServer(IInputContext context)
            : base(context)
        {
        }

        /// <summary>
        /// Used to process the current request.
        /// </summary>
        public override void ProcessRequest()
        {
            //Clean any existing XML.
            RootElement.RemoveAll();

            string baseSkinPath = AppContext.TheAppContext.Config.GetSkinRootFolder();
            InputContext.Diagnostics.WriteToLog("SKINUPLOAD-baseskinpath", baseSkinPath);

            string skinStubPath = InputContext.GetParamStringOrEmpty("skinstubpath", _docDnaSkinName);
            InputContext.Diagnostics.WriteToLog("SKINUPLOAD-skinstubpath", skinStubPath);

            string skinName = InputContext.GetParamStringOrEmpty("skinname", _docDnaSkinPathStub);
            InputContext.Diagnostics.WriteToLog("SKINUPLOAD-skinname", skinName);

            XmlElement skinUpload = AddElementTag(RootElement, "SKINUPLOAD");
            XmlElement skinsSaved = AddElementTag(skinUpload, "SKINSSAVED");

            if (skinStubPath != null && skinStubPath != String.Empty && skinName != null && skinName != String.Empty)
            {
                string fullSkinPath = baseSkinPath + "\\" + skinName + "\\" + skinStubPath;
                AddTextTag(skinsSaved, "PATH", fullSkinPath);

                if (!Directory.Exists(fullSkinPath))
                {
                    Directory.CreateDirectory(fullSkinPath);
                }

                foreach (string f in InputContext.CurrentDnaRequest.Files.AllKeys)
                {
                    HttpPostedFile file = InputContext.CurrentDnaRequest.Files[f];
                    file.SaveAs(fullSkinPath + "\\" + file.FileName);

                    XmlElement skinsFile = AddElementTag(skinsSaved, "FILE");
                    AddTextTag(skinsFile, "FILENAME", file.FileName);
                }
            }
        }
    }
}