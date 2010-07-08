using System;
using System.Collections.Generic;
using System.Text;
using System.IO;
using BBC.Dna.Sites;

namespace BBC.Dna
{
    /// <summary>
    /// ?
    /// </summary>
    public class SkinSelector
    {
        private string _skinName;
        private string _skinSet;

        /// <summary>
        /// 
        /// </summary>
        public string SkinName
        {
            get
            {
                return _skinName;
            }
        }

        /// <summary>
        /// 
        /// </summary>
        public string SkinSet
        {
            get
            {
                return _skinSet;
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="inputContext"></param>
        /// <returns></returns>
        public bool IsXmlSkin(IInputContext inputContext)
        {
            List<string> skinNames = GetOrderedSkinNames(inputContext);
            foreach (string skinName in skinNames)
            {
                string skin = skinName;
                if ( skin.Equals("xml") || skin.EndsWith("-xml", true, null))
                {
                    return true;
                }
            }
            return false;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public bool IsPureXml(IInputContext inputContext)
        {
            List<string> skinNames = GetOrderedSkinNames(inputContext);
            foreach (string skinName in skinNames)
            {
                string skin = skinName;
                if (skin.Equals("purexml") )
                {
                    return true;
                }
            }
            return false;
        }

        
        /// <summary>
        /// 
        /// </summary>
        ///<param name="inputContext"></param>
        /// <param name="outputContext"></param>
        /// <returns></returns>
        public bool Initialise(IInputContext inputContext, IOutputContext outputContext)
        {
            _skinSet = inputContext.CurrentSite.SkinSet;
 
            List<string> skinNames = GetOrderedSkinNames(inputContext);
            foreach (string skinName in skinNames)
            {

                _skinName = skinName.ToLower();
                if (_skinName.EndsWith("-xml", true, null))
                {
                    // Legacy support  -xml indicates xml skin. 
                    _skinName = "xml";
                }

                if (VerifySkin(_skinName, inputContext.CurrentSite))
                {
                    return true;
                }
            }

            //Fallback to specified Skin in Vanilla SkinSet.
            if ( _skinName != null && _skinName != string.Empty )
            {
                if ( outputContext.VerifySkinFileExists( _skinName, "vanilla") )
                {
                    _skinSet = "vanilla";
                    return true;
                }
            }

            //Fallback to users preferred skin
            if ( inputContext.ViewingUser != null && inputContext.ViewingUser.UserLoggedIn)
            {
                if (inputContext.ViewingUser.PreferredSkin.Length != 0 && VerifySkin(inputContext.ViewingUser.PreferredSkin, inputContext.CurrentSite))
                {
                    _skinName = inputContext.ViewingUser.PreferredSkin.ToLower();
                    return true;
                }
            }

            // Fallback to default skin for site.
            if (VerifySkin(inputContext.CurrentSite.DefaultSkin, inputContext.CurrentSite))
            {
                _skinName = inputContext.CurrentSite.DefaultSkin.ToLower();
                return true;
            }

            // Try to return vanilla default skin.
            if (outputContext.VerifySkinFileExists("html", "vanilla"))
            {
                _skinName = "html";
                _skinSet = "vanilla";
                return true;
            }

            //Error - no skin.
            return false;
            
        }

        private List<string> GetOrderedSkinNames(IInputContext inputContext)
        {
            List<string> orderedSkinNames = new List<string>();

            if (inputContext.DoesParamExist("skin", "Chekc to see if we've been given a skin param"))
            {
            orderedSkinNames.Add(inputContext.GetParamStringOrEmpty("skin", "Preferred skin to use. Overrides user preference and the URL skin name. Only skins which belong to the current site are valid. An invalid skin will be ignored"));
            }

            if (inputContext.DoesParamExist("_sk", "Check to see if we've been given a _sk param"))
            {
            orderedSkinNames.Add(inputContext.GetParamStringOrEmpty("_sk", @"Skin passed in as part of the URL. /dna/sitename/skinname/pagetype will be transformed so that the _sk parameter contains the skin specified by the URL"));
            }

            return orderedSkinNames;
        }

        private bool VerifySkin(string skinName, ISite site)
        {
            if (skinName == null || skinName.Length == 0)
            {
                return false;
            }
            if (skinName.ToLower() == "purexml" )
            {
                return true;
            }

            return site.DoesSkinExist(skinName);
        }
    }
}
