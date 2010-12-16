package tonfall.format.pcm
{
	import tonfall.format.IAudioIOStrategy;

	import flash.utils.ByteArray;

	/**
	 * @author Andre Michelle
	 */
	public class PCM32BitFloatStereo44Khz
		implements IAudioIOStrategy
	{
		public function read32BitStereo44KHz( decoder: PCMDecoder, target : ByteArray, length : Number, startPosition : Number ) : void
		{
			const bytes: ByteArray = decoder.bytes;

			bytes.position = decoder.dataOffset + ( startPosition << 3 );
			
			for ( var i : int = 0 ; i < length ; ++i )
			{
				target.writeFloat( bytes.readFloat() );
				target.writeFloat( bytes.readFloat() );
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
