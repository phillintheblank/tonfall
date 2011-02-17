package test.supermario
{
	import tonfall.core.BlockInfo;
	import tonfall.core.Processor;
	import tonfall.core.TimeEventNote;

	import flash.utils.ByteArray;

	/**
	 * Transmits notes from the super-mario theme for testing purpose.
	 * 
	 * Happy birthday, Mario!
	 * 
	 * @author Andre Michelle
	 */
	public final class SuperMarioSequencer extends Processor
	{
		private static const NUM_EVENTS: int = 1282;
		
		[ Embed( source='./supermario.data', mimeType='application/octet-stream' ) ]
			private static const DATA: Class;
		
		private static const stream: ByteArray = new DATA();
			
		private static const notes: Vector.<TimeEventNote> = initEvents();
		
		private static function initEvents(): Vector.<TimeEventNote>
		{
			const notes: Vector.<TimeEventNote> = new Vector.<TimeEventNote>( NUM_EVENTS, true );
			
			var event: TimeEventNote; 
			
			stream.position = 0;
			
			for( var i: int = 0 ; i < NUM_EVENTS ; ++i )
			{
				event = new TimeEventNote();
				event.barPosition = int( stream.readFloat() * 16.0 + 0.5 ) / 16.0; // QUANITIZE
				event.barDuration = stream.readFloat();
				event.note = stream.readUnsignedByte() + 12.0;

				notes[i] = event;
			}
			
			return notes;
		}
		
		private var _timeEventTarget: Processor;
		
		public function SuperMarioSequencer() {}
		
		override public function process( info: BlockInfo ) : void
		{
			if( null == _timeEventTarget )
			{
				throw new Error( 'No event target defined.' );
			}
			
			var event: TimeEventNote; 
			
			for( var i: int = 0 ; i < NUM_EVENTS ; ++i )
			{
				event = notes[i];
				
				if( event.barPosition >= info.barTo )
					break;
				
				if( event.barPosition >= info.barFrom )
				{
					_timeEventTarget.addTimeEvent( event );
				}
			}
		}

		public function get timeEventTarget() : Processor
		{
			return _timeEventTarget;
		}

		public function set timeEventTarget( target: Processor ) : void
		{
			_timeEventTarget = target;
		}
	}
}
