package tonfall.format.aiff
{
	import tonfall.format.AudioDecoder;
	import tonfall.format.IAudioIOStrategy;

	import flash.utils.ByteArray;
	import flash.utils.Endian;

	/**
	 * @author Andre Michelle
	 */
	public final class AiffDecoder extends AudioDecoder
	{
		private static const NO_AIFF_FILE: Error = new Error( 'Not a aiff-file.' );
		
		private static const STRATEGIES : Vector.<IAudioIOStrategy> = getSupportedStrategies();

		/*
		 * You can add extra strategies here.
		 * 
		 * Lowest index: Most expected
		 * Highest index: Less expected
		 */
		private static function getSupportedStrategies() : Vector.<IAudioIOStrategy>
		{
			const strategies: Vector.<IAudioIOStrategy> = new Vector.<IAudioIOStrategy>( 4, true );

			strategies[0] = AIFF16BitStereo44Khz.INSTANCE;
			strategies[1] = AIFF24BitStereo44Khz.INSTANCE;
			strategies[2] = AIFF32BitStereo44Khz.INSTANCE;
			strategies[3] = AIFF8BitStereo44Khz.INSTANCE;
			
			return strategies;
		}
		
		private var _compressionName: String;
		
		public function AiffDecoder( bytes: ByteArray )
		{
			super( bytes, STRATEGIES );
		}
		
		public function get compressionName(): String
		{
			return _compressionName;
		}
		
		public function toString() : String
		{
			return '[AiffFormat compression: ' + _compressionType + ']';
		}
		
		override protected function parseHeader( bytes: ByteArray ) : void
		{
			bytes.endian = Endian.BIG_ENDIAN;
			
			var ckID: String = bytes.readUTFBytes( 4 );
			var ckDataSize: int = bytes.readInt();
			
			if( ckID != 'FORM' )
			{
				throw new Error( 'NO FORM TAG' );
				return;
			}
			
			if( ckDataSize != bytes.length - 8 ) // SUBTRACT ID & SIZE
			{
				throw new Error( 'WRONG SIZE' );
				return;
			}
			
			const formType: String = bytes.readUTFBytes( 4 );
			
			if( formType != 'AIFF' )
			{
				throw NO_AIFF_FILE;
				return;
			}
			
			var ckPosition: uint;
			
			for(;;)
			{
				//-- NEXT CHUNK
				ckID = bytes.readUTFBytes( 4 );
				ckDataSize = bytes.readInt();
				ckPosition = bytes.position;
				
				switch( ckID )
				{
					case 'COMM':
						_numChannels  = bytes.readUnsignedShort();
						_numSamples   = bytes.readUnsignedInt();
						_bits         = bytes.readUnsignedShort();
						_samplingRate = readExtended( bytes );
						_compressionType = bytes.readUTFBytes( 4 );
						_compressionName = readPString( bytes );
						
						_blockAlign = ( _bits >> 3 ) * _numChannels;
						break;
						
					case 'SSND':
						_dataOffset = bytes.position;
						break;
						
					default:
						// AIFF allows additional tags to store extra information like markers (skip)
						ignoredTags.push( ckID );
						break;
				}
				
				ckPosition += ckDataSize;
				
				if( ckPosition >= bytes.length )
				{
					trace( 'EOF', ckPosition - bytes.length );
					return;
				}
				
				bytes.position = ckPosition;
			}
		}
		
		/**
		 * http://www.gotoandlearnforum.com/viewtopic.php?f=29&t=19428
		 */
		private function readExtended( bytes: ByteArray ): uint
		{
			var byte1:uint = bytes.readUnsignedByte();
			var byte2:uint = bytes.readUnsignedByte();
			var bytes3_4:uint = bytes.readUnsignedShort();
			var value:uint = bytes3_4;
			var shift:int = 14 - byte2;
			if (shift > 0) value >>= shift;
			else if (shift < 0) value <<= Math.abs(shift);
			
			bytes.position += 6;
			
			return value;
		}
		
		/**
		 * http://www-mmsp.ece.mcgill.ca/Documents/AudioFormats/AIFF/Docs/AIFF-C.9.26.91.pdf
		 * 
		 * Pascal-style string, one byte count followed by text bytes followed—when needed— by one pad byte.
		 * The total number of bytes in a pstring must be even.The pad byte is included when the number of
		 * text bytes is even, so the total of text bytes + one count byte + one pad byte will be even.
		 * This pad byte is not reflected in the count.
		 */
		private function readPString( bytes: ByteArray ): String
		{
			const count: int = bytes.readUnsignedByte();

			return bytes.readUTFBytes( count + ( count & 1 ) );
		}
	}
}