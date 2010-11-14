package tonfall.format.wav
{
	import flash.utils.ByteArray;

	/**
	 * @author Andre Michelle
	 */
	internal final class WAV8BitStereo44Khz
		implements IWavIOStrategy
	{
		public static const INSTANCE: IWavIOStrategy = new WAV8BitStereo44Khz();
		
		public function readableFor( decoder: WavDecoder ) : Boolean
		{
			return 1 == decoder.compression && 8 == decoder.bits && 2 == decoder.numChannels && 44100 == decoder.rate;
		}
		
		public function readData( decoder: WavDecoder, target : ByteArray, length : Number, startPosition : Number ) : void
		{
			const offset: uint = decoder.dataOffset;
			const blockAlign : int = decoder.blockAlign;
			const bytes: ByteArray = decoder.bytes;
			
			bytes.position = offset + startPosition * blockAlign;
						
			for ( var i : int = 0 ; i < length ; ++i )
			{
				target.writeFloat( ( bytes.readUnsignedByte() - 0x7F ) / 0x7F );
				target.writeFloat( ( bytes.readUnsignedByte() - 0x7F ) / 0x7F );
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
			bytes.writeShort( 8 ); // bits
		}
		
		public function writeData( data : ByteArray, target: ByteArray, numSamples : uint ) : void
		{
			for ( var i : int = 0 ; i < numSamples ; ++i )
			{
				const left : Number = data.readFloat();
				
				if( left > 1.0 )
					target.writeByte( 0xFF );
				else
				if( left < -1.0 )
					target.writeByte( 0x00 );
				else
					target.writeByte( left * 0x7F + 0x7F );

				const right : Number = data.readFloat();
				
				if( right > 1.0 )
					target.writeByte( 0xFF );
				else
				if( right < -1.0 )
					target.writeByte( 0x00 );
				else
					target.writeByte( right * 0x7F + 0x7F );
			}
		}
		
		public function get blockAlign() : uint
		{
			return 2;
		}
	}
}
