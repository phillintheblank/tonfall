package tonfall.format.wav
{
	import tonfall.format.AudioDecoder;
	import tonfall.format.IAudioIOStrategy;
	import tonfall.format.pcm.PCM32BitStereo44Khz;

	import flash.utils.ByteArray;

	/**
	 * @author Andre Michelle
	 */
	public final class WAV32BitStereo44Khz extends PCM32BitStereo44Khz
		implements IAudioIOStrategy
	{
		public static const INSTANCE: IAudioIOStrategy = new WAV32BitStereo44Khz();
		
		override public function readableFor( decoder: AudioDecoder ) : Boolean
		{
			return 3 == decoder.compressionType && 32 == decoder.bits && 2 == decoder.numChannels && 44100 == decoder.samplingRate;
		}
		
		override public function writeFormatTag( bytes : ByteArray ) : void
		{
			bytes.writeUnsignedInt( WavTags.FMT );
			bytes.writeUnsignedInt( 16 ); // chunk length
			bytes.writeShort( 3 ); // compression
			bytes.writeShort( 2 ); // numChannels
			bytes.writeUnsignedInt( 44100 ); // samplingRate
			bytes.writeUnsignedInt( 44100 << 3 ); // bytesPerSecond
			bytes.writeShort( 8 ); // blockAlign
			bytes.writeShort( 32 ); // bits
		}
	}
}