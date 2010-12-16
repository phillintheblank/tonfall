package tonfall.format.wav
{
	import tonfall.format.IAudioIOStrategy;
	import tonfall.format.pcm.PCM32BitFloatMono44Khz;

	/**
	 * @author Andre Michelle
	 */
	public final class WAV32BitMono44Khz extends PCM32BitFloatMono44Khz
		implements IAudioIOStrategy
	{
		public static const INSTANCE: IAudioIOStrategy = new WAV32BitMono44Khz();
		
		override public function supports( compressionType: *, bits: uint,numChannels: uint, samplingRate: Number ): Boolean
		{
			return 3 == compressionType && 32 == bits && 1 == numChannels && 44100 == samplingRate;
		}
		
		override public function get compressionType(): *
		{
			return 3;
		}
	}
}