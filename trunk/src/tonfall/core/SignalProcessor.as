package tonfall.core
{
	/**
	 * SignalProcessor provides sample-exact event processing.
	 * 
	 * @author Andre Michelle
	 */
	public /*abstract*/ class SignalProcessor extends Processor
	{
		public function SignalProcessor() {}

		final override public function process( info: BlockInfo ) : void
		{
			var event: TimeEvent;
			
			var localIndex:int = 0;

			var remaining: int = info.numSignals;

			var eventOffset: int;

			while( events.length ) // IF INPUT EVENTS EXISTS
			{
				event = events.shift();

				eventOffset = engine.deltaBlockIndexAt( event.barPosition ) - localIndex;
				
				if( 0 < eventOffset )
				{
					// ADVANCE IN BUFFER
					processSignals( eventOffset );

					remaining -= eventOffset;
					localIndex += eventOffset;
				}
				
				// SEND EVENT ON THE EXACT POSITION
				processTimeEvent( event );
				
				event.dispose();
			}

			if( remaining )
			{
				// PROCESS REST
				processSignals( remaining );
			}
		}
		
		protected function processTimeEvent( event: TimeEvent ): void
		{
			throw new Error( 'Method "processTimeEvent" is marked abstract.' );
		}
		
		protected function processSignals( numSignals: int ): void
		{
			throw new Error( 'Method "processSignals" is marked abstract.' );
		}
	}
}