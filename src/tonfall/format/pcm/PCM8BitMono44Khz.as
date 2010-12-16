package tonfall.format.pcm
{
	import flash.utils.ByteArray;

	/**
	 * @author Andre Michelle
	 */
	public class PCM8BitMono44Khz
		implements IPCMIOStrategy
	{
		private var _signed: Boolean;

		public function PCM8BitMono44Khz( signed: Boolean )
		{
			_signed = signed;
		}

		public function read32BitStereo44KHz( data: ByteArray, dataOffset: Number, target : ByteArray, length : Number, startPosition : Number ) : void
		{
			data.position = dataOffset + startPosition;
			
			var amplitude : Number;
			
			var i : int;
			
			if( _signed )
			{
				for ( i = 0 ; i < length ; ++i )
				{
					amplitude = data.readByte() / 0x7F;
	
					target.writeFloat( amplitude );
					target.writeFloat( amplitude );
				}
			}
			else
			{
				for ( i = 0 ; i < length ; ++i )
				{
					amplitude = ( data.readUnsignedByte() - 0x7F ) / 0x7F;
	
					target.writeFloat( amplitude );
					target.writeFloat( amplitude );
				}
			}
		}
		
		public function write32BitStereo44KHz( data : ByteArray, target: ByteArray, numSamples : uint ) : void
		{
			var amplitude : Number;
			
			var i : int;
			
			if( _signed )
			{
				for ( i = 0 ; i < numSamples ; ++i )
				{
					amplitude = ( data.readFloat() + data.readFloat() ) * 0.5;
					
					if( amplitude > 1.0 )
						target.writeByte( 0x7F );
					else
					if( amplitude < -1.0 )
						target.writeByte( -0x7F );
					else
						target.writeByte( amplitude * 0x7F );
				}
			}
			else
			{
				for ( i = 0 ; i < numSamples ; ++i )
				{
					amplitude = ( data.readFloat() + data.readFloat() ) * 0.5;
					
					if( amplitude > 1.0 )
						target.writeByte( 0xFF );
					else
					if( amplitude < -1.0 )
						target.writeByte( 0x00 );
					else
						target.writeByte( amplitude * 0x7F + 0x7F );
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
			return 1;
		}

		public function get bits(): int
		{
			return 8;
		}
		
		public function get blockAlign() : uint
		{
			return 1;
		}
	}
}
