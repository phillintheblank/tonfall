package
{
	import test.MetronomeProcessor;

	import tonfall.Driver;
	import tonfall.Engine;

	import flash.display.Sprite;

	/**
	 * @author Andre Michelle
	 */
	public final class TestEngineMetronome extends Sprite
	{
		private const driver: Driver = Driver.getInstance();
		private const engine: Engine = Engine.getInstance();

		public function TestEngineMetronome()
		{
			driver.engine = engine;
			
			const processor: MetronomeProcessor = new MetronomeProcessor();

			engine.processors.push( processor );
			engine.input = processor.output;
		}
	}
}