using System;
using System.Collections.Generic;
using System.Text;
using BBC.Dna;
using BBC.Dna.Component;
using BBC.Dna.Data;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using NMock2;

namespace Tests
{
    /// <summary>
    /// Tests for SP CheckIfArticleShouldBeHidden.
    /// </summary>
    [TestClass]
    public class CheckIfArticleShouldBeHidden
    {
        /// <summary>
        /// Setup method
        /// </summary>
        [TestCleanup]
        public void TearDown()
        {
            SnapshotInitialisation.ForceRestore();
        }

        /// <summary>
        /// Null UserID generates an error.
        /// </summary>
        [TestMethod]
        public void ErrorOnNullUserID()
        {
            IInputContext context = DnaMockery.CreateDatabaseInputContext();
            using (IDnaDataReader reader = context.CreateDnaDataReader("checkifarticleshouldbehidden"))
            {
                try
                {
                    reader.AddParameter("userid", DBNull.Value);
                    reader.AddParameter("siteid", "1");
                    reader.AddParameter("h2g2id", 1);
                    reader.AddIntOutputParameter("hide");
                    reader.Execute();
                }
                catch (Exception e)
                {
                    Assert.IsTrue(e.Message == "Param UserID is null in CheckIfArticleShouldBeHidden.", "Unexpected error message"); 
                }
            }
        }

        /// <summary>
        /// Null SiteID generates an error.
        /// </summary>
        [TestMethod]
        public void ErrorOnNullSiteID()
        {
            IInputContext context = DnaMockery.CreateDatabaseInputContext();
            using (IDnaDataReader reader = context.CreateDnaDataReader("checkifarticleshouldbehidden"))
            {
                try
                {
                    reader.AddParameter("userid", 1090501859);
                    reader.AddParameter("siteid", DBNull.Value);
                    reader.AddParameter("h2g2id", 1);
                    reader.AddIntOutputParameter("hide");
                    reader.Execute();
                }
                catch (Exception e)
                {
                    Assert.IsTrue(e.Message == "Param SiteID is null in CheckIfArticleShouldBeHidden.", "Unexpected error message");
                }
            }
        }

        /// <summary>
        /// New article (i.e. h2g2id is null) should not be hidden on reactively moderated siteid and user. 
        /// </summary>
        [TestMethod]
        public void DontErrorOnNullh2g2id()
        {
            IInputContext context = DnaMockery.CreateDatabaseInputContext();
            using (IDnaDataReader reader = context.CreateDnaDataReader("checkifarticleshouldbehidden"))
            {
                reader.AddParameter("userid", 1090501859);
                reader.AddParameter("siteid", 1);
                reader.AddParameter("h2g2id", DBNull.Value);
                reader.AddIntOutputParameter("hide");
                reader.Execute();

                int hideArticle;
                reader.TryGetIntOutputParameter("hide", out hideArticle);
                Assert.IsTrue(hideArticle == 0, "HideArticle should be false."); 
            }
        }

        /// <summary>
        /// Hide article if premod user
        /// </summary>
        [TestMethod]
        public void HideArticleIfPreModUser()
        {
            IInputContext context = DnaMockery.CreateDatabaseInputContext();
            using (IDnaDataReader reader = context.CreateDnaDataReader(""))
            {
                reader.ExecuteDEBUGONLY("UPDATE dbo.Preferences SET PrefStatus = 1 WHERE UserID = 1090501859 AND SiteID = 1");
            }

            using (IDnaDataReader reader = context.CreateDnaDataReader("checkifarticleshouldbehidden"))
            {
                reader.AddParameter("userid", 1090501859);
                reader.AddParameter("siteid", 1);
                reader.AddParameter("h2g2id", DBNull.Value);
                reader.AddIntOutputParameter("hide");
                reader.Execute();

                int hideArticle;
                reader.TryGetIntOutputParameter("hide", out hideArticle);
                Assert.IsTrue(hideArticle == 1, "HideArticle should be true.");
            }
        }

        /// <summary>
        /// Don't hide article if postmod user
        /// </summary>
        [TestMethod]
        public void DontHideArticleIfPostModUser()
        {
            IInputContext context = DnaMockery.CreateDatabaseInputContext();
            using (IDnaDataReader reader = context.CreateDnaDataReader(""))
            {
                reader.ExecuteDEBUGONLY("UPDATE dbo.Preferences SET PrefStatus = 2 WHERE UserID = 1090501859 AND SiteID = 1");
            }

            using (IDnaDataReader reader = context.CreateDnaDataReader("checkifarticleshouldbehidden"))
            {
                reader.AddParameter("userid", 1090501859);
                reader.AddParameter("siteid", 1);
                reader.AddParameter("h2g2id", DBNull.Value);
                reader.AddIntOutputParameter("hide");
                reader.Execute();

                int hideArticle;
                reader.TryGetIntOutputParameter("hide", out hideArticle);
                Assert.IsTrue(hideArticle == 0, "HideArticle should be false.");
            }
        }

        /// <summary>
        /// Error on banned user
        /// </summary>
        [TestMethod]
        public void ErrorOnBannedUser()
        {
            IInputContext context = DnaMockery.CreateDatabaseInputContext();
            using (IDnaDataReader reader = context.CreateDnaDataReader(""))
            {
                reader.ExecuteDEBUGONLY("UPDATE dbo.Preferences SET PrefStatus = 4 WHERE UserID = 1090501859 AND SiteID = 1");
            }

            using (IDnaDataReader reader = context.CreateDnaDataReader("checkifarticleshouldbehidden"))
            {
                try
                {
                    reader.AddParameter("userid", 1090501859);
                    reader.AddParameter("siteid", 1);
                    reader.AddParameter("h2g2id", DBNull.Value);
                    reader.AddIntOutputParameter("hide");
                    reader.Execute();
                }
                catch (Exception e)
                {
                    Assert.IsTrue(e.Message == "In CheckIfArticleShouldBeHidden but UserID 1090501859 is banned.", "Unexpected error message");
                }
            }
        }

        /// <summary>
        /// Hide if site is in premod
        /// </summary>
        [TestMethod]
        public void HideIfSiteInPreMod()
        {
            IInputContext context = DnaMockery.CreateDatabaseInputContext();
            using (IDnaDataReader reader = context.CreateDnaDataReader(""))
            {
                reader.ExecuteDEBUGONLY("UPDATE dbo.Sites SET PreModeration = 1 WHERE SiteID = 1");
            }

            using (IDnaDataReader reader = context.CreateDnaDataReader("checkifarticleshouldbehidden"))
            {
                reader.AddParameter("userid", 1090501859);
                reader.AddParameter("siteid", 1);
                reader.AddParameter("h2g2id", DBNull.Value);
                reader.AddIntOutputParameter("hide");
                reader.Execute();

                int hideArticle;
                reader.TryGetIntOutputParameter("hide", out hideArticle);
                Assert.IsTrue(hideArticle == 1, "HideArticle should be true.");
            }
        }

        /// <summary>
        /// Don't hide if site in postmod
        /// </summary>
        [TestMethod]
        public void DontHideIfSiteInPostMod()
        {
            IInputContext context = DnaMockery.CreateDatabaseInputContext();
            using (IDnaDataReader reader = context.CreateDnaDataReader(""))
            {
                reader.ExecuteDEBUGONLY("UPDATE dbo.Sites SET PreModeration = 0, Unmoderated = 0 WHERE SiteID = 1");
            }

            using (IDnaDataReader reader = context.CreateDnaDataReader("checkifarticleshouldbehidden"))
            {
                reader.AddParameter("userid", 1090501859);
                reader.AddParameter("siteid", 1);
                reader.AddParameter("h2g2id", DBNull.Value);
                reader.AddIntOutputParameter("hide");
                reader.Execute();

                int hideArticle;
                reader.TryGetIntOutputParameter("hide", out hideArticle);
                Assert.IsTrue(hideArticle == 0, "HideArticle should be true.");
            }
        }

        /// <summary>
        /// Don't hide if site in postmod
        /// </summary>
        [TestMethod]
        public void DontHideIfUserIsInAutoSinBin()
        {
            IInputContext context = DnaMockery.CreateDatabaseInputContext();
            using (IDnaDataReader reader = context.CreateDnaDataReader(""))
            {
                reader.ExecuteDEBUGONLY("UPDATE dbo.Preferences SET AutoSinBin = 1 WHERE UserID = 1090501859");
            }

            using (IDnaDataReader reader = context.CreateDnaDataReader("checkifarticleshouldbehidden"))
            {
                reader.AddParameter("userid", 1090501859);
                reader.AddParameter("siteid", 1);
                reader.AddParameter("h2g2id", DBNull.Value);
                reader.AddIntOutputParameter("hide");
                reader.Execute();

                int hideArticle;
                reader.TryGetIntOutputParameter("hide", out hideArticle);
                Assert.IsTrue(hideArticle == 1, "HideArticle should be true.");
            }
        }

        /// <summary>
        /// Don't hide article by reactive user if not article is not in moderation and on reactive site. 
        /// </summary>
        [TestMethod]
        public void DontHideArticleByReactiveUserIfArticleNotInModerationAndOnReactiveSite()
        {
            IInputContext context = DnaMockery.CreateDatabaseInputContext();

            using (IDnaDataReader reader = context.CreateDnaDataReader("checkifarticleshouldbehidden"))
            {
                reader.AddParameter("userid", 1090501859);
                reader.AddParameter("siteid", 1);
                reader.AddParameter("h2g2id", 559);
                reader.AddIntOutputParameter("hide");
                reader.Execute();

                int hideArticle;
                reader.TryGetIntOutputParameter("hide", out hideArticle);
                Assert.IsTrue(hideArticle == 0, "HideArticle should be true.");
            }
        }

        /// <summary>
        /// Don't hide article by reactive user if not article is not in moderation and on postmod site. 
        /// </summary>
        [TestMethod]
        public void DontHideArticleByReactiveUserIfArticleNotInModerationAndOnPostModSite()
        {
            IInputContext context = DnaMockery.CreateDatabaseInputContext();
            using (IDnaDataReader reader = context.CreateDnaDataReader(""))
            {
                reader.ExecuteDEBUGONLY("UPDATE dbo.Sites SET PreModeration = 0, Unmoderated = 0 WHERE SiteID = 1");
            }

            using (IDnaDataReader reader = context.CreateDnaDataReader("checkifarticleshouldbehidden"))
            {
                reader.AddParameter("userid", 1090501859);
                reader.AddParameter("siteid", 1);
                reader.AddParameter("h2g2id", 559);
                reader.AddIntOutputParameter("hide");
                reader.Execute();

                int hideArticle;
                reader.TryGetIntOutputParameter("hide", out hideArticle);
                Assert.IsTrue(hideArticle == 0, "HideArticle should be true.");
            }
        }

        /// <summary>
        /// hide article by reactive user if article failed in moderation even if on reactive site. 
        /// </summary>
        [TestMethod]
        public void HideArticleByReactiveUserIfArticleFailedInModerationEvenIfOnReactiveSite()
        {
            IInputContext context = DnaMockery.CreateDatabaseInputContext();
            using (IDnaDataReader reader = context.CreateDnaDataReader(""))
            {
                reader.ExecuteDEBUGONLY("INSERT INTO dbo.ArticleMod values (559, null, null, null, 4, null, null, '2008-05-08', null, null, null, null, null, null, null)");
            }

            using (IDnaDataReader reader = context.CreateDnaDataReader("checkifarticleshouldbehidden"))
            {
                reader.AddParameter("userid", 1090501859);
                reader.AddParameter("siteid", 1);
                reader.AddParameter("h2g2id", 559);
                reader.AddIntOutputParameter("hide");
                reader.Execute();

                int hideArticle;
                reader.TryGetIntOutputParameter("hide", out hideArticle);
                Assert.IsTrue(hideArticle == 1, "HideArticle should be true.");
            }
        }

        /// <summary>
        /// Hide article by reactive user if article is referred even if site is reactive. 
        /// </summary>
        [TestMethod]
        public void HideArticleByReactiveUserIfArticleIsReferredInModerationEvenIfOnReactiveSite()
        {
            IInputContext context = DnaMockery.CreateDatabaseInputContext();
            using (IDnaDataReader reader = context.CreateDnaDataReader(""))
            {
                reader.ExecuteDEBUGONLY("INSERT INTO dbo.ArticleMod values (559, null, null, null, 2, null, null, null, null, null, null, null, null, null, null)");
            }

            using (IDnaDataReader reader = context.CreateDnaDataReader("checkifarticleshouldbehidden"))
            {
                reader.AddParameter("userid", 1090501859);
                reader.AddParameter("siteid", 1);
                reader.AddParameter("h2g2id", 559);
                reader.AddIntOutputParameter("hide");
                reader.Execute();

                int hideArticle;
                reader.TryGetIntOutputParameter("hide", out hideArticle);
                Assert.IsTrue(hideArticle == 1, "HideArticle should be true.");
            }
        }

        /// <summary>
        /// Hide article by reactive user if not article is locked by moderator even if site is reactive. 
        /// </summary>
        [TestMethod]
        public void HideArticleByReactiveUserIfArticleIsLockedByModeratorEvenIfOnReactiveSite()
        {
            IInputContext context = DnaMockery.CreateDatabaseInputContext();
            using (IDnaDataReader reader = context.CreateDnaDataReader(""))
            {
                reader.ExecuteDEBUGONLY("INSERT INTO dbo.ArticleMod values (559, getdate(), getdate(), 6, 0, null, null, null, null, null, null, null, null, null, null)");
            }

            using (IDnaDataReader reader = context.CreateDnaDataReader("checkifarticleshouldbehidden"))
            {
                reader.AddParameter("userid", 1090501859);
                reader.AddParameter("siteid", 1);
                reader.AddParameter("h2g2id", 559);
                reader.AddIntOutputParameter("hide");
                reader.Execute();

                int hideArticle;
                reader.TryGetIntOutputParameter("hide", out hideArticle);
                Assert.IsTrue(hideArticle == 1, "HideArticle should be true.");
            }
        }     
    }
}
