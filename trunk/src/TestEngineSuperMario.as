package
{
	import test.mario.SuperMario;
	import test.poly.SimplePolySynthVoiceFactory;

	import tonfall.core.Driver;
	import tonfall.core.Engine;
	import tonfall.poly.PolySynth;

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
			
			const sequencer: SuperMario = new SuperMario();
			const generator: PolySynth = new PolySynth( new SimplePolySynthVoiceFactory() );

			sequencer.timeEventTarget = generator;

			engine.processors.push( sequencer );
			engine.processors.push( generator );

			engine.input = generator.output;
		}
	}
}