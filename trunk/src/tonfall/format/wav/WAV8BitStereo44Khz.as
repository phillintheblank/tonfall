package tonfall.format.wav
{
	import tonfall.format.IAudioIOStrategy;
	import tonfall.format.pcm.PCM8BitStereo44Khz;

	/**
	 * @author Andre Michelle
	 */
	public final class WAV8BitStereo44Khz extends PCM8BitStereo44Khz
		implements IAudioIOStrategy
	{
		public static const INSTANCE: IAudioIOStrategy = new WAV8BitStereo44Khz();

		public function WAV8BitStereo44Khz()
		{
			super( false );
		}
		
		override public function supports( compressionType: *, bits: uint,numChannels: uint, samplingRate: Number ): Boolean
		{
			return 1 == compressionType && 8 == bits && 2 == numChannels && 44100 == samplingRate;
		}
		
		override public function get compressionType(): *
		{
			return 1;
		}
	}
}
