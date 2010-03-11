﻿namespace BBC.Dna.Api
{
    public enum FilterBy
    {
        /// <summary>
        /// No filter
        /// </summary>
        None,

        /// <summary>
        /// Editor picks
        /// </summary>
        EditorPicks,

        /// <summary>
        /// A provided user list - comma seperated
        /// </summary>
        UserList
    }
}