package
{
	import test.mario.SuperMario;
	import test.poly.SimplePolySynthVoiceFactory;

	import tonfall.poly.PolySynth;

	/**
	 * @author Andre Michelle
	 */
	[SWF(width='640',height='480',backgroundColor='0x1b1b1b',frameRate='32',scriptTimeLimit='255')]
	public final class TestEngineSuperMario extends AbstractEngineSandbox
	{
		public function TestEngineSuperMario()
		{
			const sequencer: SuperMario = new SuperMario();
			const generator: PolySynth = new PolySynth( new SimplePolySynthVoiceFactory() );

			sequencer.timeEventTarget = generator;

			engine.processors.push( sequencer );
			engine.processors.push( generator );

			engine.input = generator.output;
		}
	}
}