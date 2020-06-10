<%@ page language="java" import="java.awt.*,java.awt.event.*,java.sql.*,javax.swing.*,java.util.ArrayList,java.io.IOException,
java.io.BufferedReader,java.io.BufferedWriter,java.io.File,java.io.FileInputStream,java.io.FileOutputStream,java.io.InputStreamReader,java.io.OutputStreamWriter" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link href="CSS\novel_item_info.css" rel="stylesheet" type="text/css" media="all">
<title>小说信息</title>
</head>
<body>
<%
String flag=request.getParameter("flag");if(flag!=null){if(flag.equals("1")){%><script>alert("添加成功")</script><%}else{%><script>alert("失败，已存在")</script><%}}


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
  <%
  if(usertype.equals("1"))
  {
	  %>
	  <a href="reader_info.jsp?operate=wallet&rid=<%=id0%>&usertype=<%=usertype%>"><button><%out.println(name0); %>（id:<%out.println(id0); %>）</button></a> 
	  <%
  }else{
	  %>
	  <a href="reader_info.jsp?operate=wallet&rid=<%=id0%>&usertype=<%=usertype%>"><button><%out.println(name0); %>（id:<%out.println(id0); %>）</button></a>
	  <%
  }
  %>
  <a href="index.jsp?id=<%=id0%>&usertype=<%=usertype%>"><button>首页</button></a>
  <div class="search-container">
    <form action="novelNet_search.jsp?id=<%=id0%>&usertype=<%=usertype%>" method="post">
      <input type="text" placeholder=" 搜索...." name="search">
      <button type="submit">提交</button>
    </form>
  </div>
 
</div>

<div class="header1">
  <div class="header1_logo">视听小说</div>
  <%
  if(usertype.equals("1"))
  {
	  %>
	  <a href="author_info.jsp?operate=read&aid=<%=id0%>"><button>作者专区</button></a>  
	  <%
  }else{
	  %>
	  <a href="reader_info.jsp?rid=<%=id0%>&usertype=<%=usertype%>"><button>读者专区</button></a>  
	  <a href="reader_info.jsp?rid=<%=id0%>&operate=bookshell&usertype=<%=usertype%>"><button>书架</button></a>
	  <%
  }
  %>
</div>

<div class="main_container">
  <!-- 最顶部的分类 -->
  <div class="main_container_header">
  <ul>
    <li><a class="active" href="novel_index.jsp?type=all&id=<%=id0%>&usertype=<%=usertype%>">全部作品</a></li>
    <li><a class="active" href="novel_index.jsp?type=finsh&id=<%=id0%>&usertype=<%=usertype%>">完本</a></li>
    <li><a class="active">排行榜</a></li>
    <li><a class="active" href="entitybook.jsp?operate=city&id=<%=id0%>&usertype=<%=usertype%>">实体书专窗</a></li>
    <li class="classify">
        <a href="" class="classify_btn">分类</a>
        <div class="classify_content">
          <a href="novel_index.jsp?type=xuanhuan&id=<%=id0%>&usertype=<%=usertype%>">玄幻</a>
          <a href="novel_index.jsp?type=wuxia&id=<%=id0%>&usertype=<%=usertype%>">武侠</a>
          <a href="novel_index.jsp?type=xianxia&id=<%=id0%>&usertype=<%=usertype%>">仙侠</a>
          <a href="novel_index.jsp?type=dushi&id=<%=id0%>&usertype=<%=usertype%>" >都市</a>
          <a href="novel_index.jsp?type=junshi&id=<%=id0%>&usertype=<%=usertype%>">军事</a>
          <a href="novel_index.jsp?type=lishi&id=<%=id0%>&usertype=<%=usertype%>">历史</a>
          <a href="novel_index.jsp?type=xuanyi&id=<%=id0%>&usertype=<%=usertype%>">悬疑</a>
          <a href="novel_index.jsp?type=kehuan&id=<%=id0%>&usertype=<%=usertype%>">科幻</a>
          <a href="novel_index.jsp?type=youxi&id=<%=id0%>&usertype=<%=usertype%>">游戏</a>
        </div>
  </ul>
 </div>
 <% 
 String tmid=request.getParameter("nid");
 Connection conn=null;
 Statement stmt=null;
 String sql="";
 int nid=0;
 if(tmid!=null)
 {
	 nid=Integer.parseInt(tmid);
	 sql="select * from novelbase,novelmessage where novelbase.nid=novelmessage.nid and novelbase.nid="+nid;
 }else{
	 sql="select * from novelbase,novelmessage where novelbase.nid=novelmessage.nid";
 }
 
 String name="";
 String author="";
 String type="";
 int finish=1;
 String imagepath="";
 String txtpath="";
 String intro="";
 int chapternum=0;
 int worknumber=0;
 int collection=0;
 int ticket=0;
 
 try
 {
	Class.forName("com.mysql.cj.jdbc.Driver");
	conn=DriverManager.getConnection("jdbc:mysql://localhost:3306/redlen?serverTimezone=UTC","chenguanhao","jisuanji");
	stmt=conn.createStatement();
	ResultSet rs=stmt.executeQuery(sql);
	while(rs.next()){
		name=rs.getString("name");
		author=rs.getString("author");
		finish=rs.getInt("finish");
		imagepath=rs.getString("imagepath");
		txtpath=rs.getString("txtpath");
		intro=rs.getString("intro");
		
		chapternum=rs.getInt("chapternum");
		worknumber=rs.getInt("novelmessage.worknumber");
		collection=rs.getInt("collection");
		ticket=rs.getInt("ticket");
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
 
 %>
 <!-- 作品信息展示（含目录） -->
 <div class="info_show">
    <div class="info_show_intro">
      <img src="<%out.print(imagepath);%>" alt=""/>
      <span>
      <h1><a href="novel_read.jsp?id=<%=id0%>&usertype=<%=usertype%>&nid=<%=nid%>&chapter=1"><%out.print(name);%></a></h1>
      <ul>
        <li>作者:<%out.print(author);%></li>
        <li>更新时间:2019/02/03</li>
        <li>类型 :<%if(finish==1){out.print("完本");}else{out.print("连载");}%>
        &nbsp;<%switch(type){
        case "xuanhuan":
        	out.print("玄幻");
        	break;
        case "xuxia":
        	out.print("武侠");
        	break;
        case "xianxia":
        	out.print("仙侠");
        	break;
        case "dushi":
        	out.print("都市");
        	break;
        case "junshi":
        	out.print("军事");
        	break;
        case "lishi":
        	out.print("历史");
        	break;
        case "xuanyi":
        	out.print("悬疑");
        	break;
        case "kehuan":
        	out.print("科幻");
        	break;
        case "youxi":
        	out.print("游戏");
        	break;
        default:
        	break;
        }%> </li>
        <li>字数 :<%out.print(worknumber);%></li>
        <li>收藏数 :<%out.print(collection);%></li>
        <li>月票数:<%out.print(ticket);%></li>
      </ul>
      <p><%out.print(intro);%></p>
      <ul>
        <li><a href="novel_read.jsp?id=<%=id0%>&usertype=<%=usertype%>&nid=<%=nid%>&chapter=1"><button>开始阅读</button></a></li>
        <li><form action="AddORDeltoShelServlet?id=<%=id0%>&usertype=<%=usertype%>&nid=<%=nid%>&ShelOperate=In" method="post"><button type="submit">加入书架</button></form></li>
        <li><button>订阅</button></li>
      </ul> 
      </span>
     
    </div>
    
    <div class="info_show_catalog">
      <div class="info_show_catalog_header"><%out.print(name);%>(目录:<%out.print(chapternum);%>章)</div>
       <div class="info_show_catalog_list">
       <ul>
 <%
    //读取txt文件获取章节
 ArrayList<String> arraylist=new ArrayList<>();
 try{
	 String pathTemp=txtpath;
	 System.out.println(pathTemp);
	 File file=new File(pathTemp);
	 InputStreamReader inputReader=new InputStreamReader(new FileInputStream(file),"UTF-8");
	 BufferedReader br=new BufferedReader(inputReader);
	 
	 String line;
	 while((line=br.readLine())!=null){
		 if(line.equals(""))
		 {
			 continue;
		 }
		 arraylist.add(line);
	 }
	 br.close();
	 inputReader.close();
 }catch(IOException e){
	 e.printStackTrace();
 }
 int length=arraylist.size();
 ArrayList<String> arraytitle=new ArrayList<>();
 int num=0;
 int t=0;
 
 for(int i=0;i<length;i++){
	 String s=arraylist.get(i);
	 if(!s.equals(""))
	 {
		 String text0="";
		 text0=s.substring(0,1);
		 boolean judge=s.contains("章");
		 int len=s.length();
		 if(t==0){
			 System.out.print(s);
		 }
		 t++;
		 if(text0.equals("第")&&judge&&len<30){
			 num++;
			 arraytitle.add(s);
			 %>
			 <li><a href="novel_read.jsp?id=<%=id0%>&usertype=<%=usertype%>&nid=<%=nid%>&chapter=<%=num%>"><%out.print(s);%></a></li>
			 <%
		 }
	 }
 }
 %>
        </ul>
      </div>
    </div>
 </div>
 
</body>
</html>