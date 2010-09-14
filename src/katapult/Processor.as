package katapult
{
	/**
	 * @author Andre Michelle
	 */
	public class Processor
	{
		protected const engine: Engine = Engine.getInstance();
		
		public function Processor()
		{
		}
		
		public function process( info: BlockInfo ): void
		{
			throw new Error( 'Method "process" is marked abstract.' );
		}
	}
}