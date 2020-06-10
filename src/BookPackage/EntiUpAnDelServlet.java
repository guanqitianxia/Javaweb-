package BookPackage;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.Statement;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/EntiUpAnDelServlet")
public class EntiUpAnDelServlet extends javax.servlet.http.HttpServlet implements javax.servlet.Servlet{

	private static Connection conn;
	private static Statement st;
	public EntiUpAnDelServlet() {
		super();
	}
	static {
		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
			conn=DriverManager.getConnection("jdbc:mysql://localhost:3306/redlen?serverTimezone=UTC&&useUnicode=true&&characterEncoding=UTF-8","chenguanhao","jisuanji");
			st=conn.createStatement();
		}catch(Exception e) {
			e.printStackTrace();
		}
	}
	protected void service(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException{
		request.setCharacterEncoding("utf-8"); 
		response.setCharacterEncoding("utf-8");
		String operate=request.getParameter("operate");
		String aid_temp=request.getParameter("aid");int aid=Integer.parseInt(aid_temp);
		String bid_temp=request.getParameter("bid");int bid=Integer.parseInt(bid_temp);
		if(operate.contentEquals("delete")) {
			delete(aid,bid);
		}
		String url="author_bookmanage.jsp?booktype=entitymanage&aid="+aid;
		request.getRequestDispatcher(url).forward(request, response);
		
     }
	public void delete(int aid,int bid) {
		try{
			String sql="delete from novelauthorentity where aid="+aid+" and bid="+bid;
			
			PreparedStatement ps=conn.prepareStatement(sql);
			
			ps.executeUpdate();
			ps.close();
			conn.close();
		}catch(Exception e){
			System.out.println("error"+e.toString());
		}
	}
}
