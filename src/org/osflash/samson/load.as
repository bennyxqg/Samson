package org.osflash.samson
{
	import org.osflash.futures.IFuture;
	import org.osflash.futures.creation.waitOnCritical;

	public function load(name:String, url:*, ...rest):IFuture
	{
		const urls:Array = [url].concat(rest)
		
		const loadingFutures:Array = urls.map(function (url:String, index:int, arr:Array):IFuture {
			return loadSingle(name+'-loadSingle:'+url, url)
		})
		
		return waitOnCritical.apply(null, [name].concat(loadingFutures))
	}
}