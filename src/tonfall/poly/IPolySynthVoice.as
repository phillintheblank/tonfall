package tonfall.poly
{
	import tonfall.core.Signal;

	/**
	 * IPolySynthVoice does the actual audio generation of a PolySynth.
	 * 
	 * @author Andre Michelle
	 */
	public interface IPolySynthVoice
	{
		function start( note: Number, numSignals: int ): void;
		
		function processAdd( current: Signal, numSignals: int ):Boolean;
		
		function dispose(): void;
	}
}
