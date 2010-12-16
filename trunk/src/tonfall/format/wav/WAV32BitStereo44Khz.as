package tonfall.format.wav
{
	import tonfall.format.pcm.PCM32BitFloatStereo44Khz;

	/**
	 * @author Andre Michelle
	 */
	public final class WAV32BitStereo44Khz extends PCM32BitFloatStereo44Khz
		implements IWAVIOStrategy
	{
		public static const INSTANCE: IWAVIOStrategy = new WAV32BitStereo44Khz();
		
		override public function supports( compressionType: *, bits: uint,numChannels: uint, samplingRate: Number ): Boolean
		{
			return 3 == compressionType && 32 == bits && 2 == numChannels && 44100 == samplingRate;
		}
		
		override public function get compressionType(): *
		{
			return 3;
		}
	}
}