package tonfall.format.aiff
{
	import tonfall.data.IeeeExtended;
	import tonfall.format.FormatError;
	import tonfall.format.IAudioIOStrategy;
	import tonfall.format.pcm.PCMDecoder;

	import flash.utils.ByteArray;
	import flash.utils.Endian;

	/**
	 * @author Andre Michelle
	 */
	public final class AiffDecoder extends PCMDecoder
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
		
		private var _numSamples: Number;
		private var _dataOffset: Number;
		private var _blockAlign: uint;
		
		public function AiffDecoder( bytes: ByteArray )
		{
			super( bytes, evaluateHeader( bytes ) );
		}
		
		override public function get numSamples(): Number
		{
			return _numSamples;
		}
		
		override public function get dataOffset(): Number
		{
			return _dataOffset;
		}
		
		override public function get blockAlign(): int
		{
			return _blockAlign;
		}
		
		private function evaluateHeader( bytes: ByteArray ) : IAudioIOStrategy
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
			
			var compressionType: *;
			var numChannels: uint;
			var samplingRate: Number;
			var bits: uint;
			
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
						numChannels  = bytes.readUnsignedShort();
						_numSamples   = bytes.readUnsignedInt();
						bits         = bytes.readUnsignedShort();
						samplingRate = IeeeExtended.inverse( bytes );
						compressionType = bytes.readUTFBytes( 4 );
						
						_blockAlign = ( bits >> 3 ) * numChannels;
						break;

					case AiffTags.SSND:
						_dataOffset = bytes.position;
						break;
						
					default:
						// AIFF allows additional tags to store extra information like markers (skip)
//						ignoredTags.push( ckID );
						break;
				}
				
				ckPosition += ckDataSize;
				
				if( ckPosition >= bytes.length )
				{
					// EOF
					break;
				}
				
				bytes.position = ckPosition;
			}
			
			const n : int = STRATEGIES.length;
			
			for( var i: int = 0 ; i < n ; ++i )
			{
				var strategy: IAudioIOStrategy = STRATEGIES[i];
				
				if ( strategy.supports( compressionType, bits, numChannels, samplingRate ) )
				{
					return strategy;
				}
			}
			
			return null;
		}
	}
}