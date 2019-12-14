package BookPackage;
import java.io.BufferedInputStream; 
import java.io.BufferedOutputStream;
import java.io.File; 
import java.io.FileOutputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.sql.*;
import java.util.Random;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;  
import org.apache.commons.fileupload.DefaultFileItemFactory;
import org.apache.commons.fileupload.FileItemFactory;
import org.apache.commons.fileupload.FileItemIterator;
import org.apache.commons.fileupload.FileItemStream;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.apache.commons.fileupload.util.Streams;

import com.jspsmart.upload.SmartUpload; 
public class ReaderUploadServlet extends javax.servlet.http.HttpServlet implements javax.servlet.Servlet{
	File saveDir=null;
	File tmpDir = null;//初始化上传文件的临时存放目录
	private ServletConfig config;
	public ReaderUploadServlet() {
		super();
	}
	public void init(ServletConfig config) throws ServletException { 
		  this.config=config;
	   super.init();    
	      
	   }
	public void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException{
		request.setCharacterEncoding("UTF-8");
		response.setCharacterEncoding("UTF-8");
		response.setContentType("text/html;charset=UTF-8"); 
		Random rand=new Random();
		int ims=rand.nextInt(10);//加一个随机数避免浏览器加载缓存图片
		
		String rimagepath=request.getParameter("rimagepath");
		String rid_temp=request.getParameter("rid");int rid=Integer.parseInt(rid_temp);
	
		String path = request.getSession().getServletContext().getRealPath("/");//服务器资源的相对路径
		path=path+"reader_image/";
		
		
		String allcontent="";
		try {
		     SmartUpload smart=new SmartUpload();
		     smart.initialize(config,request,response);
		     smart.setMaxFileSize(1024*1024);
		     smart.setTotalMaxFileSize(9*1024*1024);
		     smart.upload();
		     //接受文本
		     allcontent=new String(smart.getRequest().getParameter("allcontent").getBytes(), "UTF-8");
		     
		     String array[]=null;
			  if(allcontent!=null)
			  {
				  array=allcontent.split(",");
			  }
		    
		     int judge=0;
		     
		     for(int i=0;i<smart.getFiles().getCount();i++) {
		    	 com.jspsmart.upload.File file=smart.getFiles().getFile(i);
		    	 if(file.isMissing()) {
		    		 continue;
		    	 }
		    	 path=path+rid_temp+ims;
		    	 System.out.println("path"+path);
		    	 file.saveAs(path+"."+file.getFileExt());
		    	 judge=1;
		    	 save(rid,allcontent,"reader_image\\"+rid_temp+ims+"."+file.getFileExt());
		     }
		     if(judge==0) {
		    	 save(rid,allcontent,rimagepath);
		     }
		     String url="reader_info.jsp?rid="+rid+"&usertype=0";
		     request.getRequestDispatcher(url).forward(request, response);
		     }catch(Exception e) {
		    	 System.out.println(e);
		     }
		
		
		 
	}
	public void save(int rid,String all,String imagepath) {
		String array[]=null;
		  if(all!=null)
		  {
			  array=all.split(",");
		  }
		  //保存到数据库
		  try {
		  Class.forName("com.mysql.cj.jdbc.Driver");
		  Connection conn=DriverManager.getConnection("jdbc:mysql://localhost:3306/redlen?serverTimezone=UTC&&useUnicode=true&&characterEncoding=UTF-8","root","jisuanji");
		  String sql_update="update novelreaderinfo set rname=?,rsex=?,rmail=?,rposition=?,raddress=?,imagepath=? where rid="+rid;
		  PreparedStatement ps=conn.prepareStatement(sql_update);
		  int a1=Integer.parseInt(array[1]);
		  ps.setString(1, array[0]);ps.setInt(2,a1);ps.setString(3,array[2]);
		  ps.setString(4, array[3]);ps.setString(5, array[4]);ps.setString(6, imagepath);
		  ps.executeUpdate();
		  ps.close();
		  conn.close();
		  }catch(Exception e){
				System.out.println("error"+e.toString());
		  }
	}
}
