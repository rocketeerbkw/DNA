namespace SkinsChecker
{
    partial class SkinCheckerForm
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
            this.tbSkinFilePath = new System.Windows.Forms.TextBox();
            this.tbXMLFilePath = new System.Windows.Forms.TextBox();
            this.tbXMLInput = new System.Windows.Forms.TextBox();
            this.tbResults = new System.Windows.Forms.TextBox();
            this.logToFile = new System.Windows.Forms.CheckBox();
            this.label1 = new System.Windows.Forms.Label();
            this.label2 = new System.Windows.Forms.Label();
            this.useXMLFile = new System.Windows.Forms.RadioButton();
            this.useSuppliedXML = new System.Windows.Forms.RadioButton();
            this.label3 = new System.Windows.Forms.Label();
            this.RunTests = new System.Windows.Forms.Button();
            this.browseSkinFile = new System.Windows.Forms.Button();
            this.browseXMLFile = new System.Windows.Forms.Button();
            this.openSkinFile = new System.Windows.Forms.OpenFileDialog();
            this.openXMLFile = new System.Windows.Forms.OpenFileDialog();
            this.createAutoRun = new System.Windows.Forms.Button();
            this.saveBatFileDlg = new System.Windows.Forms.SaveFileDialog();
            this.cbRecursiveScan = new System.Windows.Forms.CheckBox();
            this.cbErrorOnly = new System.Windows.Forms.CheckBox();
            this.cbXslt2 = new System.Windows.Forms.CheckBox();
            this.SuspendLayout();
            // 
            // tbSkinFilePath
            // 
            this.tbSkinFilePath.Location = new System.Drawing.Point(104, 10);
            this.tbSkinFilePath.Name = "tbSkinFilePath";
            this.tbSkinFilePath.Size = new System.Drawing.Size(319, 20);
            this.tbSkinFilePath.TabIndex = 0;
            // 
            // tbXMLFilePath
            // 
            this.tbXMLFilePath.Location = new System.Drawing.Point(104, 37);
            this.tbXMLFilePath.Name = "tbXMLFilePath";
            this.tbXMLFilePath.Size = new System.Drawing.Size(428, 20);
            this.tbXMLFilePath.TabIndex = 1;
            // 
            // tbXMLInput
            // 
            this.tbXMLInput.Location = new System.Drawing.Point(104, 63);
            this.tbXMLInput.MaxLength = 100000;
            this.tbXMLInput.Multiline = true;
            this.tbXMLInput.Name = "tbXMLInput";
            this.tbXMLInput.ScrollBars = System.Windows.Forms.ScrollBars.Both;
            this.tbXMLInput.Size = new System.Drawing.Size(458, 280);
            this.tbXMLInput.TabIndex = 2;
            this.tbXMLInput.WordWrap = false;
            // 
            // tbResults
            // 
            this.tbResults.Location = new System.Drawing.Point(104, 350);
            this.tbResults.Multiline = true;
            this.tbResults.Name = "tbResults";
            this.tbResults.ReadOnly = true;
            this.tbResults.ScrollBars = System.Windows.Forms.ScrollBars.Vertical;
            this.tbResults.Size = new System.Drawing.Size(458, 182);
            this.tbResults.TabIndex = 3;
            // 
            // logToFile
            // 
            this.logToFile.AutoSize = true;
            this.logToFile.Location = new System.Drawing.Point(104, 541);
            this.logToFile.Name = "logToFile";
            this.logToFile.Size = new System.Drawing.Size(72, 17);
            this.logToFile.TabIndex = 4;
            this.logToFile.Text = "Log to file";
            this.logToFile.UseVisualStyleBackColor = true;
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(9, 13);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(68, 13);
            this.label1.TabIndex = 5;
            this.label1.Text = "Skin Test file";
            // 
            // label2
            // 
            this.label2.Location = new System.Drawing.Point(-2, 40);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(80, 13);
            this.label2.TabIndex = 6;
            this.label2.Text = "Test Xml or Url";
            this.label2.TextAlign = System.Drawing.ContentAlignment.TopCenter;
            // 
            // useXMLFile
            // 
            this.useXMLFile.AutoSize = true;
            this.useXMLFile.Checked = true;
            this.useXMLFile.Location = new System.Drawing.Point(84, 40);
            this.useXMLFile.Name = "useXMLFile";
            this.useXMLFile.Size = new System.Drawing.Size(14, 13);
            this.useXMLFile.TabIndex = 7;
            this.useXMLFile.TabStop = true;
            this.useXMLFile.UseVisualStyleBackColor = true;
            // 
            // useSuppliedXML
            // 
            this.useSuppliedXML.AutoSize = true;
            this.useSuppliedXML.Location = new System.Drawing.Point(84, 66);
            this.useSuppliedXML.Name = "useSuppliedXML";
            this.useSuppliedXML.Size = new System.Drawing.Size(14, 13);
            this.useSuppliedXML.TabIndex = 8;
            this.useSuppliedXML.UseVisualStyleBackColor = true;
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.Location = new System.Drawing.Point(56, 350);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(42, 13);
            this.label3.TabIndex = 9;
            this.label3.Text = "Results";
            // 
            // RunTests
            // 
            this.RunTests.Location = new System.Drawing.Point(487, 538);
            this.RunTests.Name = "RunTests";
            this.RunTests.Size = new System.Drawing.Size(75, 23);
            this.RunTests.TabIndex = 10;
            this.RunTests.Text = "Run Tests";
            this.RunTests.UseVisualStyleBackColor = true;
            this.RunTests.Click += new System.EventHandler(this.RunTests_Click);
            // 
            // browseSkinFile
            // 
            this.browseSkinFile.Location = new System.Drawing.Point(429, 8);
            this.browseSkinFile.Name = "browseSkinFile";
            this.browseSkinFile.Size = new System.Drawing.Size(24, 23);
            this.browseSkinFile.TabIndex = 11;
            this.browseSkinFile.Text = "...";
            this.browseSkinFile.UseVisualStyleBackColor = true;
            this.browseSkinFile.Click += new System.EventHandler(this.browseSkinFile_Click);
            // 
            // browseXMLFile
            // 
            this.browseXMLFile.Location = new System.Drawing.Point(538, 35);
            this.browseXMLFile.Name = "browseXMLFile";
            this.browseXMLFile.Size = new System.Drawing.Size(24, 23);
            this.browseXMLFile.TabIndex = 12;
            this.browseXMLFile.Text = "...";
            this.browseXMLFile.UseVisualStyleBackColor = true;
            this.browseXMLFile.Click += new System.EventHandler(this.browseXMLFile_Click);
            // 
            // openSkinFile
            // 
            this.openSkinFile.CheckFileExists = false;
            this.openSkinFile.FileName = "output.xsl";
            this.openSkinFile.Filter = "Xslt(*.xsl), Test List(*.txs) | *.xsl; *.txs";
            // 
            // openXMLFile
            // 
            this.openXMLFile.Filter = "XML(*.xml), Test List(*.txm)| *.xml; *.txm";
            // 
            // createAutoRun
            // 
            this.createAutoRun.Location = new System.Drawing.Point(325, 538);
            this.createAutoRun.Name = "createAutoRun";
            this.createAutoRun.Size = new System.Drawing.Size(147, 23);
            this.createAutoRun.TabIndex = 13;
            this.createAutoRun.Text = "Create AutoRun *.BAT file";
            this.createAutoRun.UseVisualStyleBackColor = true;
            this.createAutoRun.Click += new System.EventHandler(this.button1_Click);
            // 
            // saveBatFileDlg
            // 
            this.saveBatFileDlg.DefaultExt = "bat";
            this.saveBatFileDlg.Filter = "*.bat | *.bat";
            this.saveBatFileDlg.Title = "Specify filename";
            // 
            // cbRecursiveScan
            // 
            this.cbRecursiveScan.AutoSize = true;
            this.cbRecursiveScan.Location = new System.Drawing.Point(466, 12);
            this.cbRecursiveScan.Name = "cbRecursiveScan";
            this.cbRecursiveScan.Size = new System.Drawing.Size(100, 17);
            this.cbRecursiveScan.TabIndex = 14;
            this.cbRecursiveScan.Text = "Recursive scan";
            this.cbRecursiveScan.UseVisualStyleBackColor = true;
            // 
            // cbErrorOnly
            // 
            this.cbErrorOnly.AutoSize = true;
            this.cbErrorOnly.Location = new System.Drawing.Point(182, 541);
            this.cbErrorOnly.Name = "cbErrorOnly";
            this.cbErrorOnly.Size = new System.Drawing.Size(75, 17);
            this.cbErrorOnly.TabIndex = 15;
            this.cbErrorOnly.Text = "Errors only";
            this.cbErrorOnly.UseVisualStyleBackColor = true;
            // 
            // cbXslt2
            // 
            this.cbXslt2.AutoSize = true;
            this.cbXslt2.Location = new System.Drawing.Point(258, 541);
            this.cbXslt2.Name = "cbXslt2";
            this.cbXslt2.Size = new System.Drawing.Size(61, 17);
            this.cbXslt2.TabIndex = 16;
            this.cbXslt2.Text = "Xslt 2.0";
            this.cbXslt2.UseVisualStyleBackColor = true;
            // 
            // SkinCheckerForm
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(575, 567);
            this.Controls.Add(this.cbXslt2);
            this.Controls.Add(this.cbErrorOnly);
            this.Controls.Add(this.cbRecursiveScan);
            this.Controls.Add(this.createAutoRun);
            this.Controls.Add(this.browseXMLFile);
            this.Controls.Add(this.browseSkinFile);
            this.Controls.Add(this.RunTests);
            this.Controls.Add(this.label3);
            this.Controls.Add(this.useSuppliedXML);
            this.Controls.Add(this.useXMLFile);
            this.Controls.Add(this.label2);
            this.Controls.Add(this.label1);
            this.Controls.Add(this.logToFile);
            this.Controls.Add(this.tbResults);
            this.Controls.Add(this.tbXMLInput);
            this.Controls.Add(this.tbXMLFilePath);
            this.Controls.Add(this.tbSkinFilePath);
            this.Name = "SkinCheckerForm";
            this.Text = "Skin Checker";
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.TextBox tbSkinFilePath;
        private System.Windows.Forms.TextBox tbXMLFilePath;
        private System.Windows.Forms.TextBox tbXMLInput;
        private System.Windows.Forms.TextBox tbResults;
        private System.Windows.Forms.CheckBox logToFile;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.RadioButton useXMLFile;
        private System.Windows.Forms.RadioButton useSuppliedXML;
        private System.Windows.Forms.Label label3;
        private System.Windows.Forms.Button RunTests;
        private System.Windows.Forms.Button browseSkinFile;
        private System.Windows.Forms.Button browseXMLFile;
        private System.Windows.Forms.OpenFileDialog openSkinFile;
        private System.Windows.Forms.OpenFileDialog openXMLFile;
        private System.Windows.Forms.Button createAutoRun;
        private System.Windows.Forms.SaveFileDialog saveBatFileDlg;
        private System.Windows.Forms.CheckBox cbRecursiveScan;
        private System.Windows.Forms.CheckBox cbErrorOnly;
        private System.Windows.Forms.CheckBox cbXslt2;
    }
}

