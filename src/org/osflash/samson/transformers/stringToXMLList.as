package org.osflash.samson.transformers
{
	public function stringToXMLList(xmlRaw:String):XMLList
	{
		return new XMLList(xmlRaw)
	}
}