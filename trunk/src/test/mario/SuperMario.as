package test.mario
{
	import flash.utils.ByteArray;
	import tonfall.core.TimeEventNote;
	import tonfall.core.Processor;

	/**
	 * @author Andre Michelle
	 */
	public final class SuperMario extends Processor
	{
		[ Embed( source='supermario.data', mimeType='application/octet-stream' ) ]
			private static const DATA: Class;
		
		private const events: Vector.<TimeEventNote> = initEvents( new DATA() );

		private function initEvents( stream: ByteArray ): Vector.<TimeEventNote>
		{
			const events: Vector.<TimeEventNote> = new Vector.<TimeEventNote>();
			
			var event: TimeEventNote; 
			
			stream.position = 0;
			
			while( stream.bytesAvailable )
			{
				event = new TimeEventNote();
				event.position = stream.readFloat();
				event.duration = stream.readFloat();
				event.note = stream.readUnsignedByte();
				
				trace( event );
				
				events.push( event );
			}
			
			return events;
		}
		
		public function SuperMario()
		{
		}
	}
}
