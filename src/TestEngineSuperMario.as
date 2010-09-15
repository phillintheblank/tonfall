package
{
	import test.mario.SuperMario;
	import test.metronome.MetronomeSequencer;
	import test.metronome.MetronomeGenerator;

	import tonfall.core.Driver;
	import tonfall.core.Engine;

	import flash.display.Sprite;

	/**
	 * @author Andre Michelle
	 */
	public final class TestEngineSuperMario extends Sprite
	{
		private const driver: Driver = Driver.getInstance();
		private const engine: Engine = Engine.getInstance();

		public function TestEngineSuperMario()
		{
			driver.engine = engine;
			
			//new SuperMario();
			
			const sequencer: MetronomeSequencer = new MetronomeSequencer();
			const generator: MetronomeGenerator = new MetronomeGenerator();

			sequencer.timeEventTarget = generator;

			engine.processors.push( sequencer );
			engine.processors.push( generator );

			engine.input = generator.output;
		}
	}
}