package tonfall.format.wav
{
	import tonfall.format.AbstractAudioDecoder;
	import tonfall.format.IAudioIOStrategy;

	import flash.utils.ByteArray;
	import flash.utils.Endian;

	/**
	 * @author Andre Michelle
	 */
	public final class WavDecoder extends AbstractAudioDecoder
	{
		private static const NO_WAVE_FILE: Error = new Error( 'Not a wav-file.' );
		
		private static const STRATEGIES : Vector.<IAudioIOStrategy> = getSupportedStrategies();

		/*
		 * You can add extra strategies here.
		 * 
		 * Lowest index: Most expected
		 * Highest index: Less expected
		 */
		private static function getSupportedStrategies() : Vector.<IAudioIOStrategy>
		{
			const strategies: Vector.<IAudioIOStrategy> = new Vector.<IAudioIOStrategy>( 8, true );

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
		
		private var _bytesPerSecond : int;

		public function WavDecoder( bytes : ByteArray )
		{
			super( bytes, STRATEGIES );
		}

		public function get bytesPerSecond() : int
		{
			return _bytesPerSecond;
		}
		
		public function toString() : String
		{
			return '[WavFormat compression: ' + _compressionType + ', bytesPerSecond: ' + _bytesPerSecond + ', blockAlign: ' + _blockAlign + ']';
		}
		
		override protected function parseHeader( bytes: ByteArray ) : void
		{
			bytes.position = 0;
			bytes.endian = Endian.LITTLE_ENDIAN;

			if ( bytes.readUnsignedInt() != WavTags.RIFF )
				throw NO_WAVE_FILE;

			const fileSize : int = bytes.readUnsignedInt();

			if ( bytes.length != fileSize + 8 )
			{
				// Length does not match to wav-specifications
				// I have seen a wav with less before, but worked anyway
				// Skip
			}

			if ( bytes.readUnsignedInt() != WavTags.WAVE )
				throw NO_WAVE_FILE;

			var chunkID : uint;
			var chunkLength : uint;
			var chunkPosition : uint;

			while( 8 <= bytes.bytesAvailable ) // Had a wav with a dead byte at the end (skip)
			{
				chunkID = bytes.readUnsignedInt();
				chunkLength = bytes.readUnsignedInt();
				chunkPosition = bytes.position;

				switch( chunkID )
				{
					case WavTags.FMT:
						_compressionType = bytes.readUnsignedShort();
						_numChannels = bytes.readUnsignedShort();
						_samplingRate = bytes.readUnsignedInt();
						_bytesPerSecond = bytes.readUnsignedInt();
						_blockAlign = bytes.readUnsignedShort();
						_bits = bytes.readUnsignedShort();
						// WAV allows additional information here (skip)
						break;
						
					case WavTags.DATA:
						// Audio data chunk starts here (skip)
						_dataOffset = chunkPosition;
						_numSamples = chunkLength / _blockAlign;
						break;

					default:
						// WAV allows additional tags to store extra information like markers (skip)
						ignoredTags.push(
							String.fromCharCode(
								chunkID & 0xFF,
								( chunkID >> 8 ) & 0xFF,
								( chunkID >> 16 ) & 0xFF,
								( chunkID >> 24 ) & 0xFF )
							);
						break;
				}

				// Skip
				bytes.position = chunkPosition + chunkLength;
			}
		}
	}
}