package tonfall.format.wav
{
	import tonfall.format.IAudioIOStrategy;

	import flash.utils.ByteArray;
	import flash.utils.Endian;
	/**
	 * @author Andre Michelle
	 */
	public final class WavEncoder
	{
		private var _bytes: ByteArray;
		
		private var _strategy : IAudioIOStrategy;
		
		private var _dtlo: uint; // store data tag length offset for writing later
		
		private var _samplePosition: uint;

		public function WavEncoder( strategy : IAudioIOStrategy )
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
			_bytes.endian = Endian.LITTLE_ENDIAN;
			_bytes.writeUnsignedInt( WavTags.RIFF );
			_bytes.writeUnsignedInt( 0 );
			_bytes.writeUnsignedInt( WavTags.WAVE );
			
			_bytes.writeUnsignedInt( WavTags.FMT );
			_bytes.writeUnsignedInt( 16 ); // chunk length
			_bytes.writeShort( _strategy.compressionType ); // compression
			_bytes.writeShort( _strategy.numChannels ); // numChannels
			_bytes.writeUnsignedInt( _strategy.samplingRate ); // samplingRate
			_bytes.writeUnsignedInt( _strategy.samplingRate * _strategy.blockAlign ); // bytesPerSecond
			_bytes.writeShort( _strategy.blockAlign ); // blockAlign
			_bytes.writeShort( _strategy.bits ); // bits

			_bytes.writeUnsignedInt( WavTags.DATA );
			
			_dtlo = _bytes.position;
			
			_bytes.writeUnsignedInt( 0 );
		}
		
		private function updateHeader(): void
		{
			const position: uint = _bytes.position;
			
			// WRITE FILE SIZE
			_bytes.position = 4;
			_bytes.writeUnsignedInt( _bytes.length - 8 );

			// WRITE AUDIO SIZE
			_bytes.position = _dtlo;
			_bytes.writeUnsignedInt( _samplePosition * _strategy.blockAlign );
			
			// REVERT POSITION
			_bytes.position = position;
		}
	}
}
