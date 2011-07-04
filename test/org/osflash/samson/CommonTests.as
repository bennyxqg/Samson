package org.osflash.samson
{
	import asunit.asserts.assertEquals;
	import asunit.asserts.assertMatches;
	import asunit.asserts.fail;
	import asunit.framework.Async;
	import asunit.framework.IAsync;
	
	import flash.display.Bitmap;
	import flash.events.ErrorEvent;
	import flash.media.Sound;
	
	import org.osflash.samson.request.getR;
	import org.osflash.samson.request.postR;

	public class CommonTests
	{
		[Inject]
		public var asyncManager:IAsync
		
		static protected const 
			AsyncTimeout:Number = 200,
			ServerScheme:String = "http",
			ServerHost:String = "localhost",
			ServerPort:String = "28561",
			ServerURL:String = ServerScheme+'://'+ServerHost+':'+ServerPort
			
		protected var loadProxy:Function	
		
		protected function async(f:Function):Function
		{
			return asyncManager.add(f, AsyncTimeout) 
		}
		
		protected const 
			stringCallback:Function = function (string:String):void {},
			xmlListCallback:Function = function (xmlList:XMLList):void {},
			xmlCallback:Function = function (xml:XML):void {},
			imageCallback:Function = function (bitmap:Bitmap):void {},
			soundCallback:Function = function (sound:Sound):void {},
			cancelCallback:Function = function (e:ErrorEvent):void {}
		
		protected function failCallback(message:String=''):Function 
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
		
		[Test]
		public function postDataShouldBeReturnedTransformed():void
		{
			trace('post:', ServerURL)
			loadSingle(postR(ServerURL, {a:'a', b:'b', c: 'c'}))
				.onCompleted(function (reply:String):void {
					trace('post reply:', reply)
//					assertEquals('aTransform-bTransform-cTransform', reply)
				})
				.onCancelled(failCallback())
		}
		
		[Test]
		public function getDataShouldBeReturnedTransformed():void
		{
			trace('get:', ServerURL)
			
			loadSingle(getR(ServerURL, {a:'a', b:'b', c: 'c'}))
				.onCompleted(function (reply:String):void {
					trace('get reply:', reply)
//					assertEquals('aTransform-bTransform-cTransform', reply)
				})
				.onCancelled(failCallback())
		}
	}
}