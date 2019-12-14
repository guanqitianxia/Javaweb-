package BookPackage;
import java.io.BufferedInputStream; 
import java.io.BufferedOutputStream;
import java.io.File; 
import java.io.FileOutputStream;
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
public class AuthorUploadServlet extends javax.servlet.http.HttpServlet implements javax.servlet.Servlet{
	File saveDir=null;
	File tmpDir = null;//初始化上传文件的临时存放目录
	private ServletConfig config;
	public AuthorUploadServlet() {
		super();
	}
	public void init(ServletConfig config) throws ServletException { 
		  this.config=config;
	   super.init();    
	      
	   }
	public void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException{
		
		
		Random rand=new Random();
		int ims=rand.nextInt(10);//加一个随机数避免浏览器加载缓存图片
		
		String aimagepath=request.getParameter("aimagepath");
		String aid_temp=request.getParameter("aid");int aid=Integer.parseInt(aid_temp);
	
		String path = request.getSession().getServletContext().getRealPath("/");//服务器资源的相对路径
		path=path+"author_image/";
		
		
		String allcontent="";
		try {
		     SmartUpload smart=new SmartUpload();
		     smart.initialize(config,request,response);
		     smart.setMaxFileSize(1024*1024);
		     smart.setTotalMaxFileSize(9*1024*1024);
		     smart.upload();
		     //接受文本
		     allcontent=new String(smart.getRequest().getParameter("allcontent").getBytes(), "UTF-8");
		     System.out.println(allcontent);
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
		    	 path=path+aid_temp+ims;
		    	 System.out.println("path"+path);
		    	 file.saveAs(path+"."+file.getFileExt());
		    	 judge=1;
		    	 save(aid,allcontent,"author_image\\"+aid_temp+ims+"."+file.getFileExt());
		     }
		     if(judge==0) {
		    	 save(aid,allcontent,aimagepath);
		     }
		     
		     String url="author_info.jsp?operate=read&aid="+aid_temp;
		     request.getRequestDispatcher(url).forward(request, response);
		     }catch(Exception e) {
		    	 System.out.println(e);
		     }
		/*
		String aid_temp=request.getParameter("aid");
		String ims=request.getParameter("ims");
		if(ims.contentEquals("1")) {ims="0";}else {ims="1";}
		//System.out.println(aid_temp);
		String savePath = request.getSession().getServletContext().getRealPath("/");//服务器资源的相对路径
		String tmpPath = request.getSession().getServletContext().getRealPath("/");
		savePath=savePath+"author_image";
		tmpPath=tmpPath+"tmpdir";
		saveDir=new File(savePath);
		tmpDir = new File(tmpPath);
		if(!saveDir.isDirectory()) {saveDir.mkdir();}
		if(!tmpDir.isDirectory())  {tmpDir.mkdir();}
		try{    
		     if(ServletFileUpload.isMultipartContent(request)){ 
		     DiskFileItemFactory dff = new DiskFileItemFactory();//创建该对象
		     dff.setRepository(tmpDir);//指定上传文件的临时目录
		     dff.setSizeThreshold(1024000);//指定在内存中缓存数据大小,单位为byte 
		     ServletFileUpload sfu = new ServletFileUpload(dff);//创建该对象  
		     sfu.setFileSizeMax(5000000);//指定单个上传文件的最大尺寸  
		     sfu.setSizeMax(10000000);//指定一次上传多个文件的总尺寸  
		     FileItemIterator fii = sfu.getItemIterator(request);
		     
		     while(fii.hasNext()){  
		      
		      FileItemStream fis = fii.next();//从集合中获得一个文件流 
		      if(!fis.isFormField() && fis.getName().length()>0){
		       String fileName = fis.getName().substring(fis.getName().lastIndexOf("\\")+1);//获得上传文件的文件名 
		       fileName=aid_temp+ims+".jpg";
		       System.out.println("fileName"+fileName);
		       BufferedInputStream in = new BufferedInputStream(fis.openStream());//获得文件输入流
		       BufferedOutputStream out = new BufferedOutputStream(new FileOutputStream(new File(saveDir+"/"+fileName)));//获得文件输出流  
		       Streams.copy(in, out, true);//开始把文件写到你指定的上传文件夹  
		      }
		     }
		     //response.setCharacterEncoding("GBK");
		     String url="author_info.jsp?operate=read&aid="+aid_temp;
		     request.getRequestDispatcher(url).forward(request, response);
		    }
		   }
		   catch(Exception e){         
		    e.printStackTrace();  
		   }*/
	}
	public void save(int aid,String all,String imagepath) {
		String array[]=null;
		  if(all!=null)
		  {
			  array=all.split(",");
		  }
		  //保存到数据库
		  try {
		  Class.forName("com.mysql.cj.jdbc.Driver");
		  Connection conn=DriverManager.getConnection("jdbc:mysql://localhost:3306/redlen?serverTimezone=UTC&&useUnicode=true&&characterEncoding=UTF-8","root","jisuanji");
		  String sql_update="update novelauthorinfo set arealname=?,apenname=?,agrade=?,aidentityID=?,asex=?,apositionC=?,apositionX=?,aphone=?,amail=?,aqq=?,aimagepath=? where aid="+aid;
		  PreparedStatement ps=conn.prepareStatement(sql_update);
		  for(int i=1;i<11;i++)
		  {
			  if(i==5||i==10) {
				  ps.setInt(i, Integer.parseInt(array[i-1]));
			  }else {
				  ps.setString(i, array[i-1]);
			  }
		  }
		  ps.setString(11, imagepath);
		  ps.executeUpdate();
		  ps.close();
		  conn.close();
		  }catch(Exception e){
				System.out.println("error"+e.toString());
		  }
	}
}
