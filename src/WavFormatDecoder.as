package
{
	import flash.events.MouseEvent;
	import tonfall.format.IAudioFormat;
	import tonfall.format.wav.WavDecoder;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.SampleDataEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.ByteArray;

	/**
	 * @author aM
	 */
	[SWF(backgroundColor="#EDEDED", frameRate="31", width="512", height="192")]
	public final class WavFormatDecoder extends Sprite
	{
		private static const BUFFER_SIZE : int = 2048;
		private const fileRef : FileReference = new FileReference();
		private const textField : TextField = new TextField();
		private const sound : Sound = new Sound();
		private const memory : ByteArray = new ByteArray();
		private var decoder : IAudioFormat;
		private var numSamples : Number;
		private var position : Number;
		private var soundChannel : SoundChannel;
		private var firstRun: Boolean;

		public function WavFormatDecoder()
		{
			textField.autoSize = TextFieldAutoSize.LEFT;
			textField.defaultTextFormat = new TextFormat( 'Verdana', 10, 0x666666, true );
			textField.text = 'Click to browse from your local harddrive\n';
			addChild( textField );
			
			firstRun = true;
			
			stage.addEventListener( MouseEvent.CLICK, click );		
		}

		private function click( event : MouseEvent ) : void
		{
			stage.removeEventListener( MouseEvent.CLICK, click );
			
			if( firstRun )
			{
				firstRun = false;
			}
			else
			{
				textField.text = 'Browsing\n';
			}
			
			browseWav();
		}

		private function browseWav() : void
		{
			// allocate memory (sizeof float:4)*2
			memory.length = BUFFER_SIZE << 3;

			fileRef.addEventListener( Event.SELECT, select );
			fileRef.addEventListener( Event.CANCEL, cancel );
			fileRef.browse( [ new FileFilter( 'Wavformat', '.wav' ) ] );
		}

		private function cancel( event : Event ) : void
		{
			textField.appendText( 'Bye bye.\n' );
			
			fileRef.removeEventListener( Event.CANCEL, cancel );
			fileRef.removeEventListener( Event.SELECT, select );
		}

		private function select( event : Event ) : void
		{
			fileRef.removeEventListener( Event.CANCEL, cancel );
			fileRef.removeEventListener( Event.SELECT, select );

			fileRef.addEventListener( Event.COMPLETE, complete );
			fileRef.load();
		}

		private function complete( event : Event ) : void
		{
			fileRef.removeEventListener( Event.COMPLETE, complete );

			textField.appendText( 'Loaded ' + fileRef.name + '\n' );

			try
			{
				decoder = new WavDecoder( fileRef.data );
			}
			catch( e : Error )
			{
				textField.appendText( 'Error while parsing ' + e.name + ' occured.\n' );
				textField.appendText( e.message + '\n' );
				return;
			}

			// Not quite sure, if we get all these information from every format thinkable
			const wav_decoder : WavDecoder = WavDecoder( decoder );

			if ( 0 < wav_decoder.ignoredTags.length )
			{
				// WAV format support additional information. Printing the IDs...
				textField.appendText( '[Wav Header] ignored tags: ' + wav_decoder.ignoredTags + '\n' );
			}

			textField.appendText( '[Wav Header] compression: ' + wav_decoder.compression + '\n' );
			textField.appendText( '[Wav Header] numChannels: ' + wav_decoder.numChannels + '\n' );
			textField.appendText( '[Wav Header] samplingRate: ' + wav_decoder.rate + '\n' );
			textField.appendText( '[Wav Header] bytesPerSecond: ' + wav_decoder.bytesPerSecond + '\n' );
			textField.appendText( '[Wav Header] blockAlign: ' + wav_decoder.blockAlign + '\n' );
			textField.appendText( '[Wav Header] bits: ' + wav_decoder.bits + '\n' );
			textField.appendText( '[Wav Header] numSamples: ' + wav_decoder.numSamples + '\n' );
			textField.appendText( '[Wav Header] seconds: ' + wav_decoder.seconds.toFixed( 3 ) + '\n' );
			textField.appendText( '[Wav Header] supported: ' + wav_decoder.supported + '\n' );

			if ( wav_decoder.supported )
			{
				textField.appendText( 'playback...\n' );
				play();
			}
			else
			{
				finished();
			}
		}

		private function play() : void
		{
			// get numSamples in Flashplayer samplingRate space (44100Hz)
			numSamples = decoder.getNumSamples( 44100.0 );

			position = 0;

			sound.addEventListener( SampleDataEvent.SAMPLE_DATA, sampleData );
			soundChannel = sound.play();
		}

		private function sampleData( event : SampleDataEvent ) : void
		{
			const data : ByteArray = event.data;

			memory.position = 0;

			try
			{
				const read : Number = decoder.extract( memory, BUFFER_SIZE, position );
			}
			catch( e : Error )
			{
				textField.appendText( 'Error while parsing ' + e.name + 'occured.\n' );
				textField.appendText( e.message + '\n' );

				finished();
			}

			if ( 0 == read )
			{
				textField.appendText( 'complete.\n' );
				finished();
				return;
			}

			memory.position = 0;

			position += read;

			for ( var i : int = 0 ; i < read ; ++i )
			{
				data.writeFloat( memory.readFloat() );
				data.writeFloat( memory.readFloat() );
			}

			for ( ; i < BUFFER_SIZE ; ++i )
			{
				data.writeFloat( 0.0 );
				data.writeFloat( 0.0 );
			}
		}

		private function finished() : void
		{
			sound.removeEventListener( SampleDataEvent.SAMPLE_DATA, sampleData );
			
			textField.appendText( 'Click to do it again.\n' );
			
			stage.addEventListener( MouseEvent.CLICK, click );
		}
	}
}
