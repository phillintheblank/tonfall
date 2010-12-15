package tonfall.format.pcm
{
	/**
	 * @author Andre Michelle
	 */
	public class PCMIOStrategy
	{
		private var _blockAlign: int;
		
		public function PCMIOStrategy( blockAlign: int )
		{
			_blockAlign = blockAlign;
		}

		public function get blockAlign(): int
		{
			return _blockAlign;
		}
	}
}
