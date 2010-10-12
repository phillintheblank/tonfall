package tonfall.core
{

	/**
	 * TimeEventNote describes a note event
	 * 
	 * @author Andre Michelle
	 */
	public final class TimeEventNote extends TimeEvent
	{
		public var note: Number = 60.0;
		
		public var velocity: Number = 1.0;
		
		public var barDuration: Number = 0.0;
		
		public function toString(): String
		{
			return '[TimeEventNote barPosition: ' + barPosition + ', barDuration: ' + barDuration + ', note: ' + note + ', velocity: ' + velocity + ']';
		}
	}
}
