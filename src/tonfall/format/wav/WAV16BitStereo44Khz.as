package tonfall.format.wav
{
	import tonfall.format.AbstractAudioDecoder;
	import tonfall.format.IAudioIOStrategy;
	import tonfall.format.pcm.PCM16BitStereo44Khz;

	/**
	 * @author Andre Michelle
	 */
	public final class WAV16BitStereo44Khz extends PCM16BitStereo44Khz
		implements IAudioIOStrategy
	{
		public static const INSTANCE: IAudioIOStrategy = new WAV16BitStereo44Khz();
		
		override public function readableFor( decoder: AbstractAudioDecoder ) : Boolean
		{
			return 1 == decoder.compressionType && 16 == decoder.bits && 2 == decoder.numChannels && 44100 == decoder.samplingRate;
		}
		
		override public function get compressionType(): *
		{
			return 1;
		}
	}
}
