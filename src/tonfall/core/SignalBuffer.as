package tonfall.core
{
	/**
	 * Stereo audio data linked list
	 * 
	 * @author Andre Michelle
	 */
	public final class SignalBuffer
	{
		private var _current: Signal;
		private var _index: int;
		private var _length: int;
		
		private var _vector: Vector.<Signal>;
		
		public function SignalBuffer()
		{
			init( Driver.BLOCK_SIZE );
		}

		public function get current() : Signal
		{
			return _current;
		}
		
		public function zero( num: int ): void
		{
			var signal: Signal = _current;
			
			for( var i: int = 0 ; i < num ; ++i )
			{
				signal.l =
				signal.r = 0.0;
				
				signal = signal.next;
			}
		}

		public function advancePointer( count: int ): void
		{
			if( 0 == count )
				return;
			
			_index += count;

			if( _index == _length )
			{
				_index = 0;
			}
			else
			if( _index < 0 || _index > _length )
			{
				throw new RangeError( 'Out of range exception. index = ' + _index + ', length = ' + _length );
			}

			_current = _vector[ _index ];
		}
		
		private function init( length: int ): void
		{
			var head: Signal;
			var tail:Signal;

			_vector = new Vector.<Signal>( length, true );

			tail = head = _vector[0] = new Signal();

			for( var i: int = 1; i < length ; ++i )
			{
				tail = tail.next = _vector[i] = new Signal();
			}

			_current = tail.next = head;

			_index = 0;
			_length = length;
		}
	}
}
