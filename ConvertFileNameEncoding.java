import java.io.File;
import java.io.IOException;
import java.io.UnsupportedEncodingException;

public class ConvertFileNameEncoding {
	
	static void convert(String path,String fromEncoding,String toEncoding) throws UnsupportedEncodingException{
		File file = new File(path);
		String fileParentPath = file.getParent();		
		String renamePath = fileParentPath + File.separator + new String(file.getName().getBytes(fromEncoding),toEncoding);
		File newFile = new File(renamePath);
		System.out.println("convert: " + file.renameTo(newFile));
		if(newFile.isDirectory()){
			File[] files = newFile.listFiles();
			for(File temp: files){
				convert(temp.getAbsolutePath(),fromEncoding,toEncoding);
			}
		}
	}

	/**
	 * @param args
	 * @throws IOException 
	 */
	public static void main(String[] args) throws IOException {
		ConvertFileNameEncoding.convert(args[0],args[1],args[2]);
	}

}
