<%@ page language="java" import="java.awt.*,java.awt.event.*,java.sql.*,javax.swing.*" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<body>
<%

String user="";
String passwd="";
user=request.getParameter("user");
passwd=request.getParameter("passwd");

boolean flag=false;
Connection conn=null;
Statement stmt=null;
String sql="select * from userlogin";
String temp="";

int usertype=0;
try
{
	Class.forName("com.mysql.cj.jdbc.Driver");
	conn=DriverManager.getConnection("jdbc:mysql://localhost:3306/redlen?serverTimezone=UTC&&useUnicode=true&&characterEncoding=UTF-8","chenguanhao","jisuanji");
	stmt=conn.createStatement();
	ResultSet rs=stmt.executeQuery(sql);
	while(rs.next())
	{
		int rid=rs.getInt("id");
		temp=""+rid;
		String password=rs.getString("password");
		if(user.equals(temp)&&passwd.equals(password))
		{
			usertype=rs.getInt("usertype");
			flag=true;
			break;
		}
	}
}
catch(SQLException e)
{
	System.out.println("Mysql操作错误");
	e.printStackTrace();
}
catch (Exception e) 
{
    e.printStackTrace();
 } 
finally 
{
    conn.close();
 }

if(flag)
{
	String temp1="index.jsp?id="+temp+"&usertype="+usertype;
	request.getRequestDispatcher(temp1).forward(request, response);
}else{
	%>
	<script>
	alert("登录失败，用户名密码错误");
	window.location.href="login.html";
	</script>
	<%
	//request.getRequestDispatcher("login.html").forward(request, response);
}

%>
</body>
</html>