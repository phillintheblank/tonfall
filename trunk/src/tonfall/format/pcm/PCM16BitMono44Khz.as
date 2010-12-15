package tonfall.format.pcm
{
	import tonfall.format.AbstractAudioDecoder;
	import tonfall.format.IAudioIOStrategy;

	import flash.utils.ByteArray;

	/**
	 * @author Andre Michelle
	 */
	public class PCM16BitMono44Khz
		implements IAudioIOStrategy
	{
		public function readData( decoder: AbstractAudioDecoder, target : ByteArray, length : Number, startPosition : Number ) : void
		{
			const bytes: ByteArray = decoder.bytes;

			bytes.position = decoder.dataOffset + ( startPosition << 1 );
			
			for ( var i : int = 0 ; i < length ; ++i )
			{
				const amplitude : Number = bytes.readShort() * 3.051850947600e-05; // DIV 0x7FFF

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
					target.writeShort( 0x7FFF );
				else
				if( amplitude < -1.0 )
					target.writeShort( -0x7FFF );
				else
					target.writeShort( amplitude * 0x7FFF );
			}
		}
		
		public function get blockAlign() : uint
		{
			return 2;
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
			return 1;
		}

		public function get bits(): int
		{
			return 16;
		}
	}
}
