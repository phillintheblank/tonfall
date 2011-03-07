package assets
{
	import tonfall.format.wav.WAVDecoder;
	/**
	 * @author Andre Michelle
	 */
	public final class AmenBreakSample
	{
		[ Embed( source='../../assets/amenbreak.wav', mimeType='application/octet-stream' ) ]
			private static const CLASS: Class;
			
		public static const INSTANCE: WAVDecoder = new WAVDecoder( new CLASS() );
	}
}
