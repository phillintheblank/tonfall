package tonfall.format.wav
{
	import tonfall.format.AbstractAudioDecoder;
	import tonfall.format.IAudioIOStrategy;
	import tonfall.format.pcm.PCM24BitMono44Khz;

	/**
	 * @author Andre Michelle
	 */
	public final class WAV24BitMono44Khz extends PCM24BitMono44Khz
		implements IAudioIOStrategy
	{
		public static const INSTANCE: IAudioIOStrategy = new WAV24BitMono44Khz();
		
		override public function readableFor( decoder: AbstractAudioDecoder ) : Boolean
		{
			return 1 == decoder.compressionType && 24 == decoder.bits && 1 == decoder.numChannels && 44100 == decoder.samplingRate;
		}
		
		override public function get compressionType(): *
		{
			return 1;
		}
	}
}
