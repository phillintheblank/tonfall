package tonfall.poly
{
	import tonfall.core.Signal;
	/**
	 * @author Andre Michelle
	 */
	public interface IPolySynthVoice
	{
		function start( note: Number, numSignals: int ): void;
		
		function processAdd( current: Signal, numSignals: int ):Boolean;
	}
}
