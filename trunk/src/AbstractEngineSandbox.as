package
{
	import tonfall.core.Driver;
	import tonfall.core.Engine;
	import tonfall.display.Spectrum;

	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;

	/**
	 * @author Andre Michelle
	 */
	public class AbstractEngineSandbox extends Sprite
	{
		protected const driver: Driver = Driver.getInstance();
		protected const engine: Engine = Engine.getInstance();
		
		protected const spectrum: Spectrum = new Spectrum();
		
		public function AbstractEngineSandbox()
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.addEventListener( Event.RESIZE, resize );
			stage.frameRate = 1000.0;
			
			addChild( spectrum );
			
			resize();

			driver.engine = engine;
		}
		
		private function resize( event: Event = null ) : void
		{
			spectrum.x = ( stage.stageWidth - spectrum.width ) >> 1;
			spectrum.y = ( stage.stageHeight - spectrum.height ) >> 1;
		}
	}
}
