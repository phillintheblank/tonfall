package
{
	import test.poly.SimplePolySynthVoiceFactory;
	import test.supermario.SuperMarioSequencer;
	import tonfall.display.AbstractApplication;
	import tonfall.poly.PolySynth;

	/**
	 * Demoes PolySynth
	 * 
	 * @author Andre Michelle
	 */
	[SWF(width='640',height='480',backgroundColor='0x1b1b1b',frameRate='32',scriptTimeLimit='255')]
	public final class SuperMario extends AbstractApplication
	{
		public function SuperMario()
		{
			const sequencer: SuperMarioSequencer = new SuperMarioSequencer();
			const generator: PolySynth = new PolySynth( SimplePolySynthVoiceFactory.INSTANCE );

			sequencer.timeEventTarget = generator;

			engine.processors.push( sequencer );
			engine.processors.push( generator );

			engine.input = generator.output;
			
			showSpectrum = true;
		}
	}
}