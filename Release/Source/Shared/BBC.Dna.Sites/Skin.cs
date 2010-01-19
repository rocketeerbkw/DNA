using System;
using System.Collections.Generic;
using System.Text;
using System.Xml;

namespace BBC.Dna.Sites
{

    /// <summary>
    /// The Skin class holds all the data regarding a Skins for a site
    /// </summary>
    public class Skin
    {
        private string _description;
        private string _name;
        private bool _useFrames;

        /// <summary>
        /// Constructor
        /// </summary>
        public Skin()
        {
        }

        /// <summary>
        /// Property for the description of the skin
        /// </summary>
        public string Description
        {
          get 
          { 
              return _description; 
          }
          set 
          { 
              _description = value; 
          }
        }

        /// <summary>
        /// Property for the name of the skin
        /// </summary>
        public string Name
        {
          get 
          { 
              return _name; 
          }
          set 
          { 
              _name = value; 
          }
        }


        /// <summary>
        /// Property for whether the skin use frames
        /// </summary>
        public bool UseFrames
        {
          get 
          { 
              return _useFrames; 
          }
          set 
          { 
              _useFrames = value; 
          }
        }

        /// <summary>
        /// Constructor from another skin object
        /// </summary>
        /// <param name="other">The other skin to create the new skin from</param>
        public Skin(Skin other)
        {
            Name = other.Name;
			Description = other.Description;
			UseFrames = other.UseFrames;
        }

        /// <summary>
        /// Constructor from individual skin elements
        /// </summary>
        /// <param name="name">Name to give the new skin</param>
        /// <param name="description">Description to give the new skin</param>
        /// <param name="useFrames">Whether the new skin uses frames</param>
        public Skin(string name, string description, bool useFrames)
        {
            Name = name;
			Description = description;
			UseFrames = useFrames;
        }
     }
}
