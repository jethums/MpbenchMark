
package body RealTime_Performance is

	protected body rtPerformancedata is
		procedure getNextNumPoints(newValue : out Integer) is
		begin
			NumPoints := NumPoints+1;
			newValue := NumPoints;
		end getNextNumPoints;

		procedure undogetNextNumPoints is
		begin
			NumPoints := NumPoints-1;
		end undogetNextNumPoints;

		function getNumPoints return Integer is
		begin
			return NumPoints;
		end getNumPoints;

		procedure increaseNumMissed(byValue  : Integer) is
		begin
			NumMissed := NumMissed + byValue;
		end increaseNumMissed;

		function getNumMissed return Integer is
		begin
			return NumMissed;
		end getNumMissed;

		procedure increaseTotalTimePoint(byValue : Long_Float) is
		begin
			TotalTimePoint := TotalTimePoint + byValue;
		end increaseTotalTimePoint;

		function getTotalTimePoint return Long_Float is
		begin
			return TotalTimePoint;
		end getTotalTimePoint;

		procedure increaseTotalTime(byValue : Long_Float) is
		begin
			TotalTime := TotalTime + byValue;
		end increaseTotalTime;

		function getTotalTime return Long_Float is
		begin
			return TotalTime;
		end getTotalTime;

		procedure increaseTotalUsed(byValue : Long_Float) is
		begin
			TotalUsed := TotalUsed + byValue;
		end increaseTotalUsed;

		function getTotalUsed return Long_Float is
		begin
			return TotalUsed;
		end getTotalUsed;

	end rtPerformancedata;

end RealTime_Performance;