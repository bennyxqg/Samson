package org.osflash.samson.request
{
	import flash.net.URLVariables;
	import flash.utils.ByteArray;

	public function processRequestVariables(data:Object):Object 
	{
		if (data is URLVariables || data is String || data is ByteArray)
		{
			return data
		}
		else 
		{	// presume the object is key => value data structure and map it to URLVariables object
			const urlVariables:URLVariables = new URLVariables()
				
			for (var key:String in data)
			{
				urlVariables[key] = data[key]
			}
				
			return urlVariables
		}
	}
}