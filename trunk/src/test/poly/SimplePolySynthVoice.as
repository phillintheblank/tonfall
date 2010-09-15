package test.poly
{
	import tonfall.core.samplingRate;
	import tonfall.core.noteToFrequency;
	import tonfall.core.Signal;
	import tonfall.poly.IPolySynthVoice;

	/**
	 * @author Andre Michelle
	 */
	public final class SimplePolySynthVoice
		implements IPolySynthVoice
	{
		private const volume: Number = 0.3;
		
		private var _phase: Number;
		private var _phaseIncr: Number;
		
		private var _duration: int;
		private var _remaining: int;

		public function start( note: Number, numSignals: int ) : void
		{
			_phase = 0.0;
			_phaseIncr = noteToFrequency( note ) / samplingRate;
			
			_duration =
			_remaining = numSignals;
		}

		public function processAdd( current: Signal, numSignals: int ) : Boolean
		{
			var envelope: Number;
			var amplitude: Number;
			
			for( var i: int = 0 ; i < numSignals ; ++i )
			{
				if( _remaining )
				{
					envelope = ( --_remaining ) / _duration; // LINEAR \

					amplitude = Math.sin( _phase * 2.0 * Math.PI ) * envelope * volume;

					current.l += amplitude;
					current.r += amplitude;
					current = current.next;

					_phase += _phaseIncr;
					if( _phase >= 1.0 )
						_phase -= 1.0;
				}
				else
				{
					// COMPLETE
					return true;
				}
			}
			
			return false;
		}
	}
}
