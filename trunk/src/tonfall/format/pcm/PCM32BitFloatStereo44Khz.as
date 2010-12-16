package tonfall.format.pcm
{
	import flash.utils.ByteArray;

	/**
	 * @author Andre Michelle
	 */
	public class PCM32BitFloatStereo44Khz
		implements IPCMIOStrategy
	{
		public function read32BitStereo44KHz( data: ByteArray, dataOffset: Number, target : ByteArray, length : Number, startPosition : Number ) : void
		{
			data.position = dataOffset + ( startPosition << 3 );
			
			for ( var i : int = 0 ; i < length ; ++i )
			{
				target.writeFloat( data.readFloat() );
				target.writeFloat( data.readFloat() );
			}
		}
		
		public function write32BitStereo44KHz( data : ByteArray, target: ByteArray, numSamples : uint ) : void
		{
			for ( var i : int = 0 ; i < numSamples ; ++i )
			{
				target.writeFloat( data.readFloat() );
				target.writeFloat( data.readFloat() );
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
			return 32;
		}
		
		public function get blockAlign() : uint
		{
			return 8;
		}
	}
}
