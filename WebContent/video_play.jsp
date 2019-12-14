<%@ page language="java" import="java.awt.*,java.awt.event.*,java.sql.*,javax.swing.*" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link href="CSS\video_play.css" rel="stylesheet" type="text/css" media="all">
<title>视频播放</title>
</head>
<body>
<%
String username0=request.getParameter("id");int id0=0;if(username0!=null){id0=Integer.parseInt(username0);}
String usertype=request.getParameter("usertype");
%>
<div class="header">
  <div class="header1"><p><i>视听</i></p></div>
  <div class="header2">视频
    <!-- <a href="video_info.jsp"><button>个人中心</button></a> -->
    <a href="login.html"><button>退出</button></a>
    <a href="index.jsp?id=<%=id0%>&usertype=<%=usertype%>"><button>首页</button></a>
  </div>
</div>

<div class="parent_classify">
   <a href="video_index.jsp?id=<%=id0%>&usertype=<%=usertype%>"><button>电影</button></a>
   <a href="video_comic.jsp?id=<%=id0%>&usertype=<%=usertype%>"><button>动漫</button></a>
   <a href="video_drama.jsp?id=<%=id0%>&usertype=<%=usertype%>"><button>电视剧</button></a>
   <a href="video_variety.jsp?id=<%=id0%>&usertype=<%=usertype%>"><button>综艺</button></a>
   <button>小视频</button>
 </div>
 
 <div class="return">
   <!-- 设置返回动态页面 -->
   <a href="video_index.jsp?id=<%=id0%>&usertype=<%=usertype%>"><button>返回</button></a>
 </div>
 <%
 String name=request.getParameter("name");
 Connection conn=null;
 Statement stmt=null;
 int vid=Integer.parseInt(name);
 String sql="select * from videobase where vid="+vid;
 
 String name1="";
 String path="";
 String type[]=new String[3];
 int number=0;
 String intro="";
 try
 {
	Class.forName("com.mysql.cj.jdbc.Driver");
	conn=DriverManager.getConnection("jdbc:mysql://localhost:3306/redlen?serverTimezone=UTC","root","jisuanji");
	stmt=conn.createStatement();
	ResultSet rs=stmt.executeQuery(sql);
	rs.next();
	name1=rs.getString("name");
	path=rs.getString("path");

	type[0]=rs.getString("type1");
	type[1]=rs.getString("type2");
	type[2]=rs.getString("type3");
	number=rs.getInt("vid");
	intro=rs.getString("intro");
 }
 catch(SQLException e)
 {
 	out.println("Mysql操作错误");
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
 %>
 <div class="video_play">
   <div class="video_play_title"><%out.print(name1);%></div>
   <video class="play" controls autoplay>
     <source src="<%out.print(path);%>" type="video/mp4">
   </video>
    <span class="video_introduction">
    <h1>信息</h1>
    <%out.print(intro);%>
    </span>
 </div>
 
</body>
</html>