<%@ page language="java" import="java.awt.*,java.awt.event.*,java.sql.*,javax.swing.*" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
    <%
request.setCharacterEncoding("utf-8"); 
response.setCharacterEncoding("utf-8"); 
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link href="CSS\video_search.css" rel="stylesheet" type="text/css" media="all">
<title>视频搜索结果</title>
</head>
<body>
<%
String username0=request.getParameter("id");int id0=0;if(username0!=null){id0=Integer.parseInt(username0);}
String usertype=request.getParameter("usertype");
System.out.println(username0);
%>
<div class="header">
  <div class="header1"><p><i>视听</i></p></div>
  <div class="header2">视频
    <!-- <a href="video_info.jsp"><button>个人中心</button></a> -->
    <a href="login.html"><button>退出</button></a>
    <a href="index.jsp?id=<%=id0%>&usertype=<%=usertype%>"><button>首页</button></a>
  </div>
</div>
<div class="search-container">
    <form action="video_search.jsp?judge=1&id=<%=id0%>&usertype=<%=usertype%>" method="post">
      <input type="text" placeholder=" 搜索...." name="search">
      <button type="submit">提交</button>
    </form>
 </div>
 
 <div class="parent_classify">
   <a href="video_index.jsp?id=<%=id0%>&usertype=<%=usertype%>"><button onclick="Export()" type="submit">电影</button></a>
   <a href="video_comic.jsp?id=<%=id0%>&usertype=<%=usertype%>"><button>动漫</button></a>
   <a href="video_drama.jsp?id=<%=id0%>&usertype=<%=usertype%>"><button>电视剧</button></a>
   <a href="video_variety.jsp?id=<%=id0%>&usertype=<%=usertype%>"><button>综艺</button></a>
   <button>小视频</button>
 </div>
 <% 
 String search="";
 search=request.getParameter("search");
 int[] vidlist=new int[30];//满足条件的id
 String[][] typelist=new String[30][4];//获取类型
 String[] namelist=new String[30];//获取名字
 String[] pathlist=new String[30];//获取视频路径
 String[] introlist=new String[30];//获取简介
 String[] scorelist=new String[30];//获取评分
 String[] imagepathlist=new String[30];//获取图片路劲
 int id_num=0;
 Connection conn=null;
 Statement stmt=null;
 String sql="select * from videobase,videomessage where videobase.vid=videomessage.vid";
 
 try{
	 Class.forName("com.mysql.cj.jdbc.Driver");
	 conn=DriverManager.getConnection("jdbc:mysql://localhost:3306/redlen?serverTimezone=UTC","root","jisuanji");
	 stmt=conn.createStatement();
	 ResultSet rs=stmt.executeQuery(sql);
	 while(rs.next())
	 {
		 String name=rs.getString("videobase.name");
		 int vid;
		 String path,intro,score,imagepath,type0,type1,type2,type3;
		 if(search.equals(name))
		 {
			 vid=rs.getInt("videobase.vid");
			 path=rs.getString("videobase.path");
			 intro=rs.getString("videobase.intro");
			 score=rs.getString("videomessage.score");
			 imagepath=rs.getString("videomessage.imagepath");
			 type0=rs.getString("videobase.type0");
			 type1=rs.getString("videobase.type1");
			 type2=rs.getString("videobase.type2");
			 type3=rs.getString("videobase.type3");
			 
			 vidlist[id_num]=vid;
			 namelist[id_num]=name;
			 pathlist[id_num]=path;
			 introlist[id_num]=intro;
			 scorelist[id_num]=score;
			 imagepathlist[id_num]=imagepath;
			 typelist[id_num][0]=type0;
			 typelist[id_num][1]=type1;
			 typelist[id_num][2]=type2;
			 typelist[id_num][3]=type3;
			 id_num++;
		 }
	 }
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
 //遍历输出
 if(id_num==0)//没有结果
 {
	 %>
	 <div class="other">没有你搜索的内容</div>
	 <%
 }
 for(int i=0;i<id_num;i++)
 {
	 %>
	 <div class="parent_container">
	 <%
	 if(true)
	 {
		 %>
		 <div class="container">
		   <div class="container_title"><%
		   switch(typelist[i][0]){
		   case "film":
			   out.print("电影");
			   break;
		   case "comic":
			   out.print("动漫");
			   break;
		   case "drama":
			   out.print("电视剧");
			   break;
		   case "variety":
			   out.print("综艺");
			   break;
		   default:
			   out.print("其他");
			   break;
		   }
		   %></div>
		   
		   <a href="video_play.jsp?name=<%=vidlist[i]%>&id=<%=id0%>&usertype=<%=usertype%>" target="_blank">
		   <div class="container_item">
           <img src="<%out.print(imagepathlist[i]);%>" alt=""/>
           <span>
           <b><%out.print("<<"+namelist[i]+">>");%></b><br><br>
                            地区:<%if(typelist[i][1].equals("china"))
                            {
                            	out.print("中国");
                            }else if(typelist[i][1].equals("euam"))
                            {
                            	out.print("欧美");
                            }else{
                            	out.print("日本");
                            }
                            %><br>
                            类型:<%for(int j=2;j<4;j++)
                            {
                            	switch(typelist[i][j]){
                            	case "comedy":
                            		out.print("喜剧 ");
                            		break;
                            	case "science":
                            		out.print("科幻 ");
                            		break;
                            	case "military":
                            		out.print("军事 ");
                            		break;
                            	case "love":
                            		out.print("爱情 ");
                            		break;
                            	case "terror":
                            		out.print("恐怖 ");
                            		break;
                            	case "urban":
                            		out.print("都市 ");
                            		break;
                            	case "youth":
                            		out.print("青春 ");
                            		break;
                            	default:
                            		out.print(typelist[i][j]);
                            		break;
                            	}
                            	
                            }
                            %> <br>
                            评分:<%out.print(scorelist[i]);%><br>
                            剧情: <%out.print(introlist[i]);%>     
           </span>
           <div class="container_item_line"></div>
           </div></a>
          </div>
		 <%
		 
	 }
	 
	 %>
	 </div>
	 <%
 }
 %>
 
</body>
</html>