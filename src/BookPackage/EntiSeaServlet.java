package BookPackage;

import javax.servlet.http.HttpServlet;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Scanner; 
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
@WebServlet("/EntiSeaServlet")
public class EntiSeaServlet extends javax.servlet.http.HttpServlet implements javax.servlet.Servlet{

	private static Connection conn;
	private static Statement st;
	public EntiSeaServlet() {
		super();
	}
	static {
		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
			conn=DriverManager.getConnection("jdbc:mysql://localhost:3306/redlen?serverTimezone=UTC&&useUnicode=true&&characterEncoding=UTF-8","root","jisuanji");
			st=conn.createStatement();
		}catch(Exception e) {
			e.printStackTrace();
		}
	}
	protected void service(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException{
		List<Map> list=new ArrayList<Map>();
		request.setCharacterEncoding("utf-8"); 
		response.setCharacterEncoding("utf-8"); 
		
		String searchtype=request.getParameter("searchtype");
		String sql="";
		if(searchtype.contentEquals("bid"))
		{
			String bid_temp=request.getParameter("bookID");int bid=0;
			if(bid_temp.contentEquals("")) {
				bid=0;
			}else {
				bid=Integer.parseInt(bid_temp);
			}
			sql="select * from novelauthorentity where bid="+bid;
		}
		if(searchtype.contentEquals("bname"))
		{
			String bname_temp=request.getParameter("bookName");
			sql="select * from novelauthorentity where bname='"+bname_temp+"'";
		}
		if(searchtype.contentEquals("btype"))
		{
			String btype_temp=request.getParameter("bookType");
			sql="select * from novelauthorentity where btype='"+btype_temp+"'";
		}
		
		try {
			ResultSet rs=st.executeQuery(sql);
			while(rs.next()) {
				int bid1=rs.getInt("bid");int aid=rs.getInt("aid");
				String bname=rs.getString("bname");String btype=rs.getString("btype");
				int bmoney=rs.getInt("bmoney");int bnumber=rs.getInt("bnumber");
				String bauthor=rs.getString("bauthor");String bintro=rs.getString("bintro");
				
				Map map=new HashMap();
				map.put("aid",aid);
				map.put("bid",bid1);
				map.put("bname",bname);
				String btype_temp="";
				switch(btype)
                {
                case "xuanhuan":btype_temp="玄幻";break; case "wuxia":btype_temp="武侠";break; case "xianxia":btype_temp="仙侠";break;
                case "dushi":btype_temp="都市";break; case "junshi":btype_temp="军事";break; case "lishi":btype_temp="历史";break;
                case "xuanyi":btype_temp="游戏";break; case "kehuan":btype_temp="科幻";break; case "youxi":btype_temp="游戏";break;
                default:
                	btype_temp="无";
              	  break;
                }
				map.put("btype",btype_temp);
				map.put("bmoney", bmoney);
				map.put("bnumber",bnumber);
				map.put("bauthor",bauthor);
				map.put("bintro",bintro);
				
				list.add(map);
				
			}
		}catch(Exception e) {
			e.printStackTrace();
		}
		request.setAttribute("key_list", list);
		request.getRequestDispatcher("/entitybook_search.jsp").forward(request, response);
		
	}
}
