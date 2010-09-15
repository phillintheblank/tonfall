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
			var event: TimeEvent;
			
			var localOffset:int = 0;

			var numSignals: int = info.numSignals;

			var eventOffset: int;

			while( events.length ) // IF INPUT EVENTS
			{
				event = events.shift();

				eventOffset = engine.deltaBlockIndexOf( event.position ) - localOffset;
				
				if( 0 < eventOffset )
				{
					// ADVANCE IN BUFFER
					processSignals( eventOffset );

					numSignals -= eventOffset;
					localOffset += eventOffset;
				}
				
				// SEND EVENT ON THE EXACT POSITION
				processTimeEvent( event );
			}

			if( numSignals )
			{
				// PROCESS REST
				processSignals( numSignals );
			}
		}
		
		protected function processTimeEvent( event: TimeEvent ): void {}
		
		protected function processSignals( numSignals: int ): void {}
	}
}