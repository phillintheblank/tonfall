package tonfall.format.pcm
{
	import tonfall.format.AudioDecoder;
	import tonfall.format.IAudioIOStrategy;

	import flash.utils.ByteArray;

	/**
	 * @author Andre Michelle
	 */
	public class PCM8BitStereo44Khz
		implements IAudioIOStrategy
	{
		public function readData( decoder: AudioDecoder, target : ByteArray, length : Number, startPosition : Number ) : void
		{
			const bytes: ByteArray = decoder.bytes;

			bytes.position = decoder.dataOffset + ( startPosition << 1 );
			
			for ( var i : int = 0 ; i < length ; ++i )
			{
				target.writeFloat( ( bytes.readUnsignedByte() - 0x7F ) / 0x7F );
				target.writeFloat( ( bytes.readUnsignedByte() - 0x7F ) / 0x7F );
			}
		}
		
		public function write32BitStereo44KHz( data : ByteArray, target: ByteArray, numSamples : uint ) : void
		{
			for ( var i : int = 0 ; i < numSamples ; ++i )
			{
				const left : Number = data.readFloat();
				
				if( left > 1.0 )
					target.writeByte( 0xFF );
				else
				if( left < -1.0 )
					target.writeByte( 0x00 );
				else
					target.writeByte( left * 0x7F + 0x7F );

				const right : Number = data.readFloat();
				
				if( right > 1.0 )
					target.writeByte( 0xFF );
				else
				if( right < -1.0 )
					target.writeByte( 0x00 );
				else
					target.writeByte( right * 0x7F + 0x7F );
			}
		}
		
		public function get blockAlign() : uint
		{
			return 2;
		}
		
		public function readableFor( decoder: AudioDecoder ): Boolean
		{
			// No proper check possible
			return true;
		}

		public function writeFormatTag( bytes: ByteArray ): void
		{
			// No Header
		}
	}
}
