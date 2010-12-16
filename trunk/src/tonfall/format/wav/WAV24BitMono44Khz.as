package tonfall.format.wav
{
	import tonfall.format.pcm.PCM24BitMono44Khz;

	/**
	 * @author Andre Michelle
	 */
	public final class WAV24BitMono44Khz extends PCM24BitMono44Khz
		implements IWAVIOStrategy
	{
		public static const INSTANCE: IWAVIOStrategy = new WAV24BitMono44Khz();
		
		override public function supports( compressionType: *, bits: uint,numChannels: uint, samplingRate: Number ): Boolean
		{
			return 1 == compressionType && 24 == bits && 1 == numChannels && 44100 == samplingRate;
		}
		
		override public function get compressionType(): *
		{
			return 1;
		}
	}
}
