package tonfall.format.pcm
{
	import flash.utils.ByteArray;

	/**
	 * @author Andre Michelle
	 */
	public class PCM32BitIntMono44Khz
		implements IPCMIOStrategy
	{
		public function read32BitStereo44KHz( data: ByteArray, dataOffset: Number, target : ByteArray, length : Number, startPosition : Number ) : void
		{
			data.position = dataOffset + ( startPosition << 2 );
			
			for ( var i : int = 0 ; i < length ; ++i )
			{
				const amplitude: Number = data.readInt() / 0x7FFFFFFF;
				
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
					target.writeInt( 0x7FFFFFFF );
				else
				if( amplitude < -1.0 )
					target.writeInt( -0x7FFFFFFF );
				else
					target.writeInt( amplitude * 0x7FFFFFFF );
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
			return 32;
		}
		
		public function get blockAlign() : uint
		{
			return 4;
		}
	}
}
