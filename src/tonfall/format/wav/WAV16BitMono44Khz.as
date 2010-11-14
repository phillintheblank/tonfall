package tonfall.format.wav
{
	import flash.utils.ByteArray;

	/**
	 * @author Andre Michelle
	 */
	public final class WAV16BitMono44Khz
		implements IWavIOStrategy
	{
		public static const INSTANCE: IWavIOStrategy = new WAV16BitMono44Khz();
		
		public function readableFor( decoder: WavDecoder ) : Boolean
		{
			return 1 == decoder.compression && 16 == decoder.bits && 1 == decoder.numChannels && 44100 == decoder.rate;
		}
		
		public function readData( decoder: WavDecoder, target : ByteArray, length : Number, startPosition : Number ) : void
		{
			const offset: uint = decoder.dataOffset;
			const blockAlign : int = decoder.blockAlign;
			const bytes: ByteArray = decoder.bytes;
			
			bytes.position = offset + startPosition * blockAlign;
			
			for ( var i : int = 0 ; i < length ; ++i )
			{
				const amplitude : Number = bytes.readShort() * 3.051850947600e-05; // DIV 0x7FFF

				target.writeFloat( amplitude );
				target.writeFloat( amplitude );
			}
		}

		public function writeFormatTag( bytes : ByteArray ) : void
		{
			bytes.writeUnsignedInt( WavTags.FMT );
			bytes.writeUnsignedInt( 16 ); // chunk length
			bytes.writeShort( 1 ); // compression
			bytes.writeShort( 1 ); // numChannels
			bytes.writeUnsignedInt( 44100 ); // samplingRate
			bytes.writeUnsignedInt( 44100 << 1 ); // bytesPerSecond
			bytes.writeShort( 2 ); // blockAlign
			bytes.writeShort( 16 ); // bits
		}
		
		public function writeData( data : ByteArray, target: ByteArray, numSamples : uint ) : void
		{
			for ( var i : int = 0 ; i < numSamples ; ++i )
			{
				const amplitude : Number = data.readFloat();
				
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
	}
}
