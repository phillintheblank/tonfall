package tonfall.format.wav
{
	import flash.utils.ByteArray;

	/**
	 * @author aM
	 */
	internal final class WAV32BitStereo44Khz
		implements IWavIOStrategy
	{
		public static const INSTANCE: IWavIOStrategy = new WAV32BitStereo44Khz();
		
		public function canDecode( decoder: WavDecoder ) : Boolean
		{
			return 3 == decoder.compression && 32 == decoder.bits && 2 == decoder.numChannels && 44100 == decoder.rate;
		}
		
		public function read( decoder: WavDecoder, target : ByteArray, length : Number, startPosition : Number ) : void
		{
			const offset: uint = decoder.dataOffset;
			const blockAlign : int = decoder.blockAlign;
			const bytes: ByteArray = decoder.bytes;
			
			bytes.position = offset + startPosition * blockAlign;
			
			for ( var i : int = 0 ; i < length ; ++i )
			{
				target.writeFloat( bytes.readFloat() );
				target.writeFloat( bytes.readFloat() );
			}
		}
	}
}
