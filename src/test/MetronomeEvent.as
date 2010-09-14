package test
{
	/**
	 * @author Andre Michelle
	 */
	public final class MetronomeEvent
	{
		public var position: Number;
		
		public var bar: int;
	
		public var beat: int;
		
		public function toString(): String
		{
			return '[MetronomeEvent position: ' + position + ', bar: ' + bar + ', beat: ' + beat + ']';
		}
	}
}
