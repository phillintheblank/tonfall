package tonfall.poly
{
	import tonfall.core.TimeEventNote;
	/**
	 * @author Andre Michelle
	 */
	public interface IPolySynthVoiceFactory
	{
		function create( event: TimeEventNote ): IPolySynthVoice;
	}
}
