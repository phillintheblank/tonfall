package tonfall.format.wav
{
	import tonfall.format.pcm.PCM16BitMono44Khz;

	/**
	 * @author Andre Michelle
	 */
	public final class WAV16BitMono44Khz extends PCM16BitMono44Khz
		implements IWAVIOStrategy
	{
		public static const INSTANCE: IWAVIOStrategy = new WAV16BitMono44Khz();
		
		override public function supports( compressionType: *, bits: uint,numChannels: uint, samplingRate: Number ): Boolean
		{
			return 1 == compressionType && 16 == bits && 1 == numChannels && 44100 == samplingRate;
		}
		
		override public function get compressionType(): *
		{
			return 1;
		}
	}
}