package tonfall.format.wav
{
	import tonfall.format.FormatError;
	import tonfall.format.pcm.IPCMIOStrategy;
	import tonfall.format.pcm.PCMDecoder;

	import flash.utils.ByteArray;
	import flash.utils.Endian;

	/**
	 * @author Andre Michelle
	 */
	public final class WavDecoder extends PCMDecoder
	{
		private static const STRATEGIES : Vector.<IWAVIOStrategy> = getSupportedStrategies();

		/*
		 * You can add extra strategies here.
		 * 
		 * Lowest index: Most expected
		 * Highest index: Less expected
		 */
		private static function getSupportedStrategies() : Vector.<IWAVIOStrategy>
		{
			const strategies: Vector.<IWAVIOStrategy> = new Vector.<IWAVIOStrategy>( 8, true );

			strategies[0] = WAV16BitStereo44Khz.INSTANCE;
			strategies[1] = WAV16BitMono44Khz.INSTANCE;
			strategies[2] = WAV32BitStereo44Khz.INSTANCE;
			strategies[3] = WAV32BitMono44Khz.INSTANCE;
			strategies[4] = WAV24BitStereo44Khz.INSTANCE;
			strategies[5] = WAV24BitMono44Khz.INSTANCE;
			strategies[6] = WAV8BitStereo44Khz.INSTANCE;
			strategies[7] = WAV8BitMono44Khz.INSTANCE;
			
			return strategies;
		}
		
		private var _numSamples: Number;
		private var _dataOffset: Number;
		private var _blockAlign: uint;
		
		public function WavDecoder( bytes : ByteArray )
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

		private function evaluateHeader( bytes: ByteArray ) : IPCMIOStrategy
		{
			bytes.position = 0;
			bytes.endian = Endian.LITTLE_ENDIAN;

			if ( bytes.readUnsignedInt() != WavTags.RIFF )
				throw new FormatError( 'RIFF TAG missing', 'WAV' );

			const fileSize : int = bytes.readUnsignedInt();

			if ( bytes.length != fileSize + 8 )
			{
				// Length does not match to wav-specifications
				// I have seen a wav with less before, but worked anyway
				// Skip
			}

			if ( bytes.readUnsignedInt() != WavTags.WAVE )
				throw new FormatError( 'WAVE TAG missing', 'WAV' );

			var chunkID : uint;
			var chunkLength : uint;
			var chunkPosition : uint;
			
			var compressionType: *;
			var numChannels: uint;
			var samplingRate: Number;
			var bits: uint;

			while( 8 <= bytes.bytesAvailable ) // Had a wav with a dead byte at the end (skip)
			{
				chunkID = bytes.readUnsignedInt();
				chunkLength = bytes.readUnsignedInt();
				chunkPosition = bytes.position;

				switch( chunkID )
				{
					case WavTags.FMT:
						compressionType = bytes.readUnsignedShort();
						numChannels = bytes.readUnsignedShort();
						samplingRate = bytes.readUnsignedInt();
						bytes.readUnsignedInt(); // bytesPerSecond (redundant)
						_blockAlign = bytes.readUnsignedShort();
						bits = bytes.readUnsignedShort();
						// WAV allows additional information here (skip)
						break;
						
					case WavTags.DATA:
						// Audio data chunk starts here (skip)
						_dataOffset = chunkPosition;
						_numSamples = chunkLength / _blockAlign;
						break;

					default:
						// WAV allows additional tags to store extra information like markers (skip)
						break;
				}

				// Skip
				bytes.position = chunkPosition + chunkLength;
			}
			
			const n : int = STRATEGIES.length;
			
			for( var i: int = 0 ; i < n ; ++i )
			{
				var strategy: IWAVIOStrategy = STRATEGIES[i];
				
				if ( strategy.supports( compressionType, bits, numChannels, samplingRate ) )
				{
					return strategy;
				}
			}
			
			return null;
		}
	}
}