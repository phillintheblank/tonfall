package tonfall.format.aiff
{
	import tonfall.format.AbstractAudioDecoder;
	import tonfall.format.IAudioIOStrategy;
	import tonfall.format.pcm.PCM8BitStereo44Khz;

	import flash.utils.ByteArray;

	/**
	 * @author Andre Michelle
	 */
	public final class AIFF8BitStereo44Khz extends PCM8BitStereo44Khz
		implements IAudioIOStrategy
	{
		public static const INSTANCE: IAudioIOStrategy = new AIFF8BitStereo44Khz();
		
		override public function readableFor( decoder: AbstractAudioDecoder ) : Boolean
		{
			return ( 'SSND' == decoder.compressionType || 'CHAN' == decoder.compressionType ) && 8 == decoder.bits && 2 == decoder.numChannels && 44100 == decoder.samplingRate;
		}
		
		/**
		 * AIFF 8BIT is signed
		 */
		override public function readData( decoder: AbstractAudioDecoder, target : ByteArray, length : Number, startPosition : Number ) : void
		{
			const bytes: ByteArray = decoder.bytes;

			bytes.position = decoder.dataOffset + ( startPosition << 1 );
			
			for ( var i : int = 0 ; i < length ; ++i )
			{
				target.writeFloat( bytes.readByte() / 0x7F );
				target.writeFloat( bytes.readByte() / 0x7F );
			}
		}

		/**
		 * AIFF 8BIT is signed
		 */
		override public function write32BitStereo44KHz( data : ByteArray, target: ByteArray, numSamples : uint ) : void
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
					target.writeByte( left * 0x7F );

				const right : Number = data.readFloat();
				
				if( right > 1.0 )
					target.writeByte( 0xFF );
				else
				if( right < -1.0 )
					target.writeByte( 0x00 );
				else
					target.writeByte( right * 0x7F );
			}
		}

		override public function writeFormatTag( bytes : ByteArray ) : void
		{
			// TODO
		}
	}
}
