package tonfall.poly
{
	import tonfall.core.TimeConversion;
	import tonfall.core.Signal;
	import tonfall.core.TimeEventNote;
	import tonfall.core.TimeEvent;
	import tonfall.core.SignalBuffer;
	import tonfall.core.SignalProcessor;

	/**
	 * PolySynth provides a simple way to create a polyphone synthesizer.
	 * 
	 * @author Andre Michelle
	 */
	public final class PolySynth extends SignalProcessor
	{
		public const output: SignalBuffer = new SignalBuffer();
		
		private const activeVoices: Vector.<IPolySynthVoice>
										= new Vector.<IPolySynthVoice>();
		
		private var _voicefactory: IPolySynthVoiceFactory;

		public function PolySynth( voicefactory: IPolySynthVoiceFactory )
		{
			_voicefactory = voicefactory;
		}
		
		override protected function processTimeEvent( event: TimeEvent ) : void
		{
			if( event is TimeEventNote )
			{
				startVoice( TimeEventNote( event ) );
			}
		}

		private function startVoice( event: TimeEventNote ) : void
		{
			const voice: IPolySynthVoice =
							_voicefactory.create( event );

			voice.start( event.note, TimeConversion.barsToNumSamples( event.duration, engine.bpm ) );

			activeVoices.push( voice );
		}
		
		override protected function processSignals( numSignals: int ) : void
		{
			output.zero( numSignals );
			
			var current: Signal = output.current;

			var i: int = activeVoices.length;

			while( --i > -1 )
			{
				if( activeVoices[i].processAdd( current, numSignals ) )
				{
					activeVoices.splice( i, 1 );
				}
			}

			output.advancePointer( numSignals );
		}
	}
}