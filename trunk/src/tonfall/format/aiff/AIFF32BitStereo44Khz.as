package tonfall.format.aiff
{
	import tonfall.format.AbstractAudioDecoder;
	import tonfall.format.IAudioIOStrategy;
	import tonfall.format.pcm.PCM32BitStereo44Khz;

	import flash.utils.ByteArray;

	/**
	 * @author Andre Michelle
	 */
	public final class AIFF32BitStereo44Khz extends PCM32BitStereo44Khz
		implements IAudioIOStrategy
	{
		public static const INSTANCE: IAudioIOStrategy = new AIFF32BitStereo44Khz();
		
		override public function readableFor( decoder: AbstractAudioDecoder ) : Boolean
		{
			return ( 'SSND' == decoder.compressionType || 'CHAN' == decoder.compressionType ) && 32 == decoder.bits && 2 == decoder.numChannels && 44100 == decoder.samplingRate;
		}
		
		override public function writeFormatTag( bytes : ByteArray ) : void
		{
			// TODO
		}
	}
}