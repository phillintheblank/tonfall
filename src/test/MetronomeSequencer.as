package test
{
	import tonfall.BlockInfo;
	import tonfall.Processor;
	import tonfall.SignalBuffer;

	/**
	 * @author Andre Michelle
	 */
	public final class MetronomeSequencer extends Processor
	{
		public const output: SignalBuffer = new SignalBuffer();
		
		private var _upper: int = 4;
		private var _lower: int = 4;

		public function MetronomeSequencer() {}

		override public function process( info: BlockInfo ) : void
		{
			var position:Number = int( info.from * _lower ) / _lower;

			var beat:int;
			var bar:int;
			
			var event: MetronomeEvent;

			do
			{
				if( position >= info.from )
				{
					beat = position * _lower;
					bar  = int( beat / _upper );
					beat %= _upper;

					event = new MetronomeEvent();
					event.position = position;
					event.bar = bar;
					event.beat = beat;

					trace( event );
				}

				position += 1.0 / _lower;
			}
			while( position < info.to );
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