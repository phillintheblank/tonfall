package tonfall.format.wav
{
	import flash.utils.Endian;
	import flash.utils.ByteArray;
	/**
	 * @author Andre Michelle
	 */
	public final class WavEncoder
	{
		private static const WAV_HAS_NOT_BEEN_WRITTEN : Error = new Error( 'Wav has not been written.' );

		private var _bytes: ByteArray;
		
		private var _strategy : IWavIOStrategy;
		
		private var _dtlo: uint; // store data tag length offset for writing later
		
		private var _samplePosition: uint;

		public function WavEncoder( strategy : IWavIOStrategy )
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
		public function writeData( data: ByteArray, numSamples: uint ): void
		{
			_strategy.writeData( data, _bytes, numSamples );

			_samplePosition += numSamples;
		}
		
		/**
		 * Finalizes wav format after writing audio data
		 */
		public function finalize(): void
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
		
		/**
		 * @return wav format
		 */
		public function get bytes() : ByteArray
		{
			if( 0 == _bytes.position )
				return _bytes;
			
			throw WAV_HAS_NOT_BEEN_WRITTEN;
		}

		private function writeHeader() : void
		{
			_bytes = new ByteArray();
			_bytes.endian = Endian.LITTLE_ENDIAN;
			_bytes.writeUnsignedInt( WavTags.RIFF );
			_bytes.writeUnsignedInt( 0 );
			_bytes.writeUnsignedInt( WavTags.WAVE );

			_strategy.writeFormatTag( _bytes );

			_bytes.writeUnsignedInt( WavTags.DATA );
			
			_dtlo = _bytes.position;
			
			_bytes.writeUnsignedInt( 0 );
		}
	}
}
