namespace BBC.Dna.Data
{
    /* This enum matches the ItemType and ItemType2 values found in the EventQueue table
     * It should correspond exactly to the translation carried out by stored proc setitemtypevalinternal
     * This is why the enum values are defined explicitly
     */

    public enum EventItemTypes
    {
        IT_ALL              = 0,
        IT_NODE             = 1,
        IT_H2G2             = 2,
        IT_CLUB             = 3,
        IT_FORUM            = 4,
        IT_THREAD           = 5,
        IT_POST             = 6,
        IT_USER             = 7,
        IT_VOTE             = 8,
        IT_LINK             = 9,
        IT_TEAM             = 10,
        IT_PRIVATEFORUM     = 11,
        IT_CLUB_MEMBERS     = 12,
        IT_MODID            = 13,
        IT_ENTRYID          = 14,
        IT_RISKMODQUEUEID   = 15
    }
}