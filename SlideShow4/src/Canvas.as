package
{
	// そうま
	import a24.tween.Ease24;
	import a24.tween.Tween24;
	import br.com.stimuli.loading.lazyloaders.LazyXMLLoader;
	import br.com.stimuli.loading.loadingtypes.LoadingItem;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Matrix;
	
	/**
	 * ...
	 * @author umhr
	 */
	public class Canvas extends Sprite
	{
		private var _lazyXMLLoader:LazyXMLLoader;
		private var _bitmapList:Array/*Bitmap*/ = [];
		private var _imgCount:int = 0;
		private var _count:int = -210;
		private var _maisu:int = 0;
		
		public function Canvas()
		{
			init();
		}
		
		private function init():void
		{
			if (stage)
				onInit();
			else
				addEventListener(Event.ADDED_TO_STAGE, onInit);
		}
		
		private function onInit(event:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onInit);
			// entry point
			
            _lazyXMLLoader = new LazyXMLLoader("config.xml", "theLazyLoader");
            _lazyXMLLoader.addEventListener(Event.COMPLETE, onAllLoaded);
            _lazyXMLLoader.start();
			
		}
		
		private function onAllLoaded(e:Event):void
		{
			var stageWidth:int = stage.stageWidth;
			var stageHeight:int = stage.stageHeight;
			
            for each (var item:LoadingItem in _lazyXMLLoader.items) {
				if (item.type == "image") {
					var i:int = _bitmapList.length;
					var bitmap:Bitmap = new Bitmap(new BitmapData(stageWidth, stageHeight, false, 0xFF000000), "auto", true);
					var loaddedBitmap:Bitmap = _lazyXMLLoader.getBitmap(item.id, true);
					var scale:Number = Math.min(stageWidth / loaddedBitmap.width, stageHeight / loaddedBitmap.height);
					var tx:Number = (stageWidth - loaddedBitmap.width * scale) * 0.5;
					var ty:Number = (stageHeight - loaddedBitmap.height * scale) * 0.5;
					bitmap.bitmapData.draw(loaddedBitmap, new Matrix(scale, 0, 0, scale, tx, ty), null, null, null, true);
					_bitmapList.push(bitmap);
					if (i == 0) {
						bitmap.y = 0;
					}else{
						bitmap.y = stage.stageHeight;
					}
					addChild(bitmap);
					_maisu = i + 1;
				}
            }
			stage.addEventListener(Event.ENTER_FRAME, stage_enterFrame);
		}
		
		
		private function stage_enterFrame(e:Event):void 
		{
			_count ++;
			if (_count > 0) {
				timer_timer();
				_count = -30 * 7;
			}
		}
		
		private function timer_timer():void
		{
			
			var bmpA:Bitmap = _bitmapList[_imgCount];
			var bmpB:Bitmap = _bitmapList[(_imgCount + 1) % _maisu];
			
			Tween24.serial(
				Tween24.parallel(
					Tween24.prop(bmpA).y(0),
					Tween24.prop(bmpB).y(stage.stageHeight)
				),
				Tween24.parallel(
					Tween24.tween(bmpA, 1, Ease24._1_SineOut).y( -stage.stageHeight),
					Tween24.tween(bmpB, 1, Ease24._1_SineOut).y(0)
				)
			).play();
			
			_imgCount++;
			_imgCount %= _maisu;
			
		}
	}

}