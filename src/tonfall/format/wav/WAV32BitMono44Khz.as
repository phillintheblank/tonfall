package tonfall.format.wav
{
	import tonfall.format.pcm.PCM32BitMono44Khz;
	import tonfall.format.AbstractAudioDecoder;
	import tonfall.format.IAudioIOStrategy;

	import flash.utils.ByteArray;

	/**
	 * @author Andre Michelle
	 */
	public final class WAV32BitMono44Khz extends PCM32BitMono44Khz
		implements IAudioIOStrategy
	{
		public static const INSTANCE: IAudioIOStrategy = new WAV32BitMono44Khz();
		
		override public function readableFor( decoder: AbstractAudioDecoder ) : Boolean
		{
			return 3 == decoder.compressionType && 32 == decoder.bits && 1 == decoder.numChannels && 44100 == decoder.samplingRate;
		}
		
		override public function writeFormatTag( bytes : ByteArray ) : void
		{
			bytes.writeUnsignedInt( WavTags.FMT );
			bytes.writeUnsignedInt( 16 ); // chunk length
			bytes.writeShort( 3 ); // compression
			bytes.writeShort( 1 ); // numChannels
			bytes.writeUnsignedInt( 44100 ); // samplingRate
			bytes.writeUnsignedInt( 44100 << 2 ); // bytesPerSecond
			bytes.writeShort( 4 ); // blockAlign
			bytes.writeShort( 32 ); // bits
		}
	}
}