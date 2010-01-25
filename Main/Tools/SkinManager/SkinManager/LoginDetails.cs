using System;
using System.Drawing;
using System.Collections;
using System.ComponentModel;
using System.Windows.Forms;

namespace SkinManager
{
	/// <summary>
	/// Summary description for LoginDetails.
	/// </summary>
	public class LoginDetails : System.Windows.Forms.Form
	{
		private System.Windows.Forms.Label label1;
		private System.Windows.Forms.TextBox tbProxy;
		private System.Windows.Forms.TextBox tbPort;
		private System.Windows.Forms.TextBox tbLoginName;
		private System.Windows.Forms.TextBox tbPassword;
		private System.Windows.Forms.TextBox tbEdPassword;
		private System.Windows.Forms.TextBox tbSitename;
		private System.Windows.Forms.Label label2;
		private System.Windows.Forms.Label label3;
		private System.Windows.Forms.Label label4;
		private System.Windows.Forms.Label label5;
		private System.Windows.Forms.Label label6;
		private System.Windows.Forms.Label label7;
		private System.Windows.Forms.Button btnConnect;
		private System.Windows.Forms.Button btnCancel;
		private System.Windows.Forms.CheckBox chUseProxy;
		private System.Windows.Forms.Label label8;
		private System.Windows.Forms.Label label9;
		private System.Windows.Forms.TextBox tbLoginHost;
		private System.Windows.Forms.CheckBox chLocalDebug;
		private System.Windows.Forms.ToolTip toolTip1;
		private System.Windows.Forms.ComboBox cbHostName;
        private System.Windows.Forms.CheckBox chkiDLogin;
		private System.ComponentModel.IContainer components;

		public LoginDetails()
		{
			//
			// Required for Windows Form Designer support
			//
			InitializeComponent();

			//
			// TODO: Add any constructor code after InitializeComponent call
			//
		}

		public string Hostname
		{
			get
			{
				return cbHostName.Text;
			}
			set
			{
				cbHostName.Text = value;
			}
		}

		public string Proxy
		{
			get
			{
				return tbProxy.Text;
			}
			set
			{
				tbProxy.Text = value;
			}
		}

		public string Port
		{
			get
			{
				return tbPort.Text;
			}
			set
			{
				tbPort.Text = value;
			}
		}

		public string LoginName
		{
			get
			{
				return tbLoginName.Text;
			}
			set
			{
				tbLoginName.Text = value;
			}
		}

		public string Password
		{
			get
			{
				return tbPassword.Text;
			}
			set
			{
				tbPassword.Text = value;
			}
		}

		public string EditorPassword
		{
			get
			{
				return tbEdPassword.Text;
			}
			set
			{
				tbEdPassword.Text = value;
			}
		}

		public string Sitename
		{
			get
			{
				return tbSitename.Text;
			}
			set
			{
				tbSitename.Text = value;
			}
		}
		public bool UseProxy
		{
			get
			{
				return chUseProxy.CheckState == CheckState.Checked;
			}
			set
			{
				if(value)
				{
					chUseProxy.CheckState = CheckState.Checked;
				}
				else
				{
					chUseProxy.CheckState = CheckState.Unchecked;
				}
				tbProxy.Enabled = value;
				tbPort.Enabled = value;
			}
		}
		public bool LocalDebug
		{
			get
			{
				return chLocalDebug.CheckState == CheckState.Checked;
			}
			set
			{
				if(value)
				{
					chLocalDebug.CheckState = CheckState.Checked;
				}
				else
				{
					chLocalDebug.CheckState = CheckState.Unchecked;
				}
			}
		}
        public bool iDLogin
        {
            get
            {
                return chkiDLogin.CheckState == CheckState.Checked;
            }
            set
            {
                if (value)
                {
                    chkiDLogin.CheckState = CheckState.Checked;
                }
                else
                {
                    chkiDLogin.CheckState = CheckState.Unchecked;
                }
            }
        }
        public string LoginHost
		{
			get
			{
				return tbLoginHost.Text;
			}
			set
			{
				tbLoginHost.Text = value;
			}
		}

		/// <summary>
		/// Clean up any resources being used.
		/// </summary>
		protected override void Dispose( bool disposing )
		{
			if( disposing )
			{
				if(components != null)
				{
					components.Dispose();
				}
			}
			base.Dispose( disposing );
		}

		#region Windows Form Designer generated code
		/// <summary>
		/// Required method for Designer support - do not modify
		/// the contents of this method with the code editor.
		/// </summary>
		private void InitializeComponent()
		{
            this.components = new System.ComponentModel.Container();
            this.label1 = new System.Windows.Forms.Label();
            this.tbProxy = new System.Windows.Forms.TextBox();
            this.tbPort = new System.Windows.Forms.TextBox();
            this.tbLoginName = new System.Windows.Forms.TextBox();
            this.tbPassword = new System.Windows.Forms.TextBox();
            this.tbEdPassword = new System.Windows.Forms.TextBox();
            this.tbSitename = new System.Windows.Forms.TextBox();
            this.label2 = new System.Windows.Forms.Label();
            this.label3 = new System.Windows.Forms.Label();
            this.label4 = new System.Windows.Forms.Label();
            this.label5 = new System.Windows.Forms.Label();
            this.label6 = new System.Windows.Forms.Label();
            this.label7 = new System.Windows.Forms.Label();
            this.btnConnect = new System.Windows.Forms.Button();
            this.btnCancel = new System.Windows.Forms.Button();
            this.chUseProxy = new System.Windows.Forms.CheckBox();
            this.label8 = new System.Windows.Forms.Label();
            this.label9 = new System.Windows.Forms.Label();
            this.tbLoginHost = new System.Windows.Forms.TextBox();
            this.chLocalDebug = new System.Windows.Forms.CheckBox();
            this.toolTip1 = new System.Windows.Forms.ToolTip(this.components);
            this.chkiDLogin = new System.Windows.Forms.CheckBox();
            this.cbHostName = new System.Windows.Forms.ComboBox();
            this.SuspendLayout();
            // 
            // label1
            // 
            this.label1.Location = new System.Drawing.Point(8, 8);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(100, 16);
            this.label1.TabIndex = 0;
            this.label1.Text = "hostName";
            this.label1.TextAlign = System.Drawing.ContentAlignment.TopRight;
            // 
            // tbProxy
            // 
            this.tbProxy.Location = new System.Drawing.Point(184, 32);
            this.tbProxy.Name = "tbProxy";
            this.tbProxy.Size = new System.Drawing.Size(168, 20);
            this.tbProxy.TabIndex = 3;
            this.toolTip1.SetToolTip(this.tbProxy, "Domain name of the proxy server");
            // 
            // tbPort
            // 
            this.tbPort.Location = new System.Drawing.Point(184, 56);
            this.tbPort.Name = "tbPort";
            this.tbPort.Size = new System.Drawing.Size(32, 20);
            this.tbPort.TabIndex = 4;
            this.toolTip1.SetToolTip(this.tbPort, "Port to use for the proxy server");
            // 
            // tbLoginName
            // 
            this.tbLoginName.Location = new System.Drawing.Point(120, 80);
            this.tbLoginName.Name = "tbLoginName";
            this.tbLoginName.Size = new System.Drawing.Size(288, 20);
            this.tbLoginName.TabIndex = 10;
            this.toolTip1.SetToolTip(this.tbLoginName, "Your DNA (SSO) login name");
            // 
            // tbPassword
            // 
            this.tbPassword.Location = new System.Drawing.Point(120, 104);
            this.tbPassword.Name = "tbPassword";
            this.tbPassword.PasswordChar = '*';
            this.tbPassword.Size = new System.Drawing.Size(288, 20);
            this.tbPassword.TabIndex = 11;
            this.toolTip1.SetToolTip(this.tbPassword, "Your DNA (SSO) password");
            // 
            // tbEdPassword
            // 
            this.tbEdPassword.Location = new System.Drawing.Point(120, 128);
            this.tbEdPassword.Name = "tbEdPassword";
            this.tbEdPassword.PasswordChar = '*';
            this.tbEdPassword.Size = new System.Drawing.Size(288, 20);
            this.tbEdPassword.TabIndex = 12;
            this.toolTip1.SetToolTip(this.tbEdPassword, "Password of the \'editor\' account on your target server");
            // 
            // tbSitename
            // 
            this.tbSitename.Location = new System.Drawing.Point(120, 152);
            this.tbSitename.Name = "tbSitename";
            this.tbSitename.Size = new System.Drawing.Size(288, 20);
            this.tbSitename.TabIndex = 13;
            this.toolTip1.SetToolTip(this.tbSitename, "Name of the DNA site to upload to");
            // 
            // label2
            // 
            this.label2.Location = new System.Drawing.Point(8, 32);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(100, 16);
            this.label2.TabIndex = 14;
            this.label2.Text = "Use Proxy";
            this.label2.TextAlign = System.Drawing.ContentAlignment.TopRight;
            // 
            // label3
            // 
            this.label3.Location = new System.Drawing.Point(8, 56);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(100, 16);
            this.label3.TabIndex = 15;
            this.label3.Text = "Port";
            this.label3.TextAlign = System.Drawing.ContentAlignment.TopRight;
            // 
            // label4
            // 
            this.label4.Location = new System.Drawing.Point(8, 80);
            this.label4.Name = "label4";
            this.label4.Size = new System.Drawing.Size(100, 16);
            this.label4.TabIndex = 16;
            this.label4.Text = "DNA Login Name";
            this.label4.TextAlign = System.Drawing.ContentAlignment.TopRight;
            // 
            // label5
            // 
            this.label5.Location = new System.Drawing.Point(8, 104);
            this.label5.Name = "label5";
            this.label5.Size = new System.Drawing.Size(100, 16);
            this.label5.TabIndex = 17;
            this.label5.Text = "DNA Password";
            this.label5.TextAlign = System.Drawing.ContentAlignment.TopRight;
            // 
            // label6
            // 
            this.label6.Location = new System.Drawing.Point(8, 128);
            this.label6.Name = "label6";
            this.label6.Size = new System.Drawing.Size(100, 16);
            this.label6.TabIndex = 18;
            this.label6.Text = "Editor password";
            this.label6.TextAlign = System.Drawing.ContentAlignment.TopRight;
            // 
            // label7
            // 
            this.label7.Location = new System.Drawing.Point(8, 152);
            this.label7.Name = "label7";
            this.label7.Size = new System.Drawing.Size(100, 16);
            this.label7.TabIndex = 19;
            this.label7.Text = "DNA Sitename";
            this.label7.TextAlign = System.Drawing.ContentAlignment.TopRight;
            // 
            // btnConnect
            // 
            this.btnConnect.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Right)));
            this.btnConnect.DialogResult = System.Windows.Forms.DialogResult.OK;
            this.btnConnect.FlatStyle = System.Windows.Forms.FlatStyle.System;
            this.btnConnect.Location = new System.Drawing.Point(328, 286);
            this.btnConnect.Name = "btnConnect";
            this.btnConnect.Size = new System.Drawing.Size(75, 23);
            this.btnConnect.TabIndex = 31;
            this.btnConnect.Text = "Connect";
            this.toolTip1.SetToolTip(this.btnConnect, "Connect using the supplied settings");
            this.btnConnect.Click += new System.EventHandler(this.btnConnect_Click);
            // 
            // btnCancel
            // 
            this.btnCancel.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Right)));
            this.btnCancel.DialogResult = System.Windows.Forms.DialogResult.Cancel;
            this.btnCancel.FlatStyle = System.Windows.Forms.FlatStyle.System;
            this.btnCancel.Location = new System.Drawing.Point(232, 286);
            this.btnCancel.Name = "btnCancel";
            this.btnCancel.Size = new System.Drawing.Size(75, 23);
            this.btnCancel.TabIndex = 30;
            this.btnCancel.Text = "Cancel";
            // 
            // chUseProxy
            // 
            this.chUseProxy.FlatStyle = System.Windows.Forms.FlatStyle.System;
            this.chUseProxy.Location = new System.Drawing.Point(120, 32);
            this.chUseProxy.Name = "chUseProxy";
            this.chUseProxy.Size = new System.Drawing.Size(16, 16);
            this.chUseProxy.TabIndex = 2;
            this.toolTip1.SetToolTip(this.chUseProxy, "Select to use a proxy server");
            this.chUseProxy.CheckStateChanged += new System.EventHandler(this.chUseProxy_CheckStateChanged);
            // 
            // label8
            // 
            this.label8.Location = new System.Drawing.Point(136, 32);
            this.label8.Name = "label8";
            this.label8.Size = new System.Drawing.Size(40, 16);
            this.label8.TabIndex = 23;
            this.label8.Text = "Proxy";
            this.label8.TextAlign = System.Drawing.ContentAlignment.TopRight;
            // 
            // label9
            // 
            this.label9.Location = new System.Drawing.Point(8, 176);
            this.label9.Name = "label9";
            this.label9.Size = new System.Drawing.Size(100, 16);
            this.label9.TabIndex = 25;
            this.label9.Text = "Login host";
            this.label9.TextAlign = System.Drawing.ContentAlignment.TopRight;
            // 
            // tbLoginHost
            // 
            this.tbLoginHost.Location = new System.Drawing.Point(120, 176);
            this.tbLoginHost.Name = "tbLoginHost";
            this.tbLoginHost.Size = new System.Drawing.Size(288, 20);
            this.tbLoginHost.TabIndex = 24;
            this.toolTip1.SetToolTip(this.tbLoginHost, "domain name of the login server (if different from hostName)");
            // 
            // chLocalDebug
            // 
            this.chLocalDebug.CheckAlign = System.Drawing.ContentAlignment.MiddleRight;
            this.chLocalDebug.Location = new System.Drawing.Point(32, 200);
            this.chLocalDebug.Name = "chLocalDebug";
            this.chLocalDebug.Size = new System.Drawing.Size(104, 24);
            this.chLocalDebug.TabIndex = 26;
            this.chLocalDebug.Text = "LocalDebug";
            this.chLocalDebug.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
            this.toolTip1.SetToolTip(this.chLocalDebug, "Bypasses SSO for a debug build (for local testing)");
            // 
            // chkiDLogin
            // 
            this.chkiDLogin.CheckAlign = System.Drawing.ContentAlignment.MiddleRight;
            this.chkiDLogin.Location = new System.Drawing.Point(32, 230);
            this.chkiDLogin.Name = "chkiDLogin";
            this.chkiDLogin.Size = new System.Drawing.Size(104, 24);
            this.chkiDLogin.TabIndex = 33;
            this.chkiDLogin.Text = "Login via iD";
            this.chkiDLogin.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
            this.toolTip1.SetToolTip(this.chkiDLogin, "Uses iD services to login");
            // 
            // cbHostName
            // 
            this.cbHostName.Items.AddRange(new object[] {
            "www.bbc.co.uk",
            "dna-staging.bbc.co.uk",
            "dna-extdev.bbc.co.uk",
            "127.0.0.1"});
            this.cbHostName.Location = new System.Drawing.Point(120, 8);
            this.cbHostName.Name = "cbHostName";
            this.cbHostName.Size = new System.Drawing.Size(288, 21);
            this.cbHostName.TabIndex = 32;
            this.cbHostName.Text = "dna-extdev.bbc.co.uk";
            this.cbHostName.SelectedIndexChanged += new System.EventHandler(this.cbHostName_SelectedIndexChanged);
            // 
            // LoginDetails
            // 
            this.AcceptButton = this.btnConnect;
            this.AutoScaleBaseSize = new System.Drawing.Size(5, 13);
            this.ClientSize = new System.Drawing.Size(424, 320);
            this.Controls.Add(this.chkiDLogin);
            this.Controls.Add(this.cbHostName);
            this.Controls.Add(this.chLocalDebug);
            this.Controls.Add(this.label9);
            this.Controls.Add(this.tbLoginHost);
            this.Controls.Add(this.label8);
            this.Controls.Add(this.chUseProxy);
            this.Controls.Add(this.btnCancel);
            this.Controls.Add(this.btnConnect);
            this.Controls.Add(this.label7);
            this.Controls.Add(this.label6);
            this.Controls.Add(this.label5);
            this.Controls.Add(this.label4);
            this.Controls.Add(this.label3);
            this.Controls.Add(this.label2);
            this.Controls.Add(this.tbSitename);
            this.Controls.Add(this.tbEdPassword);
            this.Controls.Add(this.tbPassword);
            this.Controls.Add(this.tbLoginName);
            this.Controls.Add(this.tbPort);
            this.Controls.Add(this.tbProxy);
            this.Controls.Add(this.label1);
            this.Name = "LoginDetails";
            this.Text = "Connect to Server";
            this.ResumeLayout(false);
            this.PerformLayout();

		}
		#endregion

		private void chUseProxy_CheckStateChanged(object sender, System.EventArgs e)
		{
			tbProxy.Enabled = UseProxy;
			tbPort.Enabled = UseProxy;
		}

		private void btnConnect_Click(object sender, System.EventArgs e)
		{
		
		}

		private void cbHostName_SelectedIndexChanged(object sender, System.EventArgs e)
		{
		
		}
	}
}
