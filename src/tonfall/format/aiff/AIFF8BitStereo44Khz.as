package tonfall.format.aiff
{
	import tonfall.format.AbstractAudioDecoder;
	import tonfall.format.IAudioIOStrategy;
	import tonfall.format.pcm.PCM8BitStereo44Khz;

	import flash.utils.ByteArray;

	/**
	 * @author Andre Michelle
	 */
	public final class AIFF8BitStereo44Khz extends PCM8BitStereo44Khz
		implements IAudioIOStrategy
	{
		public static const INSTANCE: IAudioIOStrategy = new AIFF8BitStereo44Khz();

		public function AIFF8BitStereo44Khz()
		{
			super( true );
		}
		
		override public function readableFor( decoder: AbstractAudioDecoder ) : Boolean
		{
			return ( 'SSND' == decoder.compressionType || 'CHAN' == decoder.compressionType ) && 8 == decoder.bits && 2 == decoder.numChannels && 44100 == decoder.samplingRate;
		}
		
		override public function writeFormatTag( bytes : ByteArray ) : void
		{
			// TODO
		}
	}
}
