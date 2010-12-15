package tonfall.format.wav
{
	import tonfall.format.AudioDecoder;
	import tonfall.format.IAudioIOStrategy;
	import tonfall.format.pcm.PCM24BitStereo44Khz;

	import flash.utils.ByteArray;

	/**
	 * @author Andre Michelle
	 */
	public final class WAV24BitStereo44Khz extends PCM24BitStereo44Khz
		implements IAudioIOStrategy
	{
		public static const INSTANCE: IAudioIOStrategy = new WAV24BitStereo44Khz();
		
		override public function readableFor( decoder: AudioDecoder ) : Boolean
		{
			return 1 == decoder.compressionType && 24 == decoder.bits && 2 == decoder.numChannels && 44100 == decoder.samplingRate;
		}
		
		override public function writeFormatTag( bytes : ByteArray ) : void
		{
			bytes.writeUnsignedInt( WavTags.FMT );
			bytes.writeUnsignedInt( 16 ); // chunk length
			bytes.writeShort( 1 ); // compression
			bytes.writeShort( 2 ); // numChannels
			bytes.writeUnsignedInt( 44100 ); // samplingRate
			bytes.writeUnsignedInt( 44100 * 6 ); // bytesPerSecond
			bytes.writeShort( 6 ); // blockAlign
			bytes.writeShort( 24 ); // bits
		}
	}
}
