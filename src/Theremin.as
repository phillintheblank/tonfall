package
{
	import tonfall.util.Mapping;
	import flash.events.MouseEvent;
	import tonfall.display.AbstractApplication;

	/**
	 * Simple example of Mouse-Theremin
	 * 
	 * This example was requested by Jared Ficklin for a more analog version I suppose ;)
	 * 
	 * It also shows, how samplewise interpolation can be done in audio-dsp to avoid clicks and pops.
	 * 
	 * @author Andre Michelle
	 */
	[SWF(backgroundColor="#FFFFFF", frameRate="31", width="640", height="480")]
	public final class Theremin extends AbstractApplication
	{
		private const thereminProcessor: ThereminProcessor = new ThereminProcessor();
		private const mapping: Mapping = new Mapping();
		
		public function Theremin()
		{
			engine.processors.push( thereminProcessor );
			engine.input = thereminProcessor.output;
			
			showSpectrum = true;

			stage.addEventListener( MouseEvent.MOUSE_MOVE, mouseMove );
		}

		private function mouseMove( event: MouseEvent ): void
		{
			// Map Y to gain
			thereminProcessor.setGain( 1.0 - mouseY / stage.stageHeight );
			
			// Map X to frequency log-style (20-22050Hz)
			const frequency: Number = mapping.mapExp( mouseX / stage.stageWidth, 20.0, 22050.0 );
			
			thereminProcessor.setFrequency( frequency );
		}
	}
}

import tonfall.core.Signal;
import tonfall.core.SignalBuffer;
import tonfall.core.SignalProcessor;

final class ThereminProcessor extends SignalProcessor
{
	public const output: SignalBuffer = new SignalBuffer();
	
	private const INTERPOLATION_DURATION: int = 44100 * 0.1; // 100ms
	
	private const PI_2: Number = Math.PI * 2.0;
	
	private var _phase: Number;
	
	private var _phaseIncrCurrent: Number;
	private var _phaseIncrTarget: Number;
	private var _phaseIncrVelocity: Number;
	private var _phaseIncrInterpolationRemaining: int;
	
	private var _gainCurrent: Number;
	private var _gainTarget: Number;
	private var _gainVelocity: Number;
	private var _gainInterpolationRemaining: int;

	public function ThereminProcessor()
	{
		_phase = 0.0;
		
		_phaseIncrCurrent = _phaseIncrTarget = 0.0;
		
		_gainCurrent = _gainTarget = 0.0;
	}
	
	/**
	 * @param value Frequency between zero and 22050Hz
	 */
	public function setFrequency( value: Number ): void
	{
		if( value < 0.0 )
			value = 0.0;
		else
		if( value > 22050.0 )
			value = 22050.0;
		
		const phaseIncr: Number = value / 44100.0;
		
		if( phaseIncr != _phaseIncrCurrent )
		{
			_phaseIncrTarget = phaseIncr;
			_phaseIncrVelocity = ( _phaseIncrTarget - _phaseIncrCurrent ) / INTERPOLATION_DURATION;
			_phaseIncrInterpolationRemaining = INTERPOLATION_DURATION;
		}
	}
	
	/**
	 * @param value Gain between zero and one
	 */
	public function setGain( value: Number ): void
	{
		if( value < 0.0 )
			value = 0.0;
		else
		if( value > 1.0 )
			value = 1.0;
		
		if( _gainCurrent != value )
		{
			_gainTarget = value;
			_gainVelocity = ( _gainTarget - _gainCurrent ) / INTERPOLATION_DURATION;
			_gainInterpolationRemaining = INTERPOLATION_DURATION;
		}
	}
	
	override protected function processSignals( numSignals: int ): void
	{
		var signal: Signal = output.current;
		
		for( var i: int = 0 ; i < numSignals ; ++i )
		{
			//-- GENERATE AMPLITUDE
			signal.l = signal.r = Math.sin( _phase * PI_2 ) * _gainCurrent;
			signal = signal.next;

			//-- ADVANCE WAVFORM PHASE
			_phase += _phaseIncrCurrent;
			_phase -= Math.floor( _phase );
			
			//-- INTERPOLATE FREQUENCY (IN PHASE DOMAIN)
			if( _phaseIncrInterpolationRemaining )
			{
				if( 0 == --_phaseIncrInterpolationRemaining )
				{
					_phaseIncrCurrent = _phaseIncrTarget;
					_phaseIncrVelocity = 0.0;
				}
				else
				{
					_phaseIncrCurrent += _phaseIncrVelocity;
				}
			}

			//-- INTERPOLATE GAIN
			if( _gainInterpolationRemaining )
			{
				if( 0 == --_gainInterpolationRemaining )
				{
					_gainCurrent = _gainTarget;
					_gainVelocity = 0.0;
				}
				else
				{
					_gainCurrent += _gainVelocity;
				}
			}
		}
	}		
}