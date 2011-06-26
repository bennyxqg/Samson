package org.osflash.samson
{
	import org.osflash.futures.FutureProgressable

	// generic loader
	public function load(...urls):FutureProgressable
	{
		var future:FutureProgressable = loadSingle(urls[0])
		
		for (var i:int=1; i<urls.length; ++i)
		{
			var url:String = urls[i]
			future = FutureProgressable(future.waitOnCritical(loadSingle(url)))
		}
		
		return future
	}
}