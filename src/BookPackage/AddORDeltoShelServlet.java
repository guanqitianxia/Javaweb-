package BookPackage;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.Statement;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


public class AddORDeltoShelServlet extends javax.servlet.http.HttpServlet implements javax.servlet.Servlet{
	public AddORDeltoShelServlet() {
		super();
	}
	public void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException{
		String nid_temp=request.getParameter("nid");int nid=Integer.parseInt(nid_temp);
		//目前
		String id_temp=request.getParameter("id");int id=Integer.parseInt(id_temp);//获取用户id
		String usertype=request.getParameter("usertype");//获取用户类型
		String ShelOperate=request.getParameter("ShelOperate");//获取操作类型
		Connection conn=null;
		Statement stmt=null;
		//String sql="insert into novelreaderbookshelf(rid,nid) select "+id+","+nid+" from DUAL where not exists(select nid from novelreaderbookshelf where rid="+id+")";//目前
		
		String sql="";String url="";
		if(ShelOperate.contentEquals("Del")) {//从书架中删除
			sql="delete from novelreaderbookshelf where rid="+id+" and nid="+nid;
			url="reader_info.jsp?rid="+id_temp+"&usertype="+usertype+"&operate=bookshell&flag=";
		}else {//添加到书架
			sql="insert into novelreaderbookshelf(rid,nid) value("+id+","+nid+")";
			url="novel_item_info.jsp?id="+id_temp+"&usertype="+usertype+"&nid="+nid+"&flag=";
		}
		int flag=0;
		try
		 {
			Class.forName("com.mysql.cj.jdbc.Driver");
			conn=DriverManager.getConnection("jdbc:mysql://localhost:3306/redlen?serverTimezone=UTC&&useUnicode=true&&characterEncoding=UTF-8","root","jisuanji");
			PreparedStatement ps=conn.prepareStatement(sql);
			//System.out.print(sql);
			ps.executeUpdate();
			ps.close();
			conn.close();
			flag=1;//成功
			
		 }catch(Exception e){
				System.out.println("error"+e.toString());
				flag=0;//失败
		 }
		url=url+flag;
	    request.getRequestDispatcher(url).forward(request, response);
		
}
}
