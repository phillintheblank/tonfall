package tonfall.core
{

	/**
	 * @author Andre Michelle
	 */
	public final class TimeEventNote extends TimeEvent
	{
		public var note: Number = 60.0;
		
		public var duration: Number = 0.0;
		
		public function toString(): String
		{
			return '[TimeEventNote position: ' + position + ', duration: ' + duration + ', note: ' + note + ']';
		}
	}
}
