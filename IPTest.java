import java.io.IOException;
import java.net.InetSocketAddress;
import java.net.Socket;
import java.net.SocketAddress;
import java.util.Date;

public class IPTest implements Runnable {

    private String ipSuffix;

    private int time;
	
    private int begin;
	
    private int end;
	
    private static int index = 0;

    public IPTest(String ipSuffix, int time,int begin,int end) {
	this.ipSuffix = ipSuffix;
	this.time = time;
	this.begin = begin;
	this.end = end;
    }

    public void test(String ip) {
	Socket socket = new Socket();
	try {
	    SocketAddress targetAddress = new InetSocketAddress(ip, 818);
	    socket.connect(targetAddress, time);
	    if (socket.isConnected()) {
		System.out.println(ip);
	    }
	} catch (Exception e) {
	    // System.out.println(e.getMessage());
	} finally {
	    if (socket != null) {
		try {
		    socket.close();
		} catch (IOException e) {
		    e.printStackTrace();
		}
	    }
	}
    }
	
    public void run() {		
	for (int i = begin; i < end; i++) {
	    test(ipSuffix + "." + i);
	}
    }
	
    public static void startup(int delay,int begin,int end){
		
	IPTest test1 = new IPTest("10.108.226", delay,begin,end);
	IPTest test2 = new IPTest("10.101.27", delay,begin,end);
	Thread t1 = new Thread(test1);
	t1.start();
	Thread t2 = new Thread(test2);
	t2.start();
    }

    /**
     * @param args
     */
    public static void main(String[] args) {
	int splitNum = 1;
	if (args.length == 0) {
	    args = new String[] { "100" };
	}else{
	    if(args.length != 1){
		splitNum = Integer.valueOf(args[1]);					
	    }
	}
		
	int delay = Integer.valueOf(args[0]);
	int threadsNum = 256 / splitNum;
	int rest = 256 % splitNum;
		
	int i = 1;
	int j = 1;
	for(; j <= threadsNum; j++){
	    i = (j - 1) * splitNum;
	    startup(delay,i,j*splitNum);							
	}
		
	startup(delay,j,j+rest+1);
    }	

}
