package org.osflash.samson
{
	import flash.display.Loader;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.media.Sound;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	
	import org.osflash.futures.Future;
	import org.osflash.futures.FutureProgressable;
	import org.osflash.futures.creation.TypedFuture;

	/**
	 *
	 * <p>valid signitures
     * <ul>
     * 		<li>function(urlOrUrlRequest:[String|UrlRequest]):FutureProgressable</li>
     * 		<li>function(urlOrUrlRequest:[String|UrlRequest], data:Object):FutureProgressable</li>
	 *   	<li>function(urlOrUrlRequest:[String|UrlRequest], data:Object, dataFormat:String[URLLoaderDataFormat]):FutureProgressable</li>
	 * 		<li>function(urlOrUrlRequest:[String|UrlRequest], context:LoaderContext):FutureProgressable</li>
     * </ul>
     * </p> 
	 */	
	public function loadSingle(stringOrURLRequest:*, ...rest):FutureProgressable
	{
		const urlRequest:URLRequest = (stringOrURLRequest is URLRequest)
			? stringOrURLRequest
			: new URLRequest(stringOrURLRequest.toString())
			
		const future:FutureProgressable = new TypedFuture()
		
		// handle how the loading request can be cancelled
		future.onCancelled(function (...args):void {
			removeEvents()
			
			try { loader.close() }
			catch (e:Error) {}
			
			if (isBinary)
			{
				loader.unloadAndStop()
			}
		})
			
		const isAudio:Boolean = urlRequest.url.search('\.mp3|\.aac') >= 0
		const isBinary:Boolean = urlRequest.url.search('\.swf$|\.png$|\.jpg$|\.jpeg$') >= 0
		
		var loader:Object
		var eventReporter:IEventDispatcher
		
		if (isAudio)
		{
			loader = new Sound()
			eventReporter = IEventDispatcher(loader)
		}
		else if (isBinary)
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
				urlRequest.data = rest[0]
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
			
			const data:* = (isAudio)
				?	loader
				:	(isBinary)
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
		
		const loadArgs:Array = [urlRequest]	
			
		if (isBinary || isAudio)
		{
			if (rest.length == 1)
			{
				loadArgs.push(rest[0])
			}
			else if (rest.length > 1)
			{
				throw ArgumentError('valid signitures for Loader are function(url:String), function(url:String, context:LoaderContext|SoundLoaderContext)')
			}
		}
		
		loader.load.apply(null, loadArgs)	
			
		return future
	}
}