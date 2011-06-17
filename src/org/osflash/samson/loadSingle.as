package org.osflash.samson
{
	import flash.display.Loader;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	
	import org.osflash.futures.Future;
	import org.osflash.futures.FutureProgressable;
	import org.osflash.futures.TypedFuture;

	/**
	 *
	 * <p>valid signitures
     * <ul>
     * 		<li>function(url:String):FutureProgressable</li>
     * 		<li>function(url:String, data:Object):FutureProgressable</li>
	 *   	<li>function(url:String, data:Object, dataFormat:String[URLLoaderDataFormat]):FutureProgressable</li>
	 * 		<li>function(url:String, context:LoaderContext):FutureProgressable</li>
     * </ul>
     * </p> 
	 */	
	public function loadSingle(url:String, ...rest):FutureProgressable
	{
		const future:FutureProgressable = new TypedFuture()
		
		// handle how the loading request can be cancelled
		future.onCancelled(function (...args):void {
			removeEvents()
			loader.close()
			
			if (isBinary)
			{
				loader.unloadAndStop()
			}
		})
			
		const isBinary:Boolean = url.search('\.swf$|\.png$|\.jpg$|\.jpeg$|\.mp3') >= 0
		
		var loader:Object
		var eventReporter:IEventDispatcher
		
		if (isBinary)
		{
			loader = new Loader()
			eventReporter = loader.contentLoaderInfo
		}
		else
		{
			loader = new URLLoader()
			
			if (rest.length == 1)
			{
				loader.data = rest[0]
			}
			else if (rest.length == 2)
			{
				loader.data = rest[0]
				loader.dataFormat = rest[1]
			}
			else if (rest.length > 2)
			{
				throw ArgumentError('valid signitures for URLLoader are function(url:String), function(url:String, data:Object), function(url:String, data:Object, dataFormat:String[URLLoaderDataFormat])')	
			}
			
			eventReporter = IEventDispatcher(loader)
		}
		
		const completeHandler:Function = function (e:Event):void {
			removeEvents()
			
			const data:* = (isBinary)
				? loader.contentLoaderInfo.content
				: loader.data
			
			// complete the loading future and map the loaded data to a new type if needed
			future.complete(data)	
		}
		
		const progressHandler:Function = function (e:ProgressEvent):void {
			future.progress(e.bytesTotal / e.bytesLoaded)
		}
		
		const errorHandler:Function = function (e:ErrorEvent):void {
			future.cancel(e)
		}
		
		const removeEvents:Function = function():void {
			eventReporter.removeEventListener(Event.COMPLETE, completeHandler)
			eventReporter.removeEventListener(ProgressEvent.PROGRESS, progressHandler)
			eventReporter.removeEventListener(IOErrorEvent.IO_ERROR, errorHandler)
			eventReporter.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, errorHandler)
		}
		
		eventReporter.addEventListener(Event.COMPLETE, completeHandler)
		eventReporter.addEventListener(ProgressEvent.PROGRESS, progressHandler)
		eventReporter.addEventListener(IOErrorEvent.IO_ERROR, errorHandler)
		eventReporter.addEventListener(SecurityErrorEvent.SECURITY_ERROR, errorHandler)
		
		const loadArgs:Array = [new URLRequest(url)]	
			
		if (isBinary)
		{
			if (rest.length == 1)
			{
				loadArgs.push(rest[0])
			}
			else if (rest.length > 1)
			{
				throw ArgumentError('valid signitures for Loader are function(url:String), function(url:String, context:LoaderContext)')
			}
		}
		
		loader.load.apply(null, loadArgs)	
			
		return future
	}
}