package RealTime_Performance is
	protected rtPerformancedata is
		procedure getNextNumPoints(newValue : out Integer);
		procedure undogetNextNumPoints;
		function getNumPoints return Integer;

		procedure increaseNumMissed(byValue  : Integer);
		function getNumMissed return Integer;

		procedure increaseTotalTimePoint(byValue : Long_Float);
		function getTotalTimePoint return Long_Float;

		procedure increaseTotalTime(byValue : Long_Float);
		function getTotalTime return Long_Float;

		procedure increaseTotalUsed(byValue : Long_Float);
		function getTotalUsed return Long_Float;
	private 
		NumPoints, NumMissed : Integer := 0;
		TotalTimePoint: Long_Float := 0.0;
		TotalTime, TotalUsed : Long_Float := 0.0;

	end rtPerformancedata;
end RealTime_Performance;
