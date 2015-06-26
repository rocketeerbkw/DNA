using System;
using System.Collections.Generic;
using System.IO;
using System.Text;
using BBC.Dna;
using BBC.Dna.Utils;

namespace Tests
{
	/// <summary>
	/// A test output context on which you can perform tests
	/// It also has some internal sanity checking
	/// </summary>
	public class DummyOutputContext : TestOutputContext
	{
		private string _contentType = string.Empty;
		private DnaDiagnostics _diag = new DnaDiagnostics(1, DateTime.Now);

		/// <summary>
		/// Exposes the current content-type set by the caller
		/// </summary>
		public string ContentType
		{
			get { return _contentType; }
		}

		/// <summary>
		/// Exposes the contents of the writer stream, for testing purposes
		/// </summary>
		public StringBuilder Contents
		{
			get { return _contents; }
		}

		private StringBuilder _contents = new StringBuilder();
		private StringWriter _writer;
		/// <summary>
		/// <see cref="IOutputContext"/>
		/// </summary>
		public override TextWriter Writer
		{
			get
			{
				return _writer;
			}
		}

		/// <summary>
		/// Constructor. Initialises the string writer used to capture the output
		/// </summary>
		public DummyOutputContext()
		{
			_writer = new StringWriter(_contents);
		}

		/// <summary>
		/// <see cref="IOutputContext"/>
		/// </summary>
		public override void SetContentType(string contentType)
		{
			if (_contentType.Length != 0)
			{
				throw new Exception("SetContentType probably shouldn't be called more than once.");
			}
			_contentType = contentType;
		}

		/// <summary>
		/// <see cref="IOutputContext"/>
		/// </summary>
		public override IDnaDiagnostics Diagnostics
		{
			get
			{
				return _diag;
			}
		}
	}
}
