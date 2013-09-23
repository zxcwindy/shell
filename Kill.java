import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.List;

public class Kill {

    public static void main(String[] args) {
	String regex = ".*" + args[0] + ".*";
	boolean killAll = false;
	if (args.length > 1) {
	    killAll = true;
	}
	InputStream is = null;
	InputStreamReader isr = null;
	BufferedReader br = null;

	try {
	    Process p = new ProcessBuilder("ps", "-ef").start();

	    is = p.getInputStream();
	    isr = new InputStreamReader(is);
	    br = new BufferedReader(isr);
	    String str = "";
	    List<String> ppid = new ArrayList<String>();
	    while ((str = br.readLine()) != null) {
		if (str.matches(regex)) {
		    String[] temp = str.split("\\ {1,}");
		    if (temp.length > 1) {
			ppid.add(temp[1]);
		    }
		    if (!killAll) {
			break;
		    }
		}
	    }
			
	    StringBuilder pid = new StringBuilder();
			
	    for(int i = 0; i < ppid.size(); i++){
		pid.append(ppid.get(i) + " ");
	    }
						
			

	    if (!"".equals(pid)) {
		String command = "kill -9 " + pid;
		System.out.println(command);
		Runtime.getRuntime().exec(command);
	    }

	} catch (IOException e) {
	    // TODO Auto-generated catch block
	    e.printStackTrace();
	} finally {
	    if (br != null) {
		try {
		    br.close();
		} catch (IOException e) {
		    e.printStackTrace();
		}
	    }

	    if (isr != null) {
		try {
		    isr.close();
		} catch (IOException e) {
		    // TODO Auto-generated catch block
		    e.printStackTrace();
		}
	    }

	    if (is != null) {
		try {
		    is.close();
		} catch (IOException e) {
		    // TODO Auto-generated catch block
		    e.printStackTrace();
		}
	    }
	}
    }
}
