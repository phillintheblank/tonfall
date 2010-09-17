package assets
{
	import tonfall.core.WavSample;
	/**
	 * @author Andre Michelle
	 */
	public final class AmenBreakSample
	{
		[ Embed( source='../../assets/amenbreak.wav', mimeType='application/octet-stream' ) ]
			private static const CLASS: Class;
			
		public static const INSTANCE: WavSample = new WavSample( new CLASS() );
	}
}
