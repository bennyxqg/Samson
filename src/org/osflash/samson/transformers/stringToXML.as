package org.osflash.samson.transformers
{
	public function stringToXML(xmlRaw:String):XML 
	{
		return new XML(xmlRaw)
	}
}