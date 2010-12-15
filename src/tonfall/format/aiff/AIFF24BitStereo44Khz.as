package tonfall.format.aiff
{
	import tonfall.format.AudioDecoder;
	import tonfall.format.IAudioIOStrategy;
	import tonfall.format.pcm.PCM24BitStereo44Khz;

	import flash.utils.ByteArray;

	/**
	 * @author Andre Michelle
	 */
	public final class AIFF24BitStereo44Khz extends PCM24BitStereo44Khz
		implements IAudioIOStrategy
	{
		public static const INSTANCE: IAudioIOStrategy = new AIFF24BitStereo44Khz();
		
		override public function readableFor( decoder: AudioDecoder ) : Boolean
		{
			return ( 'SSND' == decoder.compressionType || 'CHAN' == decoder.compressionType ) && 24 == decoder.bits && 2 == decoder.numChannels && 44100 == decoder.samplingRate;
		}
		
		override public function writeFormatTag( bytes : ByteArray ) : void
		{
			// TODO
		}
	}
}