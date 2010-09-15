package test.metronome
{
	import tonfall.core.noteToFrequency;
	import tonfall.core.TimeEvent;
	import tonfall.core.Signal;
	import tonfall.core.SignalBuffer;
	import tonfall.core.SignalProcessor;

	/**
	 * Sound Generator for Metronome
	 * 
	 * @author Andre Michelle
	 */
	public final class MetronomeGenerator extends SignalProcessor
	{
		public const output: SignalBuffer = new SignalBuffer();
		
		private const duration: int = 44.1 * 45.0; // 45ms
		
		private var _phase: Number = 0.0;
		private var _phaseIncr: Number;
		private var _remaining: int;

		public function MetronomeGenerator() {}
		
		override protected function processTimeEvent( event: TimeEvent ) : void
		{
			if( event is MetronomeEvent )
			{
				var metronomeEvent: MetronomeEvent = MetronomeEvent( event );
				
				_phase = 0.0;
				_remaining = duration;

				if( 0 == metronomeEvent.beat )
				{
					_phaseIncr = noteToFrequency( 84 ) / 44100.0;
				}
				else
				{
					_phaseIncr = noteToFrequency( 72 ) / 44100.0;
				}
			}
		}

		override protected function processSignals( numSignals: int ) : void
		{
			var envelope: Number;
			var amplitude: Number;
			
			var signal: Signal = output.current;
			
			for( var i: int = 0 ; i < numSignals ; ++i )
			{
				if( _remaining )
				{
					envelope = ( --_remaining ) / duration; // LINEAR \

					amplitude = Math.sin( _phase * 2.0 * Math.PI ) * envelope;

					signal.l =
					signal.r = amplitude;

					_phase += _phaseIncr;
				}
				else
				{
					signal.l = 0.0;
					signal.r = 0.0;
				}

				signal = signal.next;
			}

			output.advancePointer( numSignals );
		}
	}
}