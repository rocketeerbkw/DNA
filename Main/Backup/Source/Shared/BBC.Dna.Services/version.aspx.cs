using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.IO;
using System.Diagnostics;

namespace BBC.Dna.Services
{
    public class version : System.Web.UI.Page
    {
        protected Table tblFiles;
        protected void Page_Load(object sender, EventArgs e)
        {
            DirectoryInfo binDir = new DirectoryInfo(Request.PhysicalApplicationPath + "\\bin");
            FileInfo[] files = binDir.GetFiles();


            TableRow row = new TableRow();
            row.Cells.Add(new TableCell() { Text = "Name",HorizontalAlign= HorizontalAlign.Center });//add name
            row.Cells.Add(new TableCell() { Text = "Version", HorizontalAlign = HorizontalAlign.Center });//add version
            row.Cells.Add(new TableCell() { Text = "Creation", HorizontalAlign = HorizontalAlign.Center });//add creation date
            row.Cells.Add(new TableCell() { Text = "Size", HorizontalAlign = HorizontalAlign.Center });//add size
            tblFiles.Rows.Add(row);

            bool altRow = true;
            foreach (FileInfo file in files)
            {
                row = new TableRow();
                if (altRow)
                {
                    row.CssClass = "altrow";
                }
                altRow = !altRow;

                FileVersionInfo myFI = FileVersionInfo.GetVersionInfo(file.FullName);
                row.Cells.Add(new TableCell() { Text = file.Name });//add name
                row.Cells.Add(new TableCell() { Text = myFI.FileVersion });//add version
                row.Cells.Add(new TableCell() { Text = file.CreationTime.ToString() });//add creation date
                row.Cells.Add(new TableCell() { Text = file.Length.ToString() });//add size
                tblFiles.Rows.Add(row);


            }
            

            
        }
    }
}
