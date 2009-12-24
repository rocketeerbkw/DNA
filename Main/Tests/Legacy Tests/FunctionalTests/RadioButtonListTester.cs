#region Copyright (c) 2006, Jonathan Clarke granted to Brian Knowles and Jim Shore
/********************************************************************************************************************
'
' Copyright (c) 2006, Jonathan Clarke granted to Brian Knowles and Jim Shore
'
' Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated 
' documentation files (the "Software"), to deal in the Software without restriction, including without limitation 
' the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and
' to permit persons to whom the Software is furnished to do so, subject to the following conditions:
'
' The above copyright notice and this permission notice shall be included in all copies or substantial portions 
' of the Software.
'
' THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO
' THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
' AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF
' CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
' DEALINGS IN THE SOFTWARE.
'
'*******************************************************************************************************************/
#endregion

using System;
using System.Xml;
using NUnit.Extensions.Asp.HtmlTester;

namespace NUnit.Extensions.Asp.AspTester
{
	/// <summary>
    /// Tester for System.Web.UI.WebControls.RadioButtonList
	/// </summary>
    public class RadioButtonListTester : AspControlTester
    {
        /// <summary>
        /// Default constructor for the RadioButtonListTester
        /// </summary>
        /// <param name="aspId"></param>
        public RadioButtonListTester(string aspId) : base(aspId)
		{
		}

        /// <summary>
        /// Constructor with container
        /// </summary>
        /// <param name="aspId"></param>
        /// <param name="container"></param>
        public RadioButtonListTester(string aspId, Tester container) : base(aspId, container)
		{
		}

        /// <summary>
        /// Public Accessor for the Count
        /// </summary>
        public int Count
        {
            get
            {
                int cnt, idx; string txt;
                ReadThroughItems(out cnt, out idx, out txt, "");
                return cnt;
            }
        }

        /// <summary>
        /// Accessor for the SelectedIndex
        /// </summary>
        public int SelectedIndex
        {
            get
            {
                int cnt, idx; string txt;
                ReadThroughItems(out cnt, out idx, out txt, "" );
                return idx;
            }
            set
            {
                int cnt, idx; string txt;
                ReadThroughItems(out cnt, out idx, out txt, "IDX=" + value );
            }
        }

        /// <summary>
        /// Accessor for the Text
        /// </summary>
        public string Text
        {
            get
            {
                int cnt, idx;   string txt;
                ReadThroughItems(out cnt, out idx, out txt, "");
                return txt;
            }
            set
            {
                int cnt, idx; string txt;
                ReadThroughItems(out cnt, out idx, out txt, "TXT=" + value);
            }
        }
        private const char LIST_SEPARATOR = '|';

        /// <summary>
        /// Accessor for the List
        /// </summary>
        public string[] List
        {
            get
            {
                int cnt, idx; string txt;
                ReadThroughItems(out cnt, out idx, out txt, "LIST");
                return txt.Split(LIST_SEPARATOR);
            }
        }

        private void ReadThroughItems(out int cnt, out int idx, out string txt, string op )
        {
            cnt = 0;
            idx = -1;
            txt = "";
            string listofvalues = "";
            int j = 0;
            string  optext = "";
            int opidx = -1;
            if (op != "")
            {
                int pos = op.IndexOf('=');
                if (pos > 0)
                {
                    optext = op.Substring(pos + 1);
                    op = op.Substring(0, pos );
                    if (op == "IDX" && int.TryParse(optext, out opidx) == true)
                        optext = "";
                }
                // Console.WriteLine("op:" + op + ":opidx:" + opidx + ":optext:" + optext + ":");
            }
            HtmlTagTester tbl = this.Tag;
            HtmlTagTester[] rows = tbl.Children("tr");
            foreach (HtmlTagTester row in rows)
            {
                HtmlTagTester[] cells = row.Children("td");
                foreach (HtmlTagTester cell in cells)
                {
                    HtmlTagTester[] inputs = cell.Children("input");
                    foreach (HtmlTagTester input in inputs)
                    {
                        if( (op == "IDX" && j == opidx) || (op == "TXT" && input.Attribute("value") == optext ) )
                        {
                            string varname = input.Attribute("name");
                            // Console.WriteLine("Form.Variables.ReplaceAll:Idx:" + varname + ":" + input.Attribute("value"));
                            Form.Variables.ReplaceAll(varname, input.Attribute("value"));
                            Form.OptionalPostBack(input.OptionalAttribute("onclick"));
                            return;
                        }
                        //if (op == "TXT" && input.Attribute("value") == optext )
                        //{
                        //    string varname = input.Attribute("name");
                        //    // Console.WriteLine("Form.Variables.ReplaceAll:Txt:" + varname + ":" + input.Attribute("value"));
                        //    Form.Variables.ReplaceAll(varname, input.Attribute("value"));
                        //    return;
                        //}
                        if (op == "LIST")
                        {
                            if (j > 0)
                                listofvalues += LIST_SEPARATOR;
                            listofvalues += input.Attribute("value");
                        }
                        if (input.HasAttribute("checked"))
                        {
                            idx = j;
                            if (input.HasAttribute("value"))
                                txt = input.Attribute("value");
                        }
                        j++;
                    }
                }
            }
            cnt = j;
            if (op == "LIST")
                txt = listofvalues;
        }
	}
}
