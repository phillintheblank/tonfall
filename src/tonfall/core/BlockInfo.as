package tonfall.core
{
	/**
	 * BlockInfo describes all time information to process a single audio block
	 * 
	 * @author Andre Michelle
	 */
	public final class BlockInfo
	{
		private var _numSignals: int;

		// Following values in musical time (bars)
		private var _barFrom: Number;
		private var _barTo: Number;
		
		internal function reset( numSignals: int, from: Number, to: Number ): void
		{
			_numSignals = numSignals;
			_barFrom = from;
			_barTo = to;
		}

		public function get numSignals() : int
		{
			return _numSignals;
		}

		public function get barFrom() : Number
		{
			return _barFrom;
		}

		public function get barTo() : Number
		{
			return _barTo;
		}
		
		public function toString(): String
		{
			return '[BlockInfo numSignals: ' + _numSignals + ', barFrom: ' + _barFrom.toFixed(3) + ', barTo: ' + _barTo.toFixed(3) + ']';
		}
	}
}