package org.osflash.samson.request
{
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	
	public function getR(url:String, data:Object=null, requestHeaders:Array=null):URLRequest
	{
		return request(url, data, URLRequestMethod.POST, requestHeaders) 
	}
}