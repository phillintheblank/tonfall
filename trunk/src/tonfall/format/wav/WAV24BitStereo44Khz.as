package tonfall.format.wav
{
	import tonfall.format.pcm.PCM24BitStereo44Khz;

	/**
	 * @author Andre Michelle
	 */
	public final class WAV24BitStereo44Khz extends PCM24BitStereo44Khz
		implements IWAVIOStrategy
	{
		public static const INSTANCE: IWAVIOStrategy = new WAV24BitStereo44Khz();
		
		override public function supports( compressionType: *, bits: uint,numChannels: uint, samplingRate: Number ): Boolean
		{
			return 1 == compressionType && 24 == bits && 2 == numChannels && 44100 == samplingRate;
		}
		
		override public function get compressionType(): *
		{
			return 1;
		}
	}
}
