package tonfall.format.midi
{
	import tonfall.core.BlockInfo;
	import tonfall.core.Processor;
	import tonfall.core.TimeEvent;
	import tonfall.core.TimeEventContainer;

	/**
	 * @author Andre Michelle
	 */
	public final class MidiNoteSequencer extends Processor
	{
		private var _timeEventTarget: Processor;
		private var _container: TimeEventContainer;

		public function MidiNoteSequencer( container: TimeEventContainer )
		{
			_container = container;
		}
		
		override public function process( info: BlockInfo ): void
		{
			const events: Vector.<TimeEvent> = _container.interval( info.barFrom, info.barTo );
			
			const n: int = events.length;
			
			for( var i: int = 0 ; i < n ; ++i )
			{
				_timeEventTarget.addTimeEvent( events[i] );
			}
		}

		public function set timeEventTarget( value: Processor ): void
		{
			_timeEventTarget = value;
		}

		public function get timeEventTarget(): Processor
		{
			return _timeEventTarget;
		}
	}
}