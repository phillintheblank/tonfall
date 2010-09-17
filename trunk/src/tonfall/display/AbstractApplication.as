package tonfall.display
{
	import tonfall.core.Memory;
	import tonfall.core.Driver;
	import tonfall.core.Engine;

	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.utils.setTimeout;

	/**
	 * Abstract application class to provide minimal audio processing setup
	 * 
	 * @author Andre Michelle
	 */
	public class AbstractApplication extends Sprite
	{
		protected const driver: Driver = Driver.getInstance();
		protected const engine: Engine = Engine.getInstance();
		
		protected const spectrum: Spectrum = new Spectrum();
		
		private var _showSpectrum: Boolean;
		
		public function AbstractApplication()
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.addEventListener( Event.RESIZE, resize );
			stage.frameRate = 1000.0;
			
			// preallocate memory for processing
			Memory.length = Driver.BLOCK_SIZE << 3;
			
			resize();

			driver.engine = engine;

			// delay call to avoid glitches (Flashplayer issue)
			setTimeout( driver.start, 100 );
		}
		
		public function get showSpectrum() : Boolean
		{
			return _showSpectrum;
		}

		public function set showSpectrum( value: Boolean ) : void
		{
			if( _showSpectrum != value )
			{
				
				if( value )
					addChild( spectrum );
				else
					removeChild( spectrum );
				
				_showSpectrum = value;
			}
		}
		
		private function resize( event: Event = null ) : void
		{
			spectrum.x = ( stage.stageWidth - spectrum.width ) >> 1;
			spectrum.y = ( stage.stageHeight - spectrum.height ) >> 1;
		}
	}
}
