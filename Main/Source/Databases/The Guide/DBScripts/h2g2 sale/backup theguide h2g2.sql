BACKUP DATABASE [NewGuide] 
TO
  	DISK = 'D:\h2g2sale\theguide_Full_h2g2_v1_001.bak',
	DISK = 'D:\h2g2sale\theguide_Full_h2g2_v1_002.bak',
	DISK = 'D:\h2g2sale\theguide_Full_h2g2_v1_003.bak',
	DISK = 'D:\h2g2sale\theguide_Full_h2g2_v1_004.bak',
	DISK = 'D:\h2g2sale\theguide_Full_h2g2_v1_005.bak',
	DISK = 'D:\h2g2sale\theguide_Full_h2g2_v1_006.bak',
	DISK = 'D:\h2g2sale\theguide_Full_h2g2_v1_007.bak',
	DISK = 'D:\h2g2sale\theguide_Full_h2g2_v1_008.bak',
	DISK = 'D:\h2g2sale\theguide_Full_h2g2_v1_009.bak',
	DISK = 'D:\h2g2sale\theguide_Full_h2g2_v1_010.bak'
WITH  INIT ,  NOUNLOAD ,  NAME = N'theguide backup Full',  SKIP ,  STATS = 10,  FORMAT ,  MEDIANAME = N'theguideFull',  MEDIADESCRIPTION = N'local Full'
