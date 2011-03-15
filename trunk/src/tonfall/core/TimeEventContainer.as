package tonfall.core
{
	/**
	 * @author Andre Michelle
	 */
	public final class TimeEventContainer
	{
		private const vector: Vector.<TimeEvent> = new Vector.<TimeEvent>();
		
		public function push( event: TimeEvent ): void
		{
			vector.push( event );
			
			vector.sort( sortOnPosition );
		}
		
		public function pushMany( ...events ): void
		{
			vector.push.apply( this, events );
			
			vector.sort( sortOnPosition );
		}
		
		public function interval( t0: Number, t1: Number ): Vector.<TimeEvent>
		{
			const events: Vector.<TimeEvent> = new Vector.<TimeEvent>();
			
			const n: int = vector.length;
			
			for( var i: int = 0 ; i < n ; ++i )
			{
				var event: TimeEvent = vector[i];
				
				if( event.barPosition >= t1 )
					return events;
				
				if( event.barPosition >= t0 )
				{
					events.push( event );
				}
			}

			return events;
		}
		
		public function get length(): int
		{
			return vector.length;
		}

		private function sortOnPosition( a: TimeEvent, b: TimeEvent ): int
		{
			if( a.barPosition > b.barPosition ) return 1;
			if( a.barPosition < b.barPosition ) return -1;
			return 0;
		}
	}
}