package org.osflash.samson
{
	import org.osflash.futures.FutureProgressable

	// generic loader
	public function load(...urls):FutureProgressable
	{
		var future:FutureProgressable = loadSingle(urls[0])
		
		for (var i:int=1; i<urls.length; ++i)
		{
			future = FutureProgressable(future.waitOnCritical(loadSingle(urls[i])))
		}
		
		return future
	}
}