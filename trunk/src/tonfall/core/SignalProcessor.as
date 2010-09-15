package tonfall.core
{

	/**
	 * @author Andre Michelle
	 */
	public class SignalProcessor extends Processor
	{
		public function SignalProcessor() {}

		final override public function process( info: BlockInfo ) : void
		{
			trace( info );
			
			var event: TimeEvent;
			
			var localOffset:int = 0;

			var numSignals: int = info.numSignals;

			var eventOffset: int;

			while( events.length )
			{
				event = events.shift();

				eventOffset = engine.deltaBlockIndexOf( event.position ) - localOffset;
				
				if( 0 < eventOffset )
				{
					processSignals( eventOffset );
					
					numSignals -= eventOffset;
					localOffset += eventOffset;
				}
				
				processTimeEvent( event );
			}

			if( numSignals )
			{
				processSignals( numSignals );
			}
		}
		
		protected function processTimeEvent( event: TimeEvent ): void {}
		
		protected function processSignals( numSignals: int ): void {}
	}
}