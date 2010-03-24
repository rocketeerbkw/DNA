using System;
using System.Collections.Generic;
using System.Text;

namespace BBC.Dna
{
    /// <summary>
    /// This is the interface for components that require the new dna form templates
    /// ( New version of the Multistep C++ )
    /// </summary>
    public interface IDnaFormComponent
    {
        /// <summary>
        /// The get property that returns the required form fields for a builder
        /// </summary>
        List<UIField> GetRequiredFormFields { get; }
    }
}
