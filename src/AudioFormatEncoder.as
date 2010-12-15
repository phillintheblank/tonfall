package
{
	import tonfall.format.wav.WAV32BitMono44Khz;
	import tonfall.format.wav.WavEncoder;

	import flash.display.Sprite;
	import flash.net.FileReference;
	import flash.utils.ByteArray;
	import flash.utils.getQualifiedClassName;

	/**
	 * @author Andre Michelle
	 */
	public final class AudioFormatEncoder extends Sprite
	{
		private static const BUFFER_SIZE : int = 2048;
		
		private const buffer: ByteArray = new ByteArray();
		
		private const fileRef : FileReference = new FileReference();

		private const encoder: WavEncoder = new WavEncoder( WAV32BitMono44Khz.INSTANCE );

		public function AudioFormatEncoder()
		{
			buffer.length = BUFFER_SIZE << 3;
			
			create();
		}

		private function create(): void
		{
			const frequency: Number = 220.0;
			
			var phase: Number = 0.0;
			
			var numSamples: int = 44100 / 220.0;
			
			while( numSamples )
			{
				var write: int = Math.min( BUFFER_SIZE, numSamples );
				
				buffer.position = 0;
				
				for( var i: int = 0 ; i < write ; ++i )
				{
					var amplitude: Number = Math.sin( phase * 2.0 * Math.PI );
					
					buffer.writeFloat( amplitude );
					buffer.writeFloat( amplitude );
					
					phase += frequency / 44100.0;
					phase -= Math.floor( phase );
				}
				
				buffer.position = 0;
				
				encoder.write32BitStereo44KHz( buffer, write );
				
				numSamples -= write;
			}
			
			encoder.finalize();
			
			const name: String = getQualifiedClassName( encoder.strategy );
			
			fileRef.save( encoder.bytes, name.substr( name.indexOf( '::' ) + 2 ) + '.wav' );
		}
	}
}
