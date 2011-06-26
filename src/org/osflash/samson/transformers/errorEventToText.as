package org.osflash.samson.transformers
{
	import flash.events.ErrorEvent;

	public function errorEventToText(e:ErrorEvent):String {
		return e.text
	}
}