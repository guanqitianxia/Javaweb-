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
	File tmpDir = null;//��ʼ���ϴ��ļ�����ʱ���Ŀ¼
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
		int ims=rand.nextInt(10);//��һ�������������������ػ���ͼƬ
		
		String aimagepath=request.getParameter("aimagepath");
		String aid_temp=request.getParameter("aid");int aid=Integer.parseInt(aid_temp);
	
		String path = request.getSession().getServletContext().getRealPath("/");//��������Դ�����·��
		path=path+"author_image/";
		
		
		String allcontent="";
		try {
		     SmartUpload smart=new SmartUpload();
		     smart.initialize(config,request,response);
		     smart.setMaxFileSize(1024*1024);
		     smart.setTotalMaxFileSize(9*1024*1024);
		     smart.upload();
		     //�����ı�
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
		String savePath = request.getSession().getServletContext().getRealPath("/");//��������Դ�����·��
		String tmpPath = request.getSession().getServletContext().getRealPath("/");
		savePath=savePath+"author_image";
		tmpPath=tmpPath+"tmpdir";
		saveDir=new File(savePath);
		tmpDir = new File(tmpPath);
		if(!saveDir.isDirectory()) {saveDir.mkdir();}
		if(!tmpDir.isDirectory())  {tmpDir.mkdir();}
		try{    
		     if(ServletFileUpload.isMultipartContent(request)){ 
		     DiskFileItemFactory dff = new DiskFileItemFactory();//�����ö���
		     dff.setRepository(tmpDir);//ָ���ϴ��ļ�����ʱĿ¼
		     dff.setSizeThreshold(1024000);//ָ�����ڴ��л������ݴ�С,��λΪbyte 
		     ServletFileUpload sfu = new ServletFileUpload(dff);//�����ö���  
		     sfu.setFileSizeMax(5000000);//ָ�������ϴ��ļ������ߴ�  
		     sfu.setSizeMax(10000000);//ָ��һ���ϴ�����ļ����ܳߴ�  
		     FileItemIterator fii = sfu.getItemIterator(request);
		     
		     while(fii.hasNext()){  
		      
		      FileItemStream fis = fii.next();//�Ӽ����л��һ���ļ��� 
		      if(!fis.isFormField() && fis.getName().length()>0){
		       String fileName = fis.getName().substring(fis.getName().lastIndexOf("\\")+1);//����ϴ��ļ����ļ��� 
		       fileName=aid_temp+ims+".jpg";
		       System.out.println("fileName"+fileName);
		       BufferedInputStream in = new BufferedInputStream(fis.openStream());//����ļ�������
		       BufferedOutputStream out = new BufferedOutputStream(new FileOutputStream(new File(saveDir+"/"+fileName)));//����ļ������  
		       Streams.copy(in, out, true);//��ʼ���ļ�д����ָ�����ϴ��ļ���  
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
		  //���浽���ݿ�
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
