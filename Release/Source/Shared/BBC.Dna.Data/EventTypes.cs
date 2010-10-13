namespace BBC.Dna.Data
{
    /* This enum matches the EventType values found in the EventQueue table
     * It should correspond exactly to the translation carried out by stored proc seteventtypevalinternal
     * This is why the enum values are defined explicitly
     */

    public enum EventTypes
    {
        ET_ARTICLEEDITED                = 0,
        ET_CATEGORYARTICLETAGGED        = 1,
        ET_CATEGORYARTICLEEDITED        = 2,
        ET_FORUMEDITED                  = 3,
        ET_NEWTEAMMEMBER                = 4,
        ET_POSTREPLIEDTO                = 5,
        ET_POSTNEWTHREAD                = 6,
        ET_CATEGORYTHREADTAGGED         = 7,
        ET_CATEGORYUSERTAGGED           = 8,
        ET_CATEGORYCLUBTAGGED           = 9,
        ET_NEWLINKADDED                 = 10,
        ET_VOTEADDED                    = 11,
        ET_VOTEREMOVED                  = 12,
        ET_CLUBOWNERTEAMCHANGE          = 13,
        ET_CLUBMEMBERTEAMCHANGE         = 14,
        ET_CLUBMEMBERAPPLICATIONCHANGE  = 15,
        ET_CLUBEDITED                   = 16,
        ET_CATEGORYHIDDEN               = 17,
        ET_EXMODERATIONDECISION         = 18,
        ET_POSTTOFORUM                  = 19,
        ET_POSTREVOKE                   = 20,
        ET_POSTNEEDSRISKASSESSMENT      = 21
    }
}
