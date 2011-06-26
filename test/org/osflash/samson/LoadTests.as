package org.osflash.samson
{
	import asunit.asserts.fail;
	import asunit.framework.IAsync;
	
	import flash.display.Bitmap;
	import flash.events.ErrorEvent;
	import flash.media.Sound;

	public class LoadTests
	{
		[Inject]
		public var async:IAsync
		
		[Test]
		public function testLoadXMLSuccess():void
		{
			loadSingle('test.png')
				.onCompleted(async.add(function (raw:String):void {}, 200))
				.onCancelled(function (e:ErrorEvent):void {
					fail('the xml should have loaded')
				})
		}
		
		[Test]
		public function testLoadXMLFail():void
		{
			loadSingle('non-existent.xml')
				.onCompleted(function (raw:String):void {
					fail('the png should not have loaded')
				})
				.onCancelled(async.add(function (e:ErrorEvent):void {}, 200))
		}
		
		[Test]
		public function testLoadPNGSuccess():void
		{
			loadSingle('test.png')
				.onCompleted(async.add(function (bitmap:Bitmap):void {}, 200))
				.onCancelled(function (e:ErrorEvent):void {
					fail('the png should have loaded')
				})
		}
		
		// TODO: implement audio loading
//		[Test]
//		public function testLoadMP3Success():void
//		{
//			loadSingle('test.mp3')
//				.onCompleted(async.add(function (sound:Sound):void {}, 200))
//				.onCancelled(function (e:ErrorEvent):void {
//					fail('the mp3 should have loaded')
//				})
//		}
	}
}