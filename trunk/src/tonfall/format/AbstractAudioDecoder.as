package tonfall.format
{
	import flash.utils.ByteArray;
	
	/**
	 * @author Andre Michelle
	 */
	public class AbstractAudioDecoder
	{
		/**
		 * Storing ignored tags to see what is still missing
		 */
		public const ignoredTags : Array = new Array();
		
		private var _bytes : ByteArray;
		private var _supported: Vector.<IAudioIOStrategy>;
		
		private var _strategy: IAudioIOStrategy;
		
		protected var _compressionType : *;
		protected var _numSamples: Number;
		protected var _samplingRate: Number;
		protected var _numChannels: int;
		protected var _bits: int;
		protected var _blockAlign: int;
		protected var _dataOffset: Number;

		public function AbstractAudioDecoder( bytes : ByteArray, strategies: Vector.<IAudioIOStrategy> )
		{
			if ( null == bytes )
				throw new Error( 'bytes must not be null' );
				
			if ( null == strategies )
				throw new Error( 'supported must not be null' );

			_bytes = bytes;
			_supported = strategies;
			
			parseHeader( _bytes );
			evaluateHeader();
			findStrategy();
		}

		private function evaluateHeader(): void
		{
			if( 0 >= _numSamples )
				trace( 'Warning: No samples found.' );
			
			if( 0 >= _samplingRate )
				throw new Error( 'sampleRate is lessEqual zero.' );

			if( 0 >= _numChannels )
				throw new Error( 'channels is lessEqual zero.' );
				
			if( 0 >= _bits )
				throw new Error( 'bits is lessEqual zero.' );
				
			if( 0 >= _blockAlign )
				throw new Error( 'blockAlign is lessEqual zero.' );
				
			if( 0 >= _dataOffset )
				throw new Error( 'dataOffset is lessEqual zero.' );
		}
		
		public function get seconds() : Number
		{
			return _numSamples / _samplingRate;
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
				return Math.floor( _numSamples * 44100.0 / _samplingRate );
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
			
			_strategy.readData( this, target, length, startPosition );
			
			return length;
		}

		public function get supported(): Boolean
		{
			return null != _strategy;
		}
		
		public function get compressionType(): *
		{
			return _compressionType;
		}
		
		public function get numSamples(): Number
		{
			return _numSamples;
		}

		public function get samplingRate(): Number
		{
			return _samplingRate;
		}

		public function get numChannels(): int
		{
			return _numChannels;
		}

		public function get bits(): int
		{
			return _bits;
		}
		
		public function get blockAlign(): int
		{
			return _blockAlign;
		}
		
		public function get dataOffset() : Number
		{
			return _dataOffset;
		}

		public function get bytes() : ByteArray
		{
			return _bytes;
		}

		public function dispose() : void
		{
			_bytes = null;
		}
		
		protected function parseHeader( bytes: ByteArray ): void
		{
			throw new Error( 'parseHeader is not implemented.' );
		}
		
		private function findStrategy() : void
		{
			const n : int = _supported.length;
			
			for( var i: int = 0 ; i < n ; ++i )
			{
				var strategy: IAudioIOStrategy = _supported[i];

				if ( strategy.readableFor( this ) )
				{
					_strategy = strategy;
					
					return;
				}
			}
		}
	}
}
