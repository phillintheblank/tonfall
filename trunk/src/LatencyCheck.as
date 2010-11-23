package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.SampleDataEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.system.Capabilities;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.ByteArray;

	/**
	 * @author Andre Michelle
	 */
	[SWF(backgroundColor="#DDDDDD", frameRate="31", width="512", height="96")]
	public final class LatencyCheck extends Sprite
	{
		private static const TESTS: Vector.<int> = Vector.<int>( [ 2048, 3072, 4096, 8192 ] );
		
		private const buffer: ByteArray = new ByteArray();
		
		private const sounds: Vector.<Sound> = new Vector.<Sound>();
		private const channels: Vector.<SoundChannel> = new Vector.<SoundChannel>();
		
		private const textField: TextField = new TextField();
		private const outputs: Vector.<String> = new Vector.<String>();
		
		public function LatencyCheck()
		{
			textField.autoSize = TextFieldAutoSize.LEFT;
			textField.defaultTextFormat = new TextFormat( 'Verdana', 10, 0x0, false );
			textField.text = '';
			addChild( textField );
			
			buffer.length = TESTS[ int( TESTS.length - 1 ) ] << 3; // MAX SAMPLES * sizeof float (times two: stereo)
			
			var i: int = 0;
			var n: int = TESTS.length;
			
			for( ; i < n ; ++i )
			{
				sounds[i] = new Sound();
				sounds[i].addEventListener( SampleDataEvent.SAMPLE_DATA, sampleData );
				channels[i] = sounds[i].play();
			}
			
			stage.addEventListener( Event.ENTER_FRAME, enterFrame );
		}

		private function enterFrame( event: Event ): void
		{
			textField.text = '';
			textField.appendText( 'System\t' + Capabilities.os + '\n' );
			textField.appendText( 'Player\t' + Capabilities.version + ' ' + Capabilities.playerType + '\n' );
			textField.appendText( '--------------------------------------------------------------------\n' );
			
			var i: int = 0;
			var n: int = outputs.length;
			
			for( ; i < n ; ++i )
			{
				textField.appendText( outputs[i] + '\n' );
			}
		}

		private function sampleData( event: SampleDataEvent ): void
		{
			var index: int = sounds.indexOf( event.target );
			
			if( -1 == index )
				throw new Error();
				
			if( channels.length > index && channels[index] != null )
			{
				// Compute difference from writing and audible audio data
				const latency: Number = event.position / 44.1 - channels[index].position;

				outputs[index] = 'Providing ' + TESTS[index] + ' samples results in ' + latency.toFixed(3) + 'ms latency';
			}
			
			event.data.writeBytes( buffer, 0, TESTS[index] << 3 );
		}
	}
}