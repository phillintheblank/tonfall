package tonfall.format.pcm
{
	import tonfall.format.AudioDecoder;
	import tonfall.format.IAudioIOStrategy;

	import flash.utils.ByteArray;

	/**
	 * @author Andre Michelle
	 */
	public class PCM8BitMono44Khz
		implements IAudioIOStrategy
	{
		public function readData( decoder: AudioDecoder, target : ByteArray, length : Number, startPosition : Number ) : void
		{
			const bytes: ByteArray = decoder.bytes;

			bytes.position = decoder.dataOffset + startPosition;
			
			for ( var i : int = 0 ; i < length ; ++i )
			{
				const amplitude : Number = ( bytes.readUnsignedByte() - 0x7F ) / 0x7F;

				target.writeFloat( amplitude );
				target.writeFloat( amplitude );
			}
		}
		
		public function write32BitStereo44KHz( data : ByteArray, target: ByteArray, numSamples : uint ) : void
		{
			for ( var i : int = 0 ; i < numSamples ; ++i )
			{
				const amplitude : Number = ( data.readFloat() + data.readFloat() ) * 0.5;
				
				if( amplitude > 1.0 )
					target.writeByte( 0xFF );
				else
				if( amplitude < -1.0 )
					target.writeByte( 0x00 );
				else
					target.writeByte( amplitude * 0x7F + 0x7F );
			}
		}
		
		public function get blockAlign() : uint
		{
			return 1;
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
