using System;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using System.Diagnostics;
using BBC.Dna;
using BBC.Dna.Component;

namespace BBC.Dna
{
	internal class ParameterTracker : DnaComponent
	{
		XmlNode _subroot;

		public ParameterTracker(IInputContext context)
		{
			_subroot = AddElementTag(RootElement, "TRACKEDPARAMETERS");
		}

		/// <summary>
		/// Track an access of a named parameter
		/// </summary>
		/// <param name="paramname">Name of the parameter being accessed</param>
		/// <param name="description">Description of the parameter</param>
		public void TrackParam(string paramname, string description)
		{
#if DEBUG
			StackTrace st = new StackTrace(true);
			StackFrame parent = st.GetFrame(1);
			string callingMethod = parent.GetMethod().Name;
			string gpMethod = st.GetFrame(2).GetMethod().Name;
			string gpType = st.GetFrame(2).GetMethod().ReflectedType.Name.ToString();
			if (!(gpMethod == "DoesParamExist" || gpMethod == "TryGetParamString" || gpMethod == "GetParamIntOrZero" || gpMethod == "GetParamStringOrEmpty" || gpMethod == "GetParamCount"))
			{
				XmlNode param = AddElementTag(_subroot, "PARAMETER");
				AddAttribute(param, "NAME", paramname);
				AddAttribute(param, "CALLINGMETHOD", callingMethod);
				AddAttribute(param, "CALLEDBY", gpMethod);
				AddAttribute(param, "CALLINGTYPE", gpType);

				if (st.GetFrame(2).GetMethod().ReflectedType.IsSubclassOf(typeof(DnaComponent)))
				{
					AddAttribute(param, "ISCOMPONENT", "1");
				}
				AddTextTag(param, "DESCRIPTION", description);
				XmlNode stacktrace = AddElementTag(param, "STACKTRACE");
				for (int i = 0; i < st.FrameCount; i++)
				{
					StackFrame sf = st.GetFrame(i);
					if (sf.GetFileName() != null && !sf.GetFileName().Contains("ParameterTracker"))
					{
						XmlNode thisframe = AddElementTag(stacktrace, "STACKFRAME");
						AddTextTag(thisframe, "FILENAME", sf.GetFileName());
						AddTextTag(thisframe, "LINENO", sf.GetFileLineNumber());
						AddTextTag(thisframe, "METHOD", sf.GetMethod().ToString());
						AddTextTag(thisframe, "TYPE", sf.GetMethod().ReflectedType.ToString());
					}
				}
			}
#endif
		}


	}
}
