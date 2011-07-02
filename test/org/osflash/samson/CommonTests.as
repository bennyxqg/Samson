package org.osflash.samson
{
	import asunit.asserts.fail;
	import asunit.framework.IAsync;
	
	import flash.display.Bitmap;
	import flash.events.ErrorEvent;
	import flash.media.Sound;

	public class CommonTests
	{
		[Inject]
		public var asyncManager:IAsync
		
		static protected const Duration:Number = 200
			
		protected var loadProxy:Function	
		
		protected function async(f:Function):Function
		{
			return asyncManager.add(f, Duration) 
		}
		
		protected const 
			stringCallback:Function = function (string:String):void {},
			xmlListCallback:Function = function (xmlList:XMLList):void {},
			xmlCallback:Function = function (xml:XML):void {},
			imageCallback:Function = function (bitmap:Bitmap):void {},
			soundCallback:Function = function (sound:Sound):void {},
			cancelCallback:Function = function (e:ErrorEvent):void {}
		
		protected function failCallback(message:String):Function 
		{
			return function(...args):void {
				fail(message)
			}
		}
		
		[Test]
		public function testLoadXMLSuccess():void
		{
			loadProxy('test.xml')
				.onCompleted(async(stringCallback))
				.onCancelled(failCallback('the png should have loaded'))
		}
		
		[Test]
		public function testLoadXMLFail():void
		{
			loadProxy('non-existent.xml')
				.onCompleted(failCallback('the xml should not have loaded'))
				.onCancelled(async(cancelCallback))
		}
		
		[Test]
		public function testLoadPNGSuccess():void
		{
			loadProxy('test.png')
				.onCompleted(async(imageCallback))
				.onCancelled(failCallback('the png should have loaded'))
		}
		
		[Test]
		public function testLoadMP3Success():void
		{
			loadProxy('test.mp3')
				.onCompleted(async(soundCallback))
				.onCancelled(failCallback('the mp3 should have loaded'))
		}
	}
}