package org.osflash.samson.request
{
	import flash.net.URLRequest;

	public function request(url:String, data:Object=null, method:String=null, requestHeaders:Array=null):URLRequest
	{
		const urlRequest:URLRequest = new URLRequest(url)
		
		if (data) 				urlRequest.data = data
		if (method)				urlRequest.method = method
		if (requestHeaders)		urlRequest.requestHeaders = requestHeaders
			
		return urlRequest
	}
}