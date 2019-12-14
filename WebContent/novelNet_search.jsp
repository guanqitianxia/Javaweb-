<%@ page language="java" import="java.awt.*,java.awt.event.*,java.sql.*,javax.swing.*,java.util.ArrayList" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%
request.setCharacterEncoding("utf-8"); 
response.setCharacterEncoding("utf-8"); 
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link href="CSS\novelNet_search.css" rel="stylesheet" type="text/css" media="all">
<title>小说搜索结果</title>
</head>
<body>
<%
String username0=request.getParameter("id");int id0=0;if(username0!=null){id0=Integer.parseInt(username0);}
String usertype=request.getParameter("usertype");
System.out.print(id0+usertype);
%>
<div class="searchCon">
  <a href="novel_index.jsp?id=<%=id0%>&usertype=<%=usertype%>"><button>返回</button></a>
  <div class="searchRes">
    <table>
      <tr>
        <th width="5%">序号</th>
        <th width="15%">封面</th>
        <th width="10%">名称</th>
        <th width="10%">作者</th>
        <th width="10%">状态</th>
        <th width="40%">简介</th>
      </tr>
<%

String search=request.getParameter("search");
//search="异界神修";//测试
System.out.print(search);
Connection conn=null;
Statement stmt=null;
String sql="select * from novelbase where name='"+search+"'";

try{
	 Class.forName("com.mysql.cj.jdbc.Driver");
	 conn=DriverManager.getConnection("jdbc:mysql://localhost:3306/redlen?serverTimezone=UTC&&useUnicode=true&&characterEncoding=UTF-8","root","jisuanji");
	 stmt=conn.createStatement();
	 ResultSet rs=stmt.executeQuery(sql);
	 String imagepath="",name="",author="",intro="";
	 int num=0;
	 int finish=0,nid=0;
	 while(rs.next())
	 {
		 num++;
		 nid=rs.getInt("nid");
		 imagepath=rs.getString("imagepath");
		 name=rs.getString("name");author=rs.getString("author");
		 intro=rs.getString("intro");finish=rs.getInt("finish");
		 %>
	
	  <tr>
        <td width="5%"><%out.print(num); %></td>
        <td width="15%">
        <a href="novel_item_info.jsp?id=<%=id0%>&usertype=<%=usertype%>&nid=<%=nid%>">
        <img src="<%out.print(imagepath); %>" alt=""/>
        </a>
        </td>
        <td width="10%"><a href="novel_item_info.jsp?id=<%=id0%>&usertype=<%=usertype%>&nid=<%=nid%>"><%out.print(name); %></a></td>
        <td width="10%"><%out.print(author); %></td>
        <td width="10%"><%
        if(finish==1){out.print("完结");}else{out.print("连载");} 
        %></td>
        <td width="40%"><%out.print(intro); %></td>
      </tr>
		 <%
	 }
	 if(num==0)
	 {
		 %>
		 <h1 style="text-align:center;color:white;">没有该书！！</h1>
		 <%
	 }
}catch(Exception e){
	System.out.println("error"+e.toString());
}
%>
    </table>
  </div>
</div>
</body>
</html>