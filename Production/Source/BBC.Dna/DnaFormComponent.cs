using System;
using System.Collections.Generic;
using System.Text;
using BBC.Dna.Component;

namespace BBC.Dna.Component
{
    /// <summary>
    /// Derive from this class if your component is going to use the Dna Template Form system
    /// It holds base functionality that the template system requires to generate it's templates.
    /// </summary>
    public abstract class DnaFormComponent : DnaInputComponent, IDnaFormComponent
    {
        /// <summary>
        /// Default constructor
        /// </summary>
        /// <param name="context">The context that the component is to run in.</param>
        public DnaFormComponent(IInputContext context)
            : base(context)
        {
        }

        /// <summary>
        /// Derived components must declare what are it's required form fields.
        /// Add the fields in this method.
        /// </summary>
        public abstract List<UIField> GetRequiredFormFields { get; }
    }
}
