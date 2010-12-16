package tonfall.format.aiff
{
	import tonfall.data.IeeeExtended;
	import tonfall.format.AbstractAudioDecoder;
	import tonfall.format.FormatError;
	import tonfall.format.IAudioIOStrategy;

	import flash.utils.ByteArray;
	import flash.utils.Endian;

	/**
	 * @author Andre Michelle
	 */
	public final class AiffDecoder extends AbstractAudioDecoder
	{
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
		
		public function AiffDecoder( bytes: ByteArray )
		{
			super( bytes, STRATEGIES );
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
			
			if( ckID != AiffTags.FORM )
			{
				throw new FormatError( 'FORM TAG missing', 'AIFF' );
				return;
			}
			
			if( ckDataSize != bytes.length - 8 ) // SUBTRACT ID & SIZE
			{
				throw new FormatError( 'Wrong size', 'AIFF' );
				return;
			}
			
			const formType: String = bytes.readUTFBytes( 4 );
			
			if( formType != AiffTags.AIFF )
			{
				throw new FormatError( 'AIFF TAG missing', 'AIFF' );
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
					case AiffTags.COMM:
						_numChannels  = bytes.readUnsignedShort();
						_numSamples   = bytes.readUnsignedInt();
						_bits         = bytes.readUnsignedShort();
						_samplingRate = IeeeExtended.inverse( bytes );
						_compressionType = bytes.readUTFBytes( 4 );
						
						_blockAlign = ( _bits >> 3 ) * _numChannels;
						break;
						
					case AiffTags.SSND:
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
					//trace( 'EOF', ckPosition - bytes.length );
					return;
				}
				
				bytes.position = ckPosition;
			}
		}
	}
}