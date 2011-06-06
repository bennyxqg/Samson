package org.osflash.samson
{
	import org.osflash.futures.FutureProgressable;

	public function loadArr(urls:Array):FutureProgressable
	{
		return load.apply(null, urls)	
	}
}