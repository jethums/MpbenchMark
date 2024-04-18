import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;

public class mpbenchmark {
	//number of threads
	public static final int NUM_THREADS=configuration_data.NUM_THREADS;
	private static Thread threads[]=new Thread[NUM_THREADS];
	private static double BenchmarkStartTime,BenchmarEndTime;
	
	//arrays, store input and output data
	public static double[][] inputArray;
	public static double[][] outputArray;	
	public static int LineCount=0;
	
	public static void main(String[] args) {
		//System.out.print("Multi Processor Benchmark Java version\n");
		int engine=3;
		if(args.length>0)
		{
			if(args[0].equals("1")){
				engine=1;
				//System.out.print("Turbojet is selected\n");
			}
			else if(args[0].equals("2")){
				engine=2;
				//System.out.print("Afterburner  is selected\n");
			}
			else if(args[0].equals("3")){
				engine=3;
				//System.out.print("Turbofan  is selected\n");
			}
			else{
				//System.out.print("Turbofan (default) is selected\n");
			}
		}
		else
	    {
			//System.out.print("Turbofan (default) is selected\n\n");
	    }
		configuration_data.engine=engine;
		
		InitializeArray();

		BenchmarkStartTime=System.nanoTime();
		/**   create threads */	
		for(int i=0;i<NUM_THREADS;i++){
			threads[i]=new Thread(new WorkingThread(i));
			threads[i].start();
		}
		
		//join thread and print final result
		for(int i=0;i<NUM_THREADS;i++){
			try {
				threads[i].join();
			} catch (InterruptedException e) {
				e.printStackTrace();
			}
		}
		BenchmarEndTime=System.nanoTime();		
		printResult();
	}
	
	public static void InitializeArray(){
		LineCount=0;
		try {
			BufferedReader br = new BufferedReader(new FileReader("../..//IOFiles//InputFile.txt"));
			String sCurrentLine = null;
			while( (sCurrentLine=br.readLine())!=null){
				LineCount++;
			}
			
			inputArray=new double[LineCount][4];
			outputArray=new double[LineCount][18];
			br.close();
			br= new BufferedReader(new FileReader("../..//IOFiles//InputFile.txt"));
			sCurrentLine = null;
			LineCount=0;
			while( (sCurrentLine=br.readLine())!=null){
				String dataFromFile[]=sCurrentLine.split(" ");
				inputArray[LineCount][0]=Double.parseDouble(dataFromFile[0]);
				inputArray[LineCount][1]=Double.parseDouble(dataFromFile[1]);
				inputArray[LineCount][2]=Double.parseDouble(dataFromFile[2]);
				inputArray[LineCount][3]=Double.parseDouble(dataFromFile[3]);
				LineCount++;
			}
			br.close();			
		} catch (FileNotFoundException e) {
			System.out.println("Can not find input data file: ../..//IOFiles//InputFile.txt");
		} catch (IOException e) {
			System.out.println("Read input file error");
		}
	}

	public static void printResult(){
		//header for results
		
		// System.out.print("T,ExecTime,  Spd| Alt |  Thr| Mach|Press| Temp| Fnet|Fgros|RamDr|FlFlo|TSFC|Airfl|Weight|Fn/W\n");	
		// for(int i=0;i<LineCount;i++){
		// 	System.out.print(String.format("%d,%.15f, %.15f|%.15f|%.15f|%.15f|%.15f|%.15f|%.15f|%.15f|%.15f|%.15f|%.15f|%.15f|%.15f|%4.2f\n     %3.1f%% used for point %d\n"
		// 		, (int)outputArray[i][0],outputArray[i][1],outputArray[i][2],outputArray[i][3],outputArray[i][4],
		// 		outputArray[i][5],outputArray[i][6],outputArray[i][7],outputArray[i][8],outputArray[i][9],outputArray[i][10],
		// 		outputArray[i][11],outputArray[i][12],outputArray[i][13],outputArray[i][14],outputArray[i][15], 
		// 		outputArray[i][16], (int)outputArray[i][17]));	
		// }
		
		//System.out.println(String.format("%d", rtPerformancedata.getNumMissed()));		
		//System.out.println(String.format("Thread response time sum:%f",rtPerformancedata.getTotalTime()));
		//System.out.println(String.format("Number of threads : %d", NUM_THREADS));
		//System.out.println(String.format("Number of points : %d",rtPerformancedata.getNumPoints()));
		double benchmarkTotalTime=(BenchmarEndTime-BenchmarkStartTime)/1000000000;
		//System.out.println(String.format("%f", benchmarkTotalTime));

		//write into file
		try {
			String path="../..//IOFiles//Java//ResponseTimeForCore"+NUM_THREADS+".txt";
			File f = new File(path);
			if(!f.exists()){	f.createNewFile();	}
			BufferedWriter output = new BufferedWriter(new FileWriter(f,true));
			output.write(String.format("%f", benchmarkTotalTime)+"\n");
			output.close();           
        } catch (Exception e) { }
        try {
			String path="../..//IOFiles//Java//DeadLineForCore"+NUM_THREADS+".txt";
			File f = new File(path);
			if(!f.exists()){	f.createNewFile();	}
			BufferedWriter output = new BufferedWriter(new FileWriter(f,true));
			output.write(String.format("%d", rtPerformancedata.getNumMissed())+"\n");
			output.close();           
        } catch (Exception e) { }
	}
}
