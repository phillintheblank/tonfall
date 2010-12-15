package tonfall.format.wav
{
	import tonfall.format.AbstractAudioDecoder;
	import tonfall.format.IAudioIOStrategy;
	import tonfall.format.pcm.PCM16BitMono44Khz;

	import flash.utils.ByteArray;

	/**
	 * @author Andre Michelle
	 */
	public final class WAV16BitMono44Khz extends PCM16BitMono44Khz
		implements IAudioIOStrategy
	{
		public static const INSTANCE: IAudioIOStrategy = new WAV16BitMono44Khz();
		
		override public function readableFor( decoder: AbstractAudioDecoder ) : Boolean
		{
			return 1 == decoder.compressionType && 16 == decoder.bits && 1 == decoder.numChannels && 44100 == decoder.samplingRate;
		}
		
		override public function writeFormatTag( bytes : ByteArray ) : void
		{
			bytes.writeUnsignedInt( WavTags.FMT );
			bytes.writeUnsignedInt( 16 ); // chunk length
			bytes.writeShort( 1 ); // compression
			bytes.writeShort( 1 ); // numChannels
			bytes.writeUnsignedInt( 44100 ); // samplingRate
			bytes.writeUnsignedInt( 44100 << 1 ); // bytesPerSecond
			bytes.writeShort( 2 ); // blockAlign
			bytes.writeShort( 16 ); // bits
		}
	}
}