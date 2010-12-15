package tonfall.format
{
	/**
	 * @author Andre Michelle
	 */
	public final class FormatError extends Error
	{
		public function FormatError( message: String, type: String )
		{
			super( message, type );
		}
	}
}