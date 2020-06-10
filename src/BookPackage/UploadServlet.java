package BookPackage;

import java.io.BufferedInputStream; 
import java.io.BufferedOutputStream;
import java.io.File; 
import java.io.FileOutputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.sql.SQLException;
import java.util.Random;
import java.sql.*;

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
 
public class UploadServlet extends javax.servlet.http.HttpServlet implements javax.servlet.Servlet {  
 File tmpDir = null;//初始化上传文件的临时存放目录    
 File saveDir = null;//初始化上传文件后的保存目录  
 private ServletConfig config;
 public UploadServlet() {
	 super();    
	 }      
 
 
  protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {     
   doPost(request,response);    
   }    
  public void init(ServletConfig config) throws ServletException { 
	  this.config=config;
   super.init();    
      
   }   
  protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {     
	 //request.setCharacterEncoding("GBK");
	 //request.setCharacterEncoding("UTF-8");
	 
	 Random rand=new Random();
	 int ims=rand.nextInt(10);//加一个随机数避免浏览器加载缓存图片
	 
	 String aid_temp=request.getParameter("aid");
	 int aid=Integer.parseInt(aid_temp);
     String bid_temp=request.getParameter("bid");
     int bid=Integer.parseInt(bid_temp);
     String infotype=request.getParameter("infotype");
     String imagepath=request.getParameter("imagepath");
     
     String allcontent="",author="";
     try {
     SmartUpload smart=new SmartUpload();
     smart.initialize(config,request,response);
     smart.setMaxFileSize(1024*1024);
     smart.setTotalMaxFileSize(9*1024*1024);
     smart.upload();
     //接受文本
     allcontent=new String(smart.getRequest().getParameter("allcontent").getBytes(), "UTF-8");
     //allcontent=smart.getRequest().getParameter("allcontent");
     author=(String)request.getSession().getAttribute("author");
     allcontent=allcontent+"*"+author;
     String array[]=null;
	  if(allcontent!=null)
	  {
		  array=allcontent.split("\\*");
	  }
     //设置文件路径
	 String tmpPath = request.getSession().getServletContext().getRealPath("/");
		tmpPath=tmpPath+"tmpdir";
	 String savePathImg = request.getSession().getServletContext().getRealPath("/");//服务器资源的相对路径
	 savePathImg=savePathImg+"novel_image";
     String savePathNov = request.getSession().getServletContext().getRealPath("/");
     savePathNov=savePathNov+"novel";
     String typeInPath="/"+array[1]+"/";//array[1]为类型文件夹,例如: \\xuanhuan\\
     
     String novelimagePath=savePathImg+typeInPath;//封面路径
     String novelPath=savePathNov+typeInPath+bid_temp+".txt";//小说文件路径
     //System.out.println("novelPath"+novelPath);
     String novelimagePath_temp="novel_image"+typeInPath+bid_temp+ims+".jpg";//数据库中只保存路径的后段
     //String novelPath_temp="novel"+typeInPath+bid_temp+".txt";
     //创建对应的txt文件
     File f3 = new File(novelPath);FileWriter fw=new FileWriter(f3);fw.write("null");fw.close();
     
     int judge=0;
     
     for(int i=0;i<smart.getFiles().getCount();i++) {
    	 com.jspsmart.upload.File file=smart.getFiles().getFile(i);
    	 if(file.isMissing()) {
    		 continue;
    	 }
    	 novelimagePath=novelimagePath+bid_temp+ims;
    	 file.saveAs(novelimagePath+"."+file.getFileExt());
    	 judge=1;
     }
     if(judge==1) {
    	 allcontent=allcontent+"*"+novelimagePath_temp+"*"+novelPath;
     }else {
    	 allcontent=allcontent+"*"+imagepath+"*"+novelPath;
     }
     save(allcontent,aid,bid,infotype);//将信息保存到数据库
     
     String url="author_bookmanage.jsp?booktype=netmanage&aid="+aid;
     request.getRequestDispatcher(url).forward(request, response);
     }catch(Exception e) {
    	 System.out.println(e);
     }
     
     
    
  }
  public void save(String all,int aid,int bid,String infotype) {
	  String array[]=null;
	  if(all!=null)
	  {
		  array=all.split("\\*");
	  }
	  //保存到数据库
	  try {
	  Class.forName("com.mysql.cj.jdbc.Driver");
	  Connection conn=DriverManager.getConnection("jdbc:mysql://localhost:3306/redlen?serverTimezone=UTC&&useUnicode=true&&characterEncoding=UTF-8","chenguanhao","jisuanji");
	  String sql_delete="delete from novelbase where nid="+bid;
	  PreparedStatement ps=conn.prepareStatement(sql_delete);
	  ps.executeUpdate();
	  String sql_save="insert into novelbase values(?,?,?,?,?,?,?,?,?,?)";
	  PreparedStatement ps1=conn.prepareStatement(sql_save);
	  ps1.setInt(1, bid);ps1.setInt(2, aid);ps1.setString(3,array[0]);ps1.setString(4, array[5]);
	  ps1.setString(5, array[1]);ps1.setString(6, array[2]);ps1.setString(7, array[3]);ps1.setString(8, array[6]);
	  ps1.setString(9, array[7]);ps1.setString(10, array[4]);
	  ps1.executeUpdate();
	  if(infotype.equals("create"))
	  {
	  //插入novelmessage表
	  String sql_save_mes="insert into novelmessage value(?,'Srunning','Amianfei','N100down',?,0,0,0,0)"; 
	  ps1=conn.prepareStatement(sql_save_mes);
	  ps1.setInt(1, bid);ps1.setString(2,array[2]);
	  ps1.executeUpdate();
	  }
	  
	  ps.close();
	  ps1.close();
	  conn.close();
	  }catch(Exception e){
			System.out.println("error"+e.toString());
	  }
  }
 
}
