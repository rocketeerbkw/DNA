-- Update the link to the Random Edited Entry on the front page to the correct URL

update guideentries
	set text=replace(text,'http://www.bbc.co.uk/dna/h2g2/RandomEditedEntry', 'http://wsogmm.h2g2.com/dna/h2g2/RandomEditedEntry')
	where entryid = (select max(entryid) from keyarticles where siteid=1)

