package test.poly
{
	import tonfall.core.TimeEventNote;
	import tonfall.poly.IPolySynthVoice;
	import tonfall.poly.IPolySynthVoiceFactory;

	/**
	 * @author Andre Michelle
	 */
	public class SimplePolySynthVoiceFactory
		implements IPolySynthVoiceFactory
	{
		public function create( event: TimeEventNote ) : IPolySynthVoice
		{
			return new SimplePolySynthVoice();
		}
	}
}
