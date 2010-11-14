package tonfall.format.wav
{
	import tonfall.format.IAudioFormat;

	import flash.utils.ByteArray;
	import flash.utils.Endian;

	/**
	 * @author Andre Michelle
	 */
	public final class WavDecoder
	implements IAudioFormat
	{
		private static const NO_WAVE_FILE: Error = new Error( 'Not a wav-file.' );
		private static const NOT_SUPPORTED : Error = new Error( 'Not supported.' );
		
		private static const SUPPORTED : Vector.<IWavIOStrategy> = getSupportedWavFormats();

		/*
		 * You can add extra strategies here.
		 * 
		 * Lowest index: Most expected
		 * Highest index: Less expected
		 */
		private static function getSupportedWavFormats() : Vector.<IWavIOStrategy>
		{
			const formats: Vector.<IWavIOStrategy> = new Vector.<IWavIOStrategy>( 6, true );

			formats[0] = WAV16BitStereo44Khz.INSTANCE;
			formats[1] = WAV16BitMono44Khz.INSTANCE;
			formats[2] = WAV32BitStereo44Khz.INSTANCE;
			formats[3] = WAV32BitMono44Khz.INSTANCE;
			formats[4] = WAV8BitStereo44Khz.INSTANCE;
			formats[5] = WAV8BitMono44Khz.INSTANCE;
			
			return formats;
		}
		
		/**
		 * Storing ignored tags to see what is still missing
		 */
		public const ignoredTags : Array = new Array();
		
		private var _bytes : ByteArray;
		private var _compression : int;
		private var _numChannels : int;
		private var _samplingRate : int;
		private var _bytesPerSecond : int;
		private var _blockAlign : int;
		private var _bits : int;
		private var _numSamples : Number;
		private var _dataOffset : Number;
		private var _strategy : IWavIOStrategy;

		public function WavDecoder( bytes : ByteArray )
		{
			if ( null == bytes )
				throw new Error( 'bytes must not be null' );

			_bytes = bytes;

			parseHeader();
		}

		/**
		 * @return Quick-check if format can be decoded 
		 */
		public function get supported() : Boolean
		{
			return null != _strategy;
		}

		/**
		 * @return number of samples converted to target samplingRate (In Flash only 44100Hz)
		 */
		public function getNumSamples( targetRate : Number = 44100.0 ) : Number
		{
			if ( _samplingRate == targetRate )
			{
				return _numSamples;
			}
			else
			{
				return Math.floor( numSamples * 44100.0 / _samplingRate );
			}
		}

		/**
		 * Decodes audio from format into Flashplayer sound properties (stereo,float,44100Hz)
		 * 
		 * @return The number of samples has been read
		 */
		public function extract( target : ByteArray, length : Number, startPosition : Number ) : Number
		{
			if ( startPosition >= _numSamples )
				return 0.0;

			if ( startPosition + length > _numSamples )
			{
				length = _numSamples - startPosition;
			}
			
			if ( null == _strategy )
				throw NOT_SUPPORTED;

			_strategy.readData( this, target, length, startPosition );
			
			return length;
		}

		public function get numSamples() : Number
		{
			return _numSamples;
		}

		public function get bits() : int
		{
			return _bits;
		}

		public function get blockAlign() : int
		{
			return _blockAlign;
		}

		public function get bytesPerSecond() : int
		{
			return _bytesPerSecond;
		}

		public function get rate() : int
		{
			return _samplingRate;
		}

		public function get numChannels() : int
		{
			return _numChannels;
		}

		public function get compression() : int
		{
			return _compression;
		}

		public function get seconds() : Number
		{
			return _numSamples * _blockAlign / _bytesPerSecond;
		}

		public function dispose() : void
		{
			_bytes = null;
		}

		public function toString() : String
		{
			return '[WavFormat compression: ' + _compression + ', numChannels: ' + _numChannels + ', rate: ' + _samplingRate + ', bytesPerSecond: ' + _bytesPerSecond + ', blockAlign: ' + _blockAlign + ', bits: ' + _bits + ', numSamples: ' + _numSamples + ']';
		}
		
		internal function get dataOffset() : Number
		{
			return _dataOffset;
		}

		internal function get bytes() : ByteArray
		{
			return _bytes;
		}

		private function parseHeader() : void
		{
			_bytes.position = 0;
			_bytes.endian = Endian.LITTLE_ENDIAN;

			if ( _bytes.readUnsignedInt() != WavTags.RIFF )
				throw NO_WAVE_FILE;

			const fileSize : int = _bytes.readUnsignedInt();

			if ( _bytes.length != fileSize + 8 )
			{
				// Length does not match to wav-specifications
				// I have seen a wav with less before, but worked anyway
				// Skip
			}

			if ( _bytes.readUnsignedInt() != WavTags.WAVE )
				throw NO_WAVE_FILE;

			var chunkID : uint;
			var chunkLength : uint;
			var chunkPosition : uint;

			while ( _bytes.bytesAvailable )
			{
				chunkID = _bytes.readUnsignedInt();
				chunkLength = _bytes.readUnsignedInt();
				chunkPosition = _bytes.position;

				switch( chunkID )
				{
					case WavTags.FMT:
						_compression = _bytes.readUnsignedShort();
						_numChannels = _bytes.readUnsignedShort();
						_samplingRate = _bytes.readUnsignedInt();
						_bytesPerSecond = _bytes.readUnsignedInt();
						_blockAlign = _bytes.readUnsignedShort();
						_bits = _bytes.readUnsignedShort();
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
				_bytes.position = chunkPosition + chunkLength;
			}
			
			findStrategy();
		}

		private function findStrategy() : void
		{
			const n : int = SUPPORTED.length;
			
			for( var i: int = 0 ; i < n ; ++i )
			{
				var strategy: IWavIOStrategy = SUPPORTED[i];

				if ( strategy.readableFor( this ) )
				{
					_strategy = strategy;
					
					return;
				}
			}
		}
	}
}