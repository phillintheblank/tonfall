package tonfall.format.wav
{
	import flash.utils.ByteArray;

	/**
	 * @author Andre Michelle
	 */
	public final class WAV8BitMono44Khz
		implements IWavIOStrategy
	{
		public static const INSTANCE: IWavIOStrategy = new WAV8BitMono44Khz();
		
		public function readableFor( decoder: WavDecoder ) : Boolean
		{
			return 1 == decoder.compression && 8 == decoder.bits && 1 == decoder.numChannels && 44100 == decoder.rate;
		}
		
		public function readData( decoder: WavDecoder, target : ByteArray, length : Number, startPosition : Number ) : void
		{
			const offset: uint = decoder.dataOffset;
			const blockAlign : int = decoder.blockAlign;
			const bytes: ByteArray = decoder.bytes;
			
			bytes.position = offset + startPosition * blockAlign;
			
			for ( var i : int = 0 ; i < length ; ++i )
			{
				const amplitude : Number = ( bytes.readUnsignedByte() - 0x7F ) / 0x7F;

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
			bytes.writeUnsignedInt( 44100 ); // bytesPerSecond
			bytes.writeShort( 1 ); // blockAlign
			bytes.writeShort( 8 ); // bits
		}
		
		public function writeData( data : ByteArray, target: ByteArray, numSamples : uint ) : void
		{
			for ( var i : int = 0 ; i < numSamples ; ++i )
			{
				const amplitude : Number = data.readFloat();
				
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
	}
}
