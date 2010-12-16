package tonfall.format.pcm
{
	import tonfall.format.IAudioIOStrategy;

	import flash.utils.ByteArray;

	/**
	 * @author Andre Michelle
	 */
	public class PCM8BitStereo44Khz
		implements IAudioIOStrategy
	{
		private var _signed: Boolean;

		public function PCM8BitStereo44Khz( signed: Boolean )
		{
			_signed = signed;
		}

		public function read32BitStereo44KHz( data: ByteArray, dataOffset: Number, target : ByteArray, length : Number, startPosition : Number ) : void
		{
			data.position = dataOffset + ( startPosition << 1 );
			
			var i : int;
			
			if( _signed )
			{
				for ( i = 0 ; i < length ; ++i )
				{
					target.writeFloat( data.readByte() / 0x7F );
					target.writeFloat( data.readByte() / 0x7F );
				}
			}
			else
			{
				for ( i = 0 ; i < length ; ++i )
				{
					target.writeFloat( ( data.readUnsignedByte() - 0x7F ) / 0x7F );
					target.writeFloat( ( data.readUnsignedByte() - 0x7F ) / 0x7F );
				}
			}
		}
		
		public function write32BitStereo44KHz( data : ByteArray, target: ByteArray, numSamples : uint ) : void
		{
			var left : Number;
			var right : Number;
			
			var i : int;
			
			if( _signed )
			{
				for ( i = 0 ; i < numSamples ; ++i )
				{
					left = data.readFloat();
					
					if( left > 1.0 )
						target.writeByte( 0x7F );
					else
					if( left < -1.0 )
						target.writeByte( -0x7F );
					else
						target.writeByte( left * 0x7F );
	
					right = data.readFloat();
					
					if( right > 1.0 )
						target.writeByte( 0x7F );
					else
					if( right < -1.0 )
						target.writeByte( -0x7F );
					else
						target.writeByte( right * 0x7F );
				}
			}
			else
			{
				for ( i = 0 ; i < numSamples ; ++i )
				{
					left = data.readFloat();
					
					if( left > 1.0 )
						target.writeByte( 0xFF );
					else
					if( left < -1.0 )
						target.writeByte( 0x00 );
					else
						target.writeByte( left * 0x7F + 0x7F );
	
					right = data.readFloat();
					
					if( right > 1.0 )
						target.writeByte( 0xFF );
					else
					if( right < -1.0 )
						target.writeByte( 0x00 );
					else
						target.writeByte( right * 0x7F + 0x7F );
				}
			}
		}
		
		public function supports( compressionType: *, bits: uint,numChannels: uint, samplingRate: Number ): Boolean
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
			return 8;
		}
		
		public function get blockAlign() : uint
		{
			return 2;
		}
	}
}
