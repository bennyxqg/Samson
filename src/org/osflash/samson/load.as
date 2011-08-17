package org.osflash.samson
{
	import org.osflash.futures.IFuture;
	import org.osflash.futures.creation.waitOnCritical;

	public function load(url:*, ...rest):IFuture
	{
		const urls:Array = [url].concat(rest)
		
		const loadingFutures:Array = urls.map(function (url:String, index:int, arr:Array):IFuture {
			return loadSingle(url)
		})
		
		return waitOnCritical.apply(null, loadingFutures)
	}
}