package tonfall.format.wav
{
	import flash.utils.ByteArray;

	/**
	 * @author aM
	 */
	internal final class WAV32BitMono44Khz
		implements IWavDecoderStrategy
	{
		public static const INSTANCE: IWavDecoderStrategy = new WAV32BitMono44Khz();
		
		public function supports( decoder: WavDecoder ) : Boolean
		{
			return 3 == decoder.compression && 32 == decoder.bits && 1 == decoder.numChannels && 44100 == decoder.rate;
		}
		
		public function read( decoder: WavDecoder, target : ByteArray, length : Number, startPosition : Number ) : void
		{
			const offset: uint = decoder.dataOffset;
			const blockAlign : int = decoder.blockAlign;
			const bytes: ByteArray = decoder.bytes;
			
			bytes.position = offset + startPosition * blockAlign;
			
			for ( var i : int = 0 ; i < length ; ++i )
			{
				const amplitude: Number = bytes.readFloat();
				
				target.writeFloat( amplitude );
				target.writeFloat( amplitude );
			}
		}
	}
}