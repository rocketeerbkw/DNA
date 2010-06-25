function previewmode()
	{
		// add a hidden preview element to all forms
		var flen = document.forms.length;
		for (i=0;i<flen;i++)
		{
			var f = document.forms[i];
			var newel = document.createElement('input');
			newel.setAttribute('type', 'hidden');
			newel.setAttribute('name', '_previewmode');
			newel.setAttribute('value', 1);	
			f.appendChild(newel);
		}

		// add the preview mode param to all dna links		
		var alen = document.links.length;
		for (i=0;i<alen;i++)
		{
			var l = document.links[i];
			var shref = l.href.toLowerCase();			
			// check the link is a dna link
			if (shref.indexOf("/dna/") >= 0)
			{
				var iqm = l.href.indexOf("?");
				var iamp = l.href.lastIndexOf("&");
				
				if (iqm >= 0)
				{
					// we have a "?" so add the param immediately after it
					var s1 = l.href.substring(0,iqm+1);
					var s2 = l.href.substring(iqm+1);
					l.href = s1+"_previewmode=1&"+s2;
				}
				else
				{
					var ihash = l.href.lastIndexOf("#");
					if (ihash >= 0)
					{
						// there's no "?" but there is a "#", so add immediately before "#"
						var s1 = l.href.substring(0,ihash);
						var s2 = l.href.substring(ihash);
						l.href = s1+"?_previewmode=1"+s2;
					}
					else
					{
						// no "?" or "#", so add as the first param on the url
						l.href = l.href+"?_previewmode=1";
					}
				}
			}
		}
	}