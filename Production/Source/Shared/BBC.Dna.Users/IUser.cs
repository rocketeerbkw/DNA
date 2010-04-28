using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace BBC.Dna.Users
{
    public interface IUser
    {
        /// <summary>
        /// This method checks to see if the current user is one of the known user types
        /// </summary>
        /// <param name="type">The type you want to check against</param>
        /// <returns>True if they are of the given type, false if not</returns>
        bool IsUserA(UserTypes type);

    }
}
