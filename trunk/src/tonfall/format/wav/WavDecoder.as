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
		private static const NOT_SUPPORTED : Error = new Error( 'Not supported.' );
		
		private static const SUPPORTED : Vector.<IWavDecoderStrategy> = getSupportedWavFormats();

		private static function getSupportedWavFormats() : Vector.<IWavDecoderStrategy>
		{
			const formats: Vector.<IWavDecoderStrategy> = new Vector.<IWavDecoderStrategy>( 7, true );

			formats[0] = WAV16BitStereo44Khz.INSTANCE;
			formats[1] = WAV16BitMono44Khz.INSTANCE;
			formats[2] = WAV32BitStereo44Khz.INSTANCE;
			formats[3] = WAV32BitMono44Khz.INSTANCE;
			formats[4] = WAV8BitStereo44Khz.INSTANCE;
			formats[5] = WAV8BitMono44Khz.INSTANCE;
			formats[6] = WAV16BitMonoAllKhz.INSTANCE;
			
			return formats;
		}
		
		public const uncatched : Array = new Array();
		
		private var _bytes : ByteArray;
		private var _compression : int;
		private var _numChannels : int;
		private var _samplingRate : int;
		private var _bytesPerSecond : int;
		private var _blockAlign : int;
		private var _bits : int;
		private var _numSamples : Number;
		private var _dataOffset : Number;
		private var _strategy : IWavDecoderStrategy;

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
			if ( 1 != _compression && 3 != _compression )
				return false;

			if ( 8 != _bits && 16 != _bits && 32 != _bits )
				return false;

			return 1 == _numChannels || 2 == _numChannels;
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

			_strategy.read( this, target, length, startPosition );
			
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

			if ( _bytes.readUnsignedInt() != 0x46464952 ) // 'RIFF'
				throw new Error( 'Unknown Format (Not RIFF).' );

			const fileSize : int = _bytes.readUnsignedInt();

			// I have seen this before, but worked for some reason.
			if ( _bytes.length != fileSize + 8 )
				trace( '[Warning] Length does not match to wav-specifications. bytes.length: ' + _bytes.length + ' fileSize: ' + fileSize );

			if ( _bytes.readUnsignedInt() != 0x45564157 ) // 'WAVE'
				throw new Error( 'Unknown Format (Not WAVE).' );

			var id : String;
			var length : uint;
			var position : uint;

			while ( _bytes.bytesAvailable )
			{
				id = _bytes.readUTFBytes( 4 );
				length = _bytes.readUnsignedInt();
				position = _bytes.position;

				switch( id )
				{
					case 'fmt ':
						_compression = _bytes.readUnsignedShort();
						_numChannels = _bytes.readUnsignedShort();
						_samplingRate = _bytes.readUnsignedInt();
						_bytesPerSecond = _bytes.readUnsignedInt();
						_blockAlign = _bytes.readUnsignedShort();
						_bits = _bytes.readUnsignedShort();
						break;
					case 'data':
						_dataOffset = position;
						_numSamples = length / _blockAlign;
						break;
					default:
						uncatched.push( id );
						break;
				}

				_bytes.position = position + length;
			}
			
			findStrategy();
		}

		private function findStrategy() : void
		{
			const n : int = SUPPORTED.length;
			
			for( var i: int = 0 ; i < n ; ++i )
			{
				var strategy: IWavDecoderStrategy = SUPPORTED[i];

				if ( strategy.supports( this ) )
				{
					_strategy = strategy;
					
					break;
				}
			}
		}
	}
}