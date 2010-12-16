package tonfall.format.wav
{
	import tonfall.format.AbstractAudioDecoder;
	import tonfall.format.IAudioIOStrategy;
	import tonfall.format.pcm.PCM32BitFloatStereo44Khz;

	/**
	 * @author Andre Michelle
	 */
	public final class WAV32BitStereo44Khz extends PCM32BitFloatStereo44Khz
		implements IAudioIOStrategy
	{
		public static const INSTANCE: IAudioIOStrategy = new WAV32BitStereo44Khz();
		
		override public function readableFor( decoder: AbstractAudioDecoder ) : Boolean
		{
			return 3 == decoder.compressionType && 32 == decoder.bits && 2 == decoder.numChannels && 44100 == decoder.samplingRate;
		}
		
		override public function get compressionType(): *
		{
			return 3;
		}
	}
}