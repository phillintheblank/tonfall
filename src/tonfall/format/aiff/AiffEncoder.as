package tonfall.format.aiff
{
	import tonfall.format.IAudioIOStrategy;

	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	/**
	 * TODO Not finally implemented
	 * 
	 * @author Andre Michelle
	 */
	public final class AiffEncoder
	{
		private var _bytes: ByteArray;
		
		private var _strategy : IAudioIOStrategy;
		
		private var _dtlo: uint; // store data tag length offset for writing later
		
		private var _samplePosition: uint;

		public function AiffEncoder( strategy : IAudioIOStrategy )
		{
			if( null == strategy )
			{
				throw new Error( 'strategy must not be null' );
			}
			
			_strategy = strategy;
			
			_samplePosition = 0;
			
			writeHeader();
		}
		
		/**
		 * Writes audio data to wav format
		 * 
		 * @param data ByteArray consisting audio format (44100,Stereo,Float)
		 * @param numSamples number of samples to be processed
		 */
		public function write32BitStereo44KHz( data: ByteArray, numSamples: uint ): void
		{
			_strategy.write32BitStereo44KHz( data, _bytes, numSamples );

			_samplePosition += numSamples;
			
			updateHeader();
		}
		
		/**
		 * @return wav format
		 */
		public function get bytes() : ByteArray
		{
			return _bytes;
		}
		
		public function get strategy(): IAudioIOStrategy
		{
			return _strategy;
		}
		
		public function dispose(): void
		{
			_bytes = null;
		}

		private function writeHeader() : void
		{
			_bytes = new ByteArray();
			_bytes.endian = Endian.BIG_ENDIAN;
			
			_bytes.writeUTFBytes( AiffTags.FORM );
			_bytes.writeUnsignedInt( 0 );
			_bytes.writeUTFBytes( AiffTags.AIFF );

			// TODO

			_dtlo = _bytes.position;
			
			_bytes.writeUnsignedInt( 0 );
		}
		
		private function updateHeader(): void
		{
			// WRITE FILE SIZE
			_bytes.position = 4;
			_bytes.writeUnsignedInt( _bytes.length - 8 );

			// WRITE AUDIO SIZE
			_bytes.position = _dtlo;
			_bytes.writeUnsignedInt( _samplePosition * _strategy.blockAlign );
			
			// REWIND
			_bytes.position = 0;
		}
	}
}
