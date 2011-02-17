package test
{
	import tonfall.core.Signal;
	import tonfall.core.SignalBuffer;
	import tonfall.core.SignalProcessor;

	/**
	 * Simple MixingUnit
	 * 
	 * Caution: No interpolation between different gains and pannings.
	 * 
	 * @author Andre Michelle
	 */
	public final class MixingUnit extends SignalProcessor
	{
		public const output: SignalBuffer = new SignalBuffer();
		
		private var _numInputs: uint;
		private var _inputs: Vector.<SignalBuffer>;
		private var _gains: Vector.<Number>;
		private var _pans: Vector.<Number>;
		
		public function MixingUnit( numInputs: uint )
		{
			_numInputs = numInputs;

			_inputs = new Vector.<SignalBuffer>( numInputs, true );
			_gains = new Vector.<Number>( numInputs, true );
			_pans = new Vector.<Number>( numInputs, true );

			for( var i: int = 0 ; i < numInputs ; ++i )
				_gains[i] = 0.7; // DEFAULT GAIN
		}
		
		/**
		 * Connect a SignalBuffer with passed index
		 */
		public function connectAt( output: SignalBuffer, index: int ): void
		{
			_inputs[ index ] = output;
		}
		
		/**
		 * Disconnect SignalBuffer at passed index
		 */
		public function disconnectAt( index: int ): void
		{
			_inputs[ index ] = null;
		}
		
		/**
		 * @param gain Value between zero and one
		 */
		public function setGainAt( gain: Number, index: int ): void
		{
			_gains[ index ] = gain;
		}
		
		public function getGainAt( index: int ): Number
		{
			return _gains[ index ];
		}
		
		/**
		 * @param pan Value between -1 (left) and +1 (right)
		 */
		public function setPanAt( pan: Number, index: int ): void
		{
			_pans[ index ] = pan;
		}
		
		public function getPanAt( index: int ): Number
		{
			return _pans[ index ];
		}
		
		override protected function processSignals( numSignals: int ): void
		{
			var input: SignalBuffer;
			
			var first: Boolean = true;
			
			const out: Signal = output.current;
			
			const n: int = _inputs.length;
			
			for( var i: int = 0 ; i < n ; ++i )
			{
				input = _inputs[i];

				if( null == input )
					continue;

				var pan: Number = _pans[i];
				var gain: Number = _gains[i];

				gain /= 1.0 + Math.abs( pan );

				var gainL: Number = ( 1.0 - pan ) * gain;
				var gainR: Number = ( pan + 1.0 ) * gain;
				
				if( first )
				{
					processReplace( input.current, out, numSignals, gainL, gainR );
					first = false;
				}
				else
				{
					processAdd( input.current, out, numSignals, gainL, gainR );
				}
			}
		}

		private function processReplace( inp: Signal, out: Signal, numSignals: int, gainL: Number, gainR: Number ): void
		{
			for( var i: int = 0 ; i < numSignals ; ++i )
			{
				out.l = inp.l * gainL;
				out.r = inp.r * gainR;

				out = out.next;
				inp = inp.next;
			}
		}
		
		private function processAdd( inp: Signal, out: Signal, numSignals: int, gainL: Number, gainR: Number ): void
		{
			for( var i: int = 0 ; i < numSignals ; ++i )
			{
				out.l += inp.l * gainL;
				out.r += inp.r * gainR;

				out = out.next;
				inp = inp.next;
			}
		}
	}
}