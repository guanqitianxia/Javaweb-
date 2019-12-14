package BookPackage;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class cartServlet extends javax.servlet.http.HttpServlet implements javax.servlet.Servlet{

	public cartServlet() {
		super();
	}
	

public void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
	    response.setContentType("text/html;charset=utf-8");
	    UserService service = new UserService();
	    
	    String rid_temp=request.getParameter("id");int rid=Integer.parseInt(rid_temp);
	    String usertype=request.getParameter("usertype");
	    String sql_operate=request.getParameter("sql_operate");
	    if(sql_operate.equals("insert"))
	    {
	    	String value_temp=request.getParameter("value");
	    	int value=0;if(value_temp!=null&&!value_temp.contentEquals("")) {value=Integer.parseInt(value_temp);}else {value=1;}
	    	String bid_temp=request.getParameter("bid");int bid=Integer.parseInt(bid_temp);
	    	//System.out.println(value+" "+bid);
	    	try {
				service.insert(rid,bid,value);
			} catch (ClassNotFoundException | SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
	    	String url="cartServlet?id="+rid+"&sql_operate=readtocart&usertype="+usertype;
			request.getRequestDispatcher(url).forward(request, response);
	    }
	    if(sql_operate.equals("updatePlus"))//加
	    {
	    	String cid_temp=request.getParameter("cid");int cid=Integer.parseInt(cid_temp);
	    	String bnumber_temp=request.getParameter("bnumber");int bnumber=Integer.parseInt(bnumber_temp);
	    	String bid_temp=request.getParameter("bid");int bid=Integer.parseInt(bid_temp);
	    	try {
				service.update(cid,1,bnumber,bid);
			} catch (ClassNotFoundException | SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
	    	String url="cartServlet?id="+rid+"&sql_operate=readtocart&usertype="+usertype;
			request.getRequestDispatcher(url).forward(request, response);
	    }
	    if(sql_operate.equals("updateMinus"))//减
	    {
	    	String cid_temp=request.getParameter("cid");int cid=Integer.parseInt(cid_temp);
	    	String bnumber_temp=request.getParameter("bnumber");int bnumber=Integer.parseInt(bnumber_temp);
	    	try {
	    		service.update(cid,0,bnumber,0);
			} catch (ClassNotFoundException | SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
	    	String url="cartServlet?id="+rid+"&sql_operate=readtocart&usertype="+usertype;
			request.getRequestDispatcher(url).forward(request, response);
	    }
	    if(sql_operate.equals("delete"))
	    {
	    	String cid_temp=request.getParameter("cid");int cid=Integer.parseInt(cid_temp);
	    	try {
				service.delete(cid);
			} catch (ClassNotFoundException | SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
	    	String url="cartServlet?id="+rid+"&sql_operate=readtocart&usertype="+usertype;
			request.getRequestDispatcher(url).forward(request, response);
	    }
	    if(sql_operate.equals("order"))
	    {
	    	String total_temp=request.getParameter("total");int total=Integer.parseInt(total_temp);
	    	int SF=0;
	    	try {
				SF=service.orderSubmit(rid,total);
			} catch (ClassNotFoundException | SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
	    	String url="cartServlet?id="+rid+"&sql_operate=readtocart&usertype="+usertype+"&SF="+SF;
			request.getRequestDispatcher(url).forward(request, response);
	    }
	    if(sql_operate.equals("readtocart"))
	    {
			List<entitybook> list = null;
			try {
				list = service.getallUser(rid);
			} catch (ClassNotFoundException | SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			// 查询出来的用户信息保存到session对象中
			HttpSession session = request.getSession();
			session.setAttribute("cartlist", list);
			
			String url="entitybook.jsp?operate=cart&id="+rid+"&usertype="+usertype;
			request.getRequestDispatcher(url).forward(request, response);	
	    }
	    

	}

}
