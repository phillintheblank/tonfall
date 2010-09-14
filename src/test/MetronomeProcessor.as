package test
{
	import tonfall.BlockInfo;
	import tonfall.Processor;
	import tonfall.Signal;
	import tonfall.SignalBuffer;
	import tonfall.noteToFrequency;
	import tonfall.samplingRate;

	/**
	 * @author Andre Michelle
	 */
	public final class MetronomeProcessor extends Processor
	{
		public const output: SignalBuffer = new SignalBuffer();
		
		private const duration: int = 44.1 * 45.0; // 45ms
		
		private var _upper: int = 4;
		private var _lower: int = 4;

		private var _phase: Number = 0.0;
		private var _phaseIncr: Number;
		private var _remaining: int;

		public function MetronomeProcessor()
		{
		}

		override public function process( info: BlockInfo ) : void
		{
			var position:Number = int( info.from * _lower ) / _lower;

			var beat:int;
			var bar:int;

			var offset: int = -1;

			do
			{
				if( position >= info.from )
				{
					beat = position * _lower;
					bar  = int( beat / _upper );
					beat %= _upper;

					_phase = 0.0;
					_phaseIncr = noteToFrequency( beat == 0 ? 84 : 72 ) / samplingRate;
					_remaining = duration;

					offset = engine.deltaBlockIndexOf( position );

//					trace( offset, position.toFixed(2), bar, beat );
					break;
				}

				position += 1.0 / _lower;
			}
			while( position < info.to );
			
			var envelope: Number;
			var amplitude: Number;
			
			var signal: Signal = output.current;
			
			var i: int = 0;
			var n: int = info.numSignals;
			
			for( ; i < n ; ++i )
			{
				if( offset > -1 )
				{
					signal.l = signal.r = 0.0;

					--offset;
				}
				else
				if( _remaining )
				{
					envelope = ( --_remaining ) / duration;

					amplitude = Math.sin( _phase * 2.0 * Math.PI ) * envelope * envelope;

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

			output.advancePointer( info.numSignals );
		}

		public function get upper() : int
		{
			return _upper;
		}

		public function set upper( value: int ) : void
		{
			_upper = value;
		}

		public function get lower() : int
		{
			return _lower;
		}

		public function set lower( value: int ) : void
		{
			_lower = value;
		}
	}
}