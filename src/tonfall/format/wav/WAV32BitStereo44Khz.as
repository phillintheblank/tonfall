package tonfall.format.wav
{
	import flash.utils.ByteArray;

	/**
	 * @author Andre Michelle
	 */
	internal final class WAV32BitStereo44Khz
		implements IWavIOStrategy
	{
		public static const INSTANCE: IWavIOStrategy = new WAV32BitStereo44Khz();
		
		public function readableFor( decoder: WavDecoder ) : Boolean
		{
			return 3 == decoder.compression && 32 == decoder.bits && 2 == decoder.numChannels && 44100 == decoder.rate;
		}
		
		public function readData( decoder: WavDecoder, target : ByteArray, length : Number, startPosition : Number ) : void
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
		
		public function writeFormatTag( bytes : ByteArray ) : void
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

		public function writeData( data : ByteArray, target: ByteArray, numSamples : uint ) : void
		{
			for ( var i : int = 0 ; i < numSamples ; ++i )
			{
				target.writeFloat( data.readFloat() );
				target.writeFloat( data.readFloat() );
			}
		}
		
		public function get blockAlign() : uint
		{
			return 8;
		}
	}
}