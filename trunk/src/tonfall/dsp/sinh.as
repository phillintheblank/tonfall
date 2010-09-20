package tonfall.dsp
{
	public function sinh( x: Number ): Number
	{
		return ( Math.pow( Math.E, x ) - Math.pow( Math.E, -x ) ) * 0.5;
	}
}