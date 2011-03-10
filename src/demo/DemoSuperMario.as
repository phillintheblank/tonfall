package demo
{
	import flash.events.ProgressEvent;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import test.effects.Delay;
	import test.supermario.SuperMarioSequencer;

	import tonfall.core.TimeConversion;
	import tonfall.display.AbstractApplication;
	import tonfall.poly.PolySynth;

	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.text.TextField;

	/**
	 * Demoes ISoundSheet
	 * 
	 * @author Andre Michelle
	 */
	[SWF(width='512',height='48',backgroundColor='0x1b1b1b',frameRate='32',scriptTimeLimit='255')]
	public final class DemoSuperMario extends AbstractApplication
	{
		private static const SHEETS: Array =
		[
			{ url: '../load/piano.mp3', name: 'PIANO' },
			{ url: '../load/strings.mp3', name: 'STRINGS' },
			{ url: '../load/rhodes.mp3', name: 'RHODES' },
			{ url: '../load/guitar.mp3', name: 'GUITAR' },
			{ url: '../load/accordion.mp3', name: 'ACCORDION' },
			{ url: '../load/vibraphone.mp3', name: 'VIBRAPHONE' }
		];
		
		private const sheet: SoundSheet = new SoundSheet();
		
		private const sequencer: SuperMarioSequencer = new SuperMarioSequencer();
		private const generator: PolySynth = new PolySynth( new SoundSheetVoiceFactory( sheet ) );

		private const textField: TextField = new TextField();

		private var _mp3: MP3;
		private var _inited: Boolean;
		
		public function DemoSuperMario()
		{
			buildUI();
			
			addEventListener( MouseEvent.CLICK, click );
		}

		private function click( event: MouseEvent ): void
		{
			const button: Button = event.target as Button;
			
			if( null != button )
			{
				loadSheet( button.url );
			}
		}
		
		private function loadSheet( url: String ): void
		{
			generator.clear();
			driver.running = false;
			engine.barPosition = 0.0;
			
			if( null != _mp3 )
			{
				try { _mp3.close(); } catch( e: Error ) {}
				
				_mp3 = null;
			}

			_mp3 = new MP3();
			_mp3.addEventListener( Event.COMPLETE, mp3Complete );
			_mp3.addEventListener( ProgressEvent.PROGRESS, mp3Progress );
			_mp3.load( new URLRequest( url ) );
		}

		private function mp3Progress( event: ProgressEvent ): void
		{
			if( 0.0 < event.bytesTotal )
				textField.text = Math.ceil( ( event.bytesLoaded / event.bytesTotal * 100.0 ) ) + '%';
		}

		private function mp3Complete( event: Event ): void
		{
			textField.text = ( _mp3.bytesTotal >> 10 ) + 'kb';
			
			driver.running = true;
			
			_mp3.removeEventListener( Event.COMPLETE, mp3Complete );
			_mp3.removeEventListener( ProgressEvent.PROGRESS, mp3Progress );
			
			sheet.setDecoder( _mp3 );
			
			if( !_inited )
			{
				init();
			}
		}

		private function buildUI(): void
		{
			var n: int = SHEETS.length;
			
			for( var i: int = 0 ; i < n ; ++i )
			{
				var data: Object = SHEETS[i];
				
				var button: Button = new Button( data['name'], data['url'], 512.0 / n );
				button.x = i * 512.0 / n;
				button.y = 24.0;
				addChild( button );
			}
			
			textField.selectable = false;
			textField.autoSize = TextFieldAutoSize.LEFT;
			textField.defaultTextFormat = new TextFormat( 'Arial', 10, 0xAAAAAA );
			textField.text = 'Choose an instrument...';
			addChild( textField );
		}
		
		private function init(): void
		{
			const delay: Delay = new Delay( TimeConversion.barsToMillis( 3.0 / 16.0, engine.bpm ) );
			
			sequencer.timeEventTarget = generator;
			engine.processors.push( sequencer );
			engine.processors.push( generator );
			engine.processors.push( delay );
			
			delay.input = generator.output;
			engine.input = delay.output;
			
			_inited = true;
		}
	}
}
import tonfall.core.Engine;
import tonfall.core.Memory;
import tonfall.core.Signal;
import tonfall.core.TimeConversion;
import tonfall.core.TimeEvent;
import tonfall.core.TimeEventNote;
import tonfall.core.noteToFrequency;
import tonfall.format.IAudioDecoder;
import tonfall.poly.IPolySynthVoice;
import tonfall.poly.IPolySynthVoiceFactory;
import tonfall.util.ISoundSheet;

import flash.media.Sound;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.utils.ByteArray;

final class Button extends TextField
{
	private static const format: TextFormat = new TextFormat( 'Arial', 10, 0xFFFFFF );
	
	private var _url: String;

	public function Button( text: String, url: String, width: Number )
	{
		defaultTextFormat = format;
		opaqueBackground = 0xFFCC33;
		selectable = false;

		this.width = width;
		this.height = 14;
		this.text = text;
		
		_url = url;
	}

	public function get url(): String
	{
		return _url;
	}
}

final class MP3 extends Sound
	implements IAudioDecoder
{
	// Override to add the encoder delay (LAME 3.98.2 + flash.media.Sound Delay)
	override public function extract( target: ByteArray, length: Number, startPosition: Number = -1 ): Number
	{
		return super.extract( target, length, startPosition + 2257.0 );
	}
}

final class SoundSheet
	implements ISoundSheet
{
	public static const FREQUENCIES: Vector.<Number> = createFrequencyTable();

	private static function createFrequencyTable(): Vector.<Number>
	{
		const table: Vector.<Number> = new Vector.<Number>( 11, true );
		
		for( var i: int = 0 ; i < 11 ; ++i )
		{
			table[i] = noteToFrequency( 36 + i * 6 );
		}

		return table;
	}
	
	private var _decoder: IAudioDecoder;

	public function setDecoder( decoder: IAudioDecoder ): void
	{
		_decoder = decoder;
	}

	public function getKeyIndexByNote( note: int ): int
	{
		var index: int = ( note - 36.0 ) / 6.0 + 0.5;

		if( index < 0 )
			index = 0;
		else
		if( index > 10 )
			index = 10;
			
		return index;
	}

	public function getFrequencyByKeyIndex( keyIndex: int ): Number
	{
		return FREQUENCIES[ keyIndex ];
	}

	public function get numSamplesEachKey(): Number
	{
		return 44100.0;
	}

	public function get decoder(): IAudioDecoder
	{
		return _decoder;
	}

	public function getStartPositionFromKeyIndex( keyIndex: int ): Number
	{
		return keyIndex * numSamplesEachKey;
	}

	public function getEndPositionFromKeyIndex( keyIndex: int ): Number
	{
		return ( keyIndex + 1 ) * numSamplesEachKey;
	}
}

final class SoundSheetVoiceFactory
	implements IPolySynthVoiceFactory
{
	private var _sheet: ISoundSheet;

	public function SoundSheetVoiceFactory( sheet: ISoundSheet )
	{
		_sheet = sheet;
	}
	
	public function create( event: TimeEventNote ): IPolySynthVoice
	{
		return new SoundSheetVoice( _sheet );
	}
}

final class SoundSheetVoice
	implements IPolySynthVoice
{
	// Lazy envelope built
	private const engine: Engine = Engine.getInstance();
	private const RELEASE_DURATION: int = 8820; // 200ms

	private var _rate: Number;
	private var _position: Number;
	private var _end: Number;
	private var _envelopePointer: int;
	private var _sheet: ISoundSheet;

	public function SoundSheetVoice( sheet: ISoundSheet )
	{
		_sheet = sheet;
	}
	
	public function start( event: TimeEvent ): void
	{
		const note: int = TimeEventNote( event ).note;

		const keyIndex: int = _sheet.getKeyIndexByNote( note );
		
		const sampleFrequency: Number = _sheet.getFrequencyByKeyIndex( keyIndex );
		const noteFrequency: Number = noteToFrequency( note );

		_rate = noteFrequency / sampleFrequency;

		_position = _sheet.getStartPositionFromKeyIndex( keyIndex );
		_end = _sheet.getEndPositionFromKeyIndex( keyIndex );
		
		_envelopePointer = TimeConversion.barsToNumSamples( TimeEventNote( event ).barDuration, engine.bpm );
	}

	public function stop(): void
	{
	}

	public function processAdd( current: Signal, numSignals: int ): Boolean
	{
		//-- REUSE INSTEAD OF RECREATION
		Memory.position = 0;
		
		var p0: Number = _position;
		var p1: Number =  p0 + numSignals * _rate;
		
		if( p1 > _end )
			p1 = _end;

		const i0: int = p0;
		const i1: int = p1 + 2.0;
		
		//-- EXTRACT SAMPLES
		_sheet.decoder.extract( Memory, i1 - i0, i0 );
		
		var l0: Number;
		var r0: Number;
		var l1: Number;
		var r1: Number;
		
		var bufferPosition: Number = p0 - i0;
		
		var integer: int;
		var alpha: Number;
		var env: Number;

		for( var i: int = 0 ; i < numSignals ; ++i )
		{
			_position += _rate;

			if( _position >= _end )
				return true;
				
			if( 0 < _envelopePointer-- )
				env = 1.0;
			else
			if( -RELEASE_DURATION > _envelopePointer )
				return true;
			else
				env = 1.0 + _envelopePointer / RELEASE_DURATION;

			integer = bufferPosition;
			alpha = bufferPosition - integer;
			bufferPosition += _rate;

			//-- SET TARGET READ POSITION
			Memory.position = integer << 3;

			//-- READ TWO STEREO SAMPLES FOR LINEAR INTERPOLATION
			l0 = Memory.readFloat();
			r0 = Memory.readFloat();

			l1 = Memory.readFloat();
			r1 = Memory.readFloat();
			
			//-- WRITE INTERPOLATED AMPLITUDES INTO STREAM
			current.l += ( l0 + alpha * ( l1 - l0 ) ) * env;
			current.r += ( r0 + alpha * ( r1 - r0 ) ) * env;
			current = current.next;
		}
		
		return false;
	}

	public function dispose(): void
	{
		_sheet = null;
	}
}