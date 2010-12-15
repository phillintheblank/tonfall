package tonfall.format.pcm
{
	import tonfall.format.AbstractAudioDecoder;
	import tonfall.format.IAudioIOStrategy;

	import flash.utils.ByteArray;
	import flash.utils.Endian;

	/**
	 * @author Andre Michelle
	 */
	public class PCM24BitStereo44Khz
		implements IAudioIOStrategy
	{
		private static const bytes: ByteArray = createByteArray();

		private static function createByteArray(): ByteArray
		{
			const bytes: ByteArray = new ByteArray();
			
			bytes.endian = Endian.LITTLE_ENDIAN;
			bytes.length = 4;
			
			return bytes;
		}
		
		public function readData( decoder: AbstractAudioDecoder, target : ByteArray, length : Number, startPosition : Number ) : void
		{
			const bytes: ByteArray = decoder.bytes;

			bytes.position = decoder.dataOffset + startPosition * 6;
			
			for ( var i : int = 0 ; i < length ; ++i )
			{
				target.writeFloat( int( ( bytes.readUnsignedByte() << 8 | bytes.readUnsignedByte() << 16 | bytes.readUnsignedByte() << 24 ) ) * 0.000000000465661 ); // DIV 0x80000000
				target.writeFloat( int( ( bytes.readUnsignedByte() << 8 | bytes.readUnsignedByte() << 16 | bytes.readUnsignedByte() << 24 ) ) * 0.000000000465661 ); // DIV 0x80000000
			}
		}

		public function write32BitStereo44KHz( data : ByteArray, target: ByteArray, numSamples : uint ) : void
		{
			for ( var i : int = 0 ; i < numSamples ; ++i )
			{
				const left : Number = data.readFloat();
				
				bytes.position = 0;
				
				if( left > 1.0 )
					bytes.writeInt( 0x7FFFFFFF );
				else
				if( left < -1.0 )
					bytes.writeInt( 0x80000000 );
				else
					bytes.writeInt( left * 0x80000000 );

				target.writeBytes( bytes, 1, 3 );
				
				const right : Number = data.readFloat();
				
				bytes.position = 0;
				
				if( right > 1.0 )
					bytes.writeInt( 0x7FFFFFFF );
				else
				if( right < -1.0 )
					bytes.writeInt( 0x80000000 );
				else
					bytes.writeInt( right * 0x80000000 );

				target.writeBytes( bytes, 1, 3 );
			}
		}
		
		public function readableFor( decoder: AbstractAudioDecoder ): Boolean
		{
			// No proper check possible
			return true;
		}

		public function get compressionType(): *
		{
			return null;
		}

		public function get samplingRate(): Number
		{
			return 44100.0;
		}

		public function get numChannels(): int
		{
			return 2;
		}

		public function get bits(): int
		{
			return 24;
		}
		
		public function get blockAlign() : uint
		{
			return 6;
		}
	}
}
