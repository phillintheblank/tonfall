package
{
	import tonfall.format.wav.WavDecoder;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
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
	 * @author Andre Michelle
	 */
	[SWF(backgroundColor="#EDEDED", frameRate="31", width="512", height="192")]
	public final class WavFormatDecoder extends Sprite
	{
		private static const BUFFER_SIZE : int = 2048;
		private const fileRef : FileReference = new FileReference();
		private const textField : TextField = new TextField();
		private const sound : Sound = new Sound();
		private const memory : ByteArray = new ByteArray();
		private var decoder : WavDecoder;
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
			
			textField.appendText( '[Wav Header] compression: ' + decoder.compression + '\n' );
			textField.appendText( '[Wav Header] numChannels: ' + decoder.numChannels + '\n' );
			textField.appendText( '[Wav Header] samplingRate: ' + decoder.rate + '\n' );
			textField.appendText( '[Wav Header] bytesPerSecond: ' + decoder.bytesPerSecond + '\n' );
			textField.appendText( '[Wav Header] blockAlign: ' + decoder.blockAlign + '\n' );
			textField.appendText( '[Wav Header] bits: ' + decoder.bits + '\n' );
			textField.appendText( '[Wav Header] numSamples: ' + decoder.numSamples + '\n' );
			textField.appendText( '[Wav Header] seconds: ' + decoder.seconds.toFixed( 3 ) + '\n' );
			textField.appendText( '[Wav Header] supported: ' + decoder.supported + '\n' );
			
			if ( 0 < decoder.ignoredTags.length )
			{
				// WAV format support additional information. Printing the IDs...
				textField.appendText( '[Wav Header] ignored tags: ' + decoder.ignoredTags + '\n' );
			}

			if ( decoder.supported )
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
