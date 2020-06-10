<%@ page language="java" import="java.awt.*,java.awt.event.*,java.sql.*,javax.swing.*" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<link href="CSS\index.css" rel="stylesheet" type="text/css" media="all">
<title>首页</title>
</head>
<body>
<%
String username0=request.getParameter("id");int id0=0;if(username0!=null){id0=Integer.parseInt(username0);}
String usertype=request.getParameter("usertype");
String sql0="";String getname="";
if(usertype.equals("1")){
	sql0="select * from novelauthorinfo where aid="+id0;getname="apenname";
}else{
	sql0="select * from novelreaderinfo where rid="+id0;getname="rname";
}
Connection conn0=null;
Statement stmt0=null;
String name0="";
if(username0!=null)
{
	try
	{
		Class.forName("com.mysql.cj.jdbc.Driver");
		conn0=DriverManager.getConnection("jdbc:mysql://localhost:3306/redlen?serverTimezone=UTC","chenguanhao","jisuanji");
		stmt0=conn0.createStatement();
		ResultSet rs=stmt0.executeQuery(sql0);
		rs.next();
		name0=rs.getString(getname);
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
	    conn0.close();
	 }
}


%>
<div class="header">
  <div class="title">视听网站</div>
</div>

<div class="subheader">
  <div class="subheader_content">欢迎进入视听网站，<% out.println(name0); %>
  <a href="login.html">注销</a></div>
</div>
<div class="entry">
  <a href="video_index.jsp?id=<%=id0%>&usertype=<%=usertype%>"><button class="entry_item"><span>视频观看</span></button></a>
  <a href="novel_index.jsp?id=<%=id0%>&usertype=<%=usertype%>"><button class="entry_item"><span>小说阅览</span></button></a>
  <!--漫画功能先搁置  <a href="comic_index.jsp"><button class="entry_item"><span>漫画阅读</span></button></a>-->
</div>
</body>
</html>