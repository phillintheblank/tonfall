package tonfall.format.wav
{
	import flash.utils.ByteArray;

	/**
	 * @author aM
	 */
	internal final class WAV8BitMono44Khz
		implements IWavDecoderStrategy
	{
		public static const INSTANCE: IWavDecoderStrategy = new WAV8BitMono44Khz();
		
		public function supports( decoder: WavDecoder ) : Boolean
		{
			return 1 == decoder.compression && 8 == decoder.bits && 1 == decoder.numChannels && 44100 == decoder.rate;
		}
		
		public function read( decoder: WavDecoder, target : ByteArray, length : Number, startPosition : Number ) : void
		{
			const offset: uint = decoder.dataOffset;
			const blockAlign : int = decoder.blockAlign;
			const bytes: ByteArray = decoder.bytes;
			
			bytes.position = offset + startPosition * blockAlign;
			
			for ( var i : int = 0 ; i < length ; ++i )
			{
				const amplitude : Number = ( bytes.readUnsignedByte() - 127.5 ) * 0.007843137254902; // DIV 127.5

				target.writeFloat( amplitude );
				target.writeFloat( amplitude );
			}
		}
	}
}
