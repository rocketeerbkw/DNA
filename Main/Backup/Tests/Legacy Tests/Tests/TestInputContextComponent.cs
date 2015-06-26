using System;
using System.Collections.Generic;
using System.Text;
using BBC.Dna;
using BBC.Dna.Component;

namespace Tests
{
    class TestInputContextComponent : DnaInputComponent
    {
        /// <summary>
        /// Default constructor for the Forum component
        /// </summary>
        /// <param name="context">The Context of the DnaPage the component is created in.</param>
        public TestInputContextComponent(IInputContext context)
            : base(context)
        {
        }

        public override void ProcessRequest()
        {

        }

    }
}
