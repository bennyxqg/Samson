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
	
	import org.osflash.futures.IFuture;
	import org.osflash.futures.creation.Future;
	import org.osflash.samson.request.processRequestVariables;

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
	public function loadSingle(name:String, stringOrURLRequest:*, ...rest):IFuture
	{
		const urlRequest:URLRequest = (stringOrURLRequest is URLRequest)
			? stringOrURLRequest
			: new URLRequest(stringOrURLRequest.toString())
			
		const future:IFuture = new Future(name)
		
		// handle how the loading request can be cancelled
		future.onCancel(function (...args):void {
			removeEvents()
			
			try { loader.close() }
			catch (e:Error) {}
			
			if (isBinary)
			{
				loader.unloadAndStop()
			}
		})
			
		// remove any arguments before type checking
		const urlStripped:String = urlRequest.url.replace(/\?.*$/, '')
		const isAudio:Boolean = urlStripped.search('\.mp3|\.aac') >= 0
		const isBinary:Boolean = urlStripped.search('\.swf$|\.png$|\.jpg$|\.jpeg$') >= 0
		
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
				
			// if one arg then presume its data
			if (rest.length == 1)
			{
				loader.data = processRequestVariables(rest[0])
			}
			// if two args it's data and dataFormat
			else if (rest.length == 2)
			{
				urlRequest.data = processRequestVariables(rest[0])
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
//			if (future.cancelledListeners > 1)
//			{
				future.cancel(e)
//			}
//			else
//			{	
//				if (e is IOErrorEvent)					throw new IOError(e.text)
//				else if (e is SecurityErrorEvent)		throw new SecurityError(e.text)
//			}
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
			
		return future.isolate()
	}
}