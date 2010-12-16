package tonfall.format.aiff
{
	import tonfall.format.IAudioIOStrategy;
	import tonfall.format.pcm.PCM24BitStereo44Khz;

	/**
	 * @author Andre Michelle
	 */
	public final class AIFF24BitStereo44Khz extends PCM24BitStereo44Khz
		implements IAudioIOStrategy
	{
		public static const INSTANCE: IAudioIOStrategy = new AIFF24BitStereo44Khz();
		
		override public function supports( compressionType: *, bits: uint,numChannels: uint, samplingRate: Number ): Boolean
		{
			return ( AiffTags.SSND == compressionType || AiffTags.CHAN == compressionType ) && 24 == bits && 2 == numChannels && 44100 == samplingRate;
		}
		
		override public function get compressionType(): *
		{
			return AiffTags.SSND;
		}
	}
}