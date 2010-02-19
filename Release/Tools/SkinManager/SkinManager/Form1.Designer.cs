using System;
using System.Drawing;
using System.Collections;
using System.ComponentModel;
using System.Windows.Forms;
using System.Data;
using System.Net;
using System.Text;
using System.Text.RegularExpressions;
using System.IO;
using System.Xml;
using System.Xml.XPath;
using System.Xml.Xsl;

namespace SkinManager
{
    partial class Form1
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.components = new System.ComponentModel.Container();
            this.groupBox3 = new System.Windows.Forms.GroupBox();
            this.chServerlist = new System.Windows.Forms.CheckedListBox();
            this.label2 = new System.Windows.Forms.Label();
            this.directoryStructure = new System.Windows.Forms.TreeView();
            this.btnDownloadAllSkins = new System.Windows.Forms.Button();
            this.btnClearTemplates = new System.Windows.Forms.Button();
            this.chAutoClearTemplates = new System.Windows.Forms.CheckBox();
            this.chSelectAll = new System.Windows.Forms.CheckBox();
            this.btnTest = new System.Windows.Forms.Button();
            this.Cancel = new System.Windows.Forms.Button();
            this.btnDownloadSkin = new System.Windows.Forms.Button();
            this.btnUpload = new System.Windows.Forms.Button();
            this.richTextBox1 = new System.Windows.Forms.TextBox();
            this.buttonBrowse = new System.Windows.Forms.Button();
            this.PathToSkins = new System.Windows.Forms.TextBox();
            this.toolTip1 = new System.Windows.Forms.ToolTip(this.components);
            this.Connect = new System.Windows.Forms.Button();
            this.browseFileDialog = new System.Windows.Forms.OpenFileDialog();
            this.downloadFileDialog = new System.Windows.Forms.OpenFileDialog();
            this.folderBrowserDialog1 = new System.Windows.Forms.FolderBrowserDialog();
            this.label1 = new System.Windows.Forms.Label();
            this.groupBox1 = new System.Windows.Forms.GroupBox();
            this.groupBox3.SuspendLayout();
            this.groupBox1.SuspendLayout();
            this.SuspendLayout();
            // 
            // groupBox3
            // 
            this.groupBox3.Anchor = ((System.Windows.Forms.AnchorStyles)((((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom)
                        | System.Windows.Forms.AnchorStyles.Left)
                        | System.Windows.Forms.AnchorStyles.Right)));
            this.groupBox3.Controls.Add(this.chServerlist);
            this.groupBox3.Controls.Add(this.label2);
            this.groupBox3.Controls.Add(this.directoryStructure);
            this.groupBox3.Controls.Add(this.btnDownloadAllSkins);
            this.groupBox3.Controls.Add(this.btnClearTemplates);
            this.groupBox3.Controls.Add(this.chAutoClearTemplates);
            this.groupBox3.Controls.Add(this.chSelectAll);
            this.groupBox3.Controls.Add(this.btnTest);
            this.groupBox3.Controls.Add(this.Cancel);
            this.groupBox3.Controls.Add(this.btnDownloadSkin);
            this.groupBox3.Controls.Add(this.btnUpload);
            this.groupBox3.Controls.Add(this.richTextBox1);
            this.groupBox3.Controls.Add(this.buttonBrowse);
            this.groupBox3.Controls.Add(this.PathToSkins);
            this.groupBox3.Location = new System.Drawing.Point(12, 134);
            this.groupBox3.Name = "groupBox3";
            this.groupBox3.Size = new System.Drawing.Size(781, 572);
            this.groupBox3.TabIndex = 5;
            this.groupBox3.TabStop = false;
            // 
            // chServerlist
            // 
            this.chServerlist.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.chServerlist.FormattingEnabled = true;
            this.chServerlist.Location = new System.Drawing.Point(561, 19);
            this.chServerlist.Name = "chServerlist";
            this.chServerlist.Size = new System.Drawing.Size(214, 169);
            this.chServerlist.TabIndex = 2;
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Location = new System.Drawing.Point(143, 39);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(303, 13);
            this.label2.TabIndex = 13;
            this.label2.Text = "THIS SHOULD BE THE ROOT OF THE SKINS STRUCTURE";
            // 
            // directoryStructure
            // 
            this.directoryStructure.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left)
                        | System.Windows.Forms.AnchorStyles.Right)));
            this.directoryStructure.CheckBoxes = true;
            this.directoryStructure.Location = new System.Drawing.Point(8, 70);
            this.directoryStructure.MinimumSize = new System.Drawing.Size(547, 370);
            this.directoryStructure.Name = "directoryStructure";
            this.directoryStructure.Size = new System.Drawing.Size(547, 370);
            this.directoryStructure.TabIndex = 12;
            this.directoryStructure.AfterCheck += new System.Windows.Forms.TreeViewEventHandler(this.directoryStructure_AfterCheck);
            // 
            // btnDownloadAllSkins
            // 
            this.btnDownloadAllSkins.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.btnDownloadAllSkins.Enabled = false;
            this.btnDownloadAllSkins.FlatStyle = System.Windows.Forms.FlatStyle.System;
            this.btnDownloadAllSkins.Location = new System.Drawing.Point(629, 308);
            this.btnDownloadAllSkins.Name = "btnDownloadAllSkins";
            this.btnDownloadAllSkins.Size = new System.Drawing.Size(144, 23);
            this.btnDownloadAllSkins.TabIndex = 11;
            this.btnDownloadAllSkins.Text = "Download ALL From Server";
            this.toolTip1.SetToolTip(this.btnDownloadAllSkins, "Download all ");
            this.btnDownloadAllSkins.Click += new System.EventHandler(this.btnDownloadAllSkins_Click);
            // 
            // btnClearTemplates
            // 
            this.btnClearTemplates.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.btnClearTemplates.Enabled = false;
            this.btnClearTemplates.Location = new System.Drawing.Point(629, 372);
            this.btnClearTemplates.Name = "btnClearTemplates";
            this.btnClearTemplates.Size = new System.Drawing.Size(144, 23);
            this.btnClearTemplates.TabIndex = 10;
            this.btnClearTemplates.Text = "Clear Templates";
            this.btnClearTemplates.Click += new System.EventHandler(this.btClearTemplates_Click);
            // 
            // chAutoClearTemplates
            // 
            this.chAutoClearTemplates.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.chAutoClearTemplates.CheckAlign = System.Drawing.ContentAlignment.MiddleRight;
            this.chAutoClearTemplates.Location = new System.Drawing.Point(637, 204);
            this.chAutoClearTemplates.Name = "chAutoClearTemplates";
            this.chAutoClearTemplates.Size = new System.Drawing.Size(136, 24);
            this.chAutoClearTemplates.TabIndex = 9;
            this.chAutoClearTemplates.Text = "Auto Clear Templates";
            this.toolTip1.SetToolTip(this.chAutoClearTemplates, "After the files are uploaded, the templates are automatically cleared, for each s" +
                    "erver");
            this.chAutoClearTemplates.CheckedChanged += new System.EventHandler(this.chAutoClearTemplates_CheckedChanged);
            // 
            // chSelectAll
            // 
            this.chSelectAll.Location = new System.Drawing.Point(8, 46);
            this.chSelectAll.Name = "chSelectAll";
            this.chSelectAll.Size = new System.Drawing.Size(72, 22);
            this.chSelectAll.TabIndex = 8;
            this.chSelectAll.Text = "Select all";
            this.chSelectAll.CheckedChanged += new System.EventHandler(this.chSelectAll_CheckedChanged);
            // 
            // btnTest
            // 
            this.btnTest.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.btnTest.Enabled = false;
            this.btnTest.FlatStyle = System.Windows.Forms.FlatStyle.System;
            this.btnTest.ImageAlign = System.Drawing.ContentAlignment.MiddleRight;
            this.btnTest.Location = new System.Drawing.Point(629, 340);
            this.btnTest.Name = "btnTest";
            this.btnTest.Size = new System.Drawing.Size(144, 23);
            this.btnTest.TabIndex = 7;
            this.btnTest.Text = "Test XSL";
            this.toolTip1.SetToolTip(this.btnTest, "Use this button to test your local files before uploading them. This might rearra" +
                    "nge the order of files in the list for better uploading.");
            this.btnTest.Click += new System.EventHandler(this.btnTest_Click);
            // 
            // Cancel
            // 
            this.Cancel.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.Cancel.Enabled = false;
            this.Cancel.FlatStyle = System.Windows.Forms.FlatStyle.System;
            this.Cancel.Location = new System.Drawing.Point(693, 404);
            this.Cancel.Name = "Cancel";
            this.Cancel.Size = new System.Drawing.Size(80, 23);
            this.Cancel.TabIndex = 6;
            this.Cancel.Text = "Cancel";
            this.Cancel.Click += new System.EventHandler(this.Cancel_Click);
            // 
            // btnDownloadSkin
            // 
            this.btnDownloadSkin.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.btnDownloadSkin.Enabled = false;
            this.btnDownloadSkin.FlatStyle = System.Windows.Forms.FlatStyle.System;
            this.btnDownloadSkin.Location = new System.Drawing.Point(629, 276);
            this.btnDownloadSkin.Name = "btnDownloadSkin";
            this.btnDownloadSkin.Size = new System.Drawing.Size(144, 23);
            this.btnDownloadSkin.TabIndex = 5;
            this.btnDownloadSkin.Text = "Download From Server";
            this.toolTip1.SetToolTip(this.btnDownloadSkin, "Download the select site\'s skins");
            this.btnDownloadSkin.Click += new System.EventHandler(this.btnDownloadSkin_Click);
            // 
            // btnUpload
            // 
            this.btnUpload.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.btnUpload.Enabled = false;
            this.btnUpload.FlatStyle = System.Windows.Forms.FlatStyle.System;
            this.btnUpload.Location = new System.Drawing.Point(629, 244);
            this.btnUpload.Name = "btnUpload";
            this.btnUpload.Size = new System.Drawing.Size(144, 23);
            this.btnUpload.TabIndex = 4;
            this.btnUpload.Text = "Upload";
            this.toolTip1.SetToolTip(this.btnUpload, "Upload the selected files to the selected servers");
            this.btnUpload.Click += new System.EventHandler(this.btnUpload_Click);
            // 
            // richTextBox1
            // 
            this.richTextBox1.Anchor = ((System.Windows.Forms.AnchorStyles)((((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom)
                        | System.Windows.Forms.AnchorStyles.Left)
                        | System.Windows.Forms.AnchorStyles.Right)));
            this.richTextBox1.Location = new System.Drawing.Point(8, 446);
            this.richTextBox1.Multiline = true;
            this.richTextBox1.Name = "richTextBox1";
            this.richTextBox1.ScrollBars = System.Windows.Forms.ScrollBars.Vertical;
            this.richTextBox1.Size = new System.Drawing.Size(765, 114);
            this.richTextBox1.TabIndex = 2;
            this.richTextBox1.Text = "richTextBox1";
            // 
            // buttonBrowse
            // 
            this.buttonBrowse.FlatStyle = System.Windows.Forms.FlatStyle.System;
            this.buttonBrowse.Location = new System.Drawing.Point(480, 16);
            this.buttonBrowse.Name = "buttonBrowse";
            this.buttonBrowse.Size = new System.Drawing.Size(75, 23);
            this.buttonBrowse.TabIndex = 1;
            this.buttonBrowse.Text = "Browse";
            this.toolTip1.SetToolTip(this.buttonBrowse, "Browse to the directory containing the skins to be uploaded");
            this.buttonBrowse.Click += new System.EventHandler(this.buttonBrowse_Click);
            // 
            // PathToSkins
            // 
            this.PathToSkins.Enabled = false;
            this.PathToSkins.Location = new System.Drawing.Point(8, 16);
            this.PathToSkins.Name = "PathToSkins";
            this.PathToSkins.Size = new System.Drawing.Size(464, 20);
            this.PathToSkins.TabIndex = 0;
            this.PathToSkins.Text = "textBox1";
            this.toolTip1.SetToolTip(this.PathToSkins, "The path to the directory containing the skins to be uploaded");
            // 
            // Connect
            // 
            this.Connect.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Right)));
            this.Connect.FlatStyle = System.Windows.Forms.FlatStyle.System;
            this.Connect.Location = new System.Drawing.Point(696, 85);
            this.Connect.Name = "Connect";
            this.Connect.Size = new System.Drawing.Size(72, 24);
            this.Connect.TabIndex = 0;
            this.Connect.Text = "Connect";
            this.toolTip1.SetToolTip(this.Connect, "Connect to the server of your choice with your DNA login name and password");
            this.Connect.Click += new System.EventHandler(this.Connect_Click);
            // 
            // browseFileDialog
            // 
            this.browseFileDialog.CheckFileExists = false;
            this.browseFileDialog.CheckPathExists = false;
            this.browseFileDialog.FileName = "HTMLOutput.xsl";
            this.browseFileDialog.Filter = "Skin files|*.xsl;*.xml;*.css| All files | *.*";
            // 
            // downloadFileDialog
            // 
            this.downloadFileDialog.CheckFileExists = false;
            this.downloadFileDialog.CheckPathExists = false;
            this.downloadFileDialog.FileName = "HTMLOutput.xsl";
            this.downloadFileDialog.Filter = "Skin files|*.xsl;*.xml;*.css| All files | *.*";
            // 
            // folderBrowserDialog1
            // 
            this.folderBrowserDialog1.SelectedPath = "C:\\temp\\";
            // 
            // label1
            // 
            this.label1.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left)
                        | System.Windows.Forms.AnchorStyles.Right)));
            this.label1.Location = new System.Drawing.Point(16, 16);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(656, 95);
            this.label1.TabIndex = 1;
            this.label1.Text = "Click Connect to connect to a DNA server";
            // 
            // groupBox1
            // 
            this.groupBox1.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left)
                        | System.Windows.Forms.AnchorStyles.Right)));
            this.groupBox1.Controls.Add(this.label1);
            this.groupBox1.Controls.Add(this.Connect);
            this.groupBox1.Location = new System.Drawing.Point(12, 11);
            this.groupBox1.Name = "groupBox1";
            this.groupBox1.Size = new System.Drawing.Size(784, 117);
            this.groupBox1.TabIndex = 3;
            this.groupBox1.TabStop = false;
            // 
            // Form1
            // 
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Inherit;
            this.ClientSize = new System.Drawing.Size(808, 718);
            this.Controls.Add(this.groupBox3);
            this.Controls.Add(this.groupBox1);
            this.MinimumSize = new System.Drawing.Size(816, 752);
            this.Name = "Form1";
            this.Text = "DNA Skin Manager";
            this.Closing += new System.ComponentModel.CancelEventHandler(this.Form1_Closing);
            this.groupBox3.ResumeLayout(false);
            this.groupBox3.PerformLayout();
            this.groupBox1.ResumeLayout(false);
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.GroupBox groupBox3;
        private System.Windows.Forms.Button btnDownloadAllSkins;
        private System.Windows.Forms.ToolTip toolTip1;
        private System.Windows.Forms.Button btnClearTemplates;
        private System.Windows.Forms.CheckBox chAutoClearTemplates;
        private System.Windows.Forms.CheckBox chSelectAll;
        private System.Windows.Forms.Button btnTest;
        private System.Windows.Forms.Button Cancel;
        private System.Windows.Forms.Button btnDownloadSkin;
        private System.Windows.Forms.Button btnUpload;
        private System.Windows.Forms.TextBox richTextBox1;
        private System.Windows.Forms.Button buttonBrowse;
        private System.Windows.Forms.TextBox PathToSkins;
        private System.Windows.Forms.Button Connect;
        private System.Windows.Forms.OpenFileDialog browseFileDialog;
        private System.Windows.Forms.OpenFileDialog downloadFileDialog;
        private System.Windows.Forms.FolderBrowserDialog folderBrowserDialog1;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.GroupBox groupBox1;
        private System.Windows.Forms.TreeView directoryStructure;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.CheckedListBox chServerlist;
    }
}

