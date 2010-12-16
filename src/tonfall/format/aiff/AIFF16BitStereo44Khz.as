package tonfall.format.aiff
{
	import tonfall.format.IAudioIOStrategy;
	import tonfall.format.pcm.PCM16BitStereo44Khz;

	/**
	 * @author Andre Michelle
	 */
	public final class AIFF16BitStereo44Khz extends PCM16BitStereo44Khz
		implements IAudioIOStrategy
	{
		public static const INSTANCE: IAudioIOStrategy = new AIFF16BitStereo44Khz();
		
		override public function supports( compressionType: *, bits: uint,numChannels: uint, samplingRate: Number ): Boolean
		{
			return ( AiffTags.SSND == compressionType || AiffTags.CHAN == compressionType ) && 16 == bits && 2 == numChannels && 44100 == samplingRate;
		}
		
		override public function get compressionType(): *
		{
			return AiffTags.SSND;
		}
	}
}