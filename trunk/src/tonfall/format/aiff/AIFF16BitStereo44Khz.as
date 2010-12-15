package tonfall.format.aiff
{
	import tonfall.format.AbstractAudioDecoder;
	import tonfall.format.IAudioIOStrategy;
	import tonfall.format.pcm.PCM16BitStereo44Khz;

	import flash.utils.ByteArray;

	/**
	 * @author Andre Michelle
	 */
	public final class AIFF16BitStereo44Khz extends PCM16BitStereo44Khz
		implements IAudioIOStrategy
	{
		public static const INSTANCE: IAudioIOStrategy = new AIFF16BitStereo44Khz();
		
		override public function readableFor( decoder: AbstractAudioDecoder ) : Boolean
		{
			return ( 'SSND' == decoder.compressionType || 'CHAN' == decoder.compressionType ) && 16 == decoder.bits && 2 == decoder.numChannels && 44100 == decoder.samplingRate;
		}
		
		override public function writeFormatTag( bytes : ByteArray ) : void
		{
			bytes.writeUTFBytes( AiffTags.COMM );
			bytes.writeShort( 2 ); // numChannels
			bytes.writeUnsignedInt( 0 ); // numSamples
			bytes.writeShort( 16 ); // bits
			// TODO write extended
			bytes.writeUTF( AiffTags.SSND );
			// TODO
		}
	}
}