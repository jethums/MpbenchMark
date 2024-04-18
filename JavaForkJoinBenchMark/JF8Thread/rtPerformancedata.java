public class rtPerformancedata {
	
	private static int NumPoints = 0, NumMissed = 0;
	private static double TotalTimePoint = 0;
	private static double TotalTime = 0, TotalUsed = 0;
	
	public synchronized static int nextNumPoints() {
		return ++NumPoints;
	}
	public synchronized static int getNumPoints() {
		return NumPoints;
	}
	
	public synchronized static void increaseNumMissed(int byValue) {
		NumMissed+=byValue;
	}
	public synchronized static int getNumMissed() {
		return NumMissed;
	}
	
	public synchronized static void increaseTotalTimePoint(double byValue) {
		TotalTimePoint+=byValue;
	}
	public synchronized static double getTotalTimePoint() {
		return TotalTimePoint;
	}
	
	public synchronized static void increaseTotalTime(double byValue) {
		TotalTime+=byValue;
	}
	public synchronized static double getTotalTime() {
		return TotalTime;
	}
	
	public synchronized static void increaseTotalUsed(double byValue) {
		TotalUsed+=byValue;
	}
	public synchronized static double getTotalUsed() {
		return TotalUsed;
	}

}
