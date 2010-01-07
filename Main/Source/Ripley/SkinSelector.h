
#if !defined(SKINSELECTOR)
#define SKINSELECTOR

class CSkinSelector
{
public:
    CSkinSelector( );
    ~CSkinSelector(void);

    CTDVString GetSkinName();
    CTDVString GetSkinSet();

     bool Initialise(CInputContext& InputContext);

     static bool IsXmlSkin( CTDVString skinname);


private:
    CTDVString m_SkinName;
    CTDVString m_SkinSet;

    bool TestFileExists( const CTDVString& filename);
};

#endif
