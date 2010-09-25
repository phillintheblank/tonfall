package test.mario
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
	public final class SuperMario extends Processor
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
				event.position = stream.readFloat();
				event.duration = stream.readFloat();
				event.note = stream.readUnsignedByte() + 12.0;

				notes[i] = event;
			}
			
			return notes;
		}
		
		private var _timeEventTarget: Processor;
		
		public function SuperMario() {}
		
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
				
				if( event.position >= info.to )
					break;
				
				if( event.position >= info.from )
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
