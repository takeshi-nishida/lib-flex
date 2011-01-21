package ui
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	
	import mx.core.UIComponent;
	import mx.events.ResizeEvent;
	
	[Bindable]
	[Event(name="imageLoaded", type="flash.events.Event")]
	public class CacheableImage extends UIComponent
	{
		private var imageRepository:ImageRepository;
		private var bitmapData:BitmapData;
		private var loader:Loader;
		private var loaderContext:LoaderContext;
		private var _scale:Number;
		
		public function CacheableImage(){
			loader = new Loader();
			loaderContext = new LoaderContext(true);
			imageRepository = ImageRepository.getInstance();
			addEventListener(ResizeEvent.RESIZE, resizeHandler);
			_scale = 1.0;
		}
		
		public function load(url:String):void{
			if(imageRepository.lookup(url) != null){
				bitmapData = BitmapData(imageRepository.lookup(url));
				drawImage();
				dispatchEvent(new Event(Event.COMPLETE));
				dispatchEvent(new Event("imageLoaded"));
			}else{
				var request:URLRequest = new URLRequest(url);
				loader.load(request, loaderContext);
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadComplete);
				loader.contentLoaderInfo.addEventListener(HTTPStatusEvent.HTTP_STATUS, eventCapture);
				loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, eventCapture);
				loader.contentLoaderInfo.addEventListener(Event.OPEN, eventCapture);
				loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, eventCapture);
				loader.contentLoaderInfo.addEventListener(Event.UNLOAD, eventCapture);
			}
		}
		
		public function unload():void{
			loader.unload();
		}
		
		private function onLoadComplete(e:Event):void{
			bitmapData = Bitmap(loader.content).bitmapData;
			imageRepository.cacheImage(loader.contentLoaderInfo.url, bitmapData);
			drawImage();
			dispatchEvent(new Event("imageLoaded"));
		}
		
		private function eventCapture(e:Event):void{
			dispatchEvent(e);
		}
		
		private function drawImage():void{
			if(bitmapData){
				_scale = Math.min(width / bitmapData.width, height / bitmapData.height);
				var w:int = Math.min(width, bitmapData.width * _scale);
				var h:int = Math.min(height, bitmapData.height * _scale);
				var matrix:Matrix = new Matrix();
				matrix.scale(_scale, _scale);
				graphics.clear();
				graphics.beginBitmapFill(bitmapData, matrix);
				graphics.drawRect(0, 0, w, h);
				graphics.endFill();
			}
		}
		
		public function set source(url:String):void{
			load(url);
		}
		
		public function resizeHandler(event:ResizeEvent) : void {
			drawImage();
		}
		
		public function get scaleValue() : Number {
			return _scale;
		}
		
		public function localToImage(x:int, y:int) : Point {
			return new Point(x / _scale, y / _scale);
		}
		
		public function imageToLocal(x:int, y:int) : Point {
			return new Point(x * _scale, y * _scale);		  
		}
	}
}

