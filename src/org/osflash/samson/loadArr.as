package org.osflash.samson
{
	import org.osflash.futures.IFuture;

	public function loadArr(urls:Array):IFuture
	{
		if (urls.length < 1)
			throw new Error('loadArr requires at least one URL to load')
			
		return load.apply(null, urls)
	}
}