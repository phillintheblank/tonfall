package tonfall.format.wav
{
	import flash.utils.ByteArray;

	/**
	 * @author aM
	 */
	internal final class WAV8BitStereo44Khz
		implements IWavIOStrategy
	{
		public static const INSTANCE: IWavIOStrategy = new WAV8BitStereo44Khz();
		
		public function canDecode( decoder: WavDecoder ) : Boolean
		{
			return 1 == decoder.compression && 8 == decoder.bits && 2 == decoder.numChannels && 44100 == decoder.rate;
		}
		
		public function read( decoder: WavDecoder, target : ByteArray, length : Number, startPosition : Number ) : void
		{
			const offset: uint = decoder.dataOffset;
			const blockAlign : int = decoder.blockAlign;
			const bytes: ByteArray = decoder.bytes;
			
			bytes.position = offset + startPosition * blockAlign;
						
			for ( var i : int = 0 ; i < length ; ++i )
			{
				target.writeFloat( ( bytes.readUnsignedByte() - 127.5 ) * 0.007843137254902 ); // DIV 127.5
				target.writeFloat( ( bytes.readUnsignedByte() - 127.5 ) * 0.007843137254902 ); // DIV 127.5
			}
		}
	}
}
