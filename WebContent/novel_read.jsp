<%@ page language="java" import="java.awt.*,java.awt.event.*,java.sql.*,javax.swing.*,java.util.ArrayList,java.io.IOException,
java.io.BufferedReader,java.io.BufferedWriter,java.io.File,java.io.FileInputStream,java.io.FileOutputStream,java.io.InputStreamReader,java.io.OutputStreamWriter" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link href="CSS\novel_read.css" rel="stylesheet" type="text/css" media="all">
<title>小说阅读</title>
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
		conn0=DriverManager.getConnection("jdbc:mysql://localhost:3306/redlen?serverTimezone=UTC","root","jisuanji");
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
<script type="text/script">

</script>
<div class="header">
  <ul>
    <li class="header_title">视听小说</li>
    <li class="header1"><a href="novel_index.jsp?type=all&id=<%=id0%>&usertype=<%=usertype%>">全部作品</a></li>
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
    </li>
    <li class="header2">
      <form action="novelNet_search.jsp?id=<%=id0%>&usertype=<%=usertype%>" method="post">
      <input type="text" placeholder=" 搜索...." name="search">
      <button type="submit">提交</button>
      </form>
    </li>
    <li class="header3">
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
    </li>
  </ul>
</div>
<%
String nid=request.getParameter("nid");
String cid=request.getParameter("chapter");//获取章节数
Connection conn=null;
Statement stmt=null;
int id=Integer.parseInt(nid);
int chapter=Integer.parseInt(cid);
//上下一章
int temp;
temp=chapter-1;
String chapterSub=temp+"";
temp=chapter+1;
String chapterAdd=temp+"";

String sql="select * from novelbase where nid="+id;

String name="",author="",type0="",finish="",imagepath="",txtpath="";
String intro="";
try
{
	Class.forName("com.mysql.cj.jdbc.Driver");
	conn=DriverManager.getConnection("jdbc:mysql://localhost:3306/redlen?serverTimezone=UTC","root","jisuanji");
	stmt=conn.createStatement();
	ResultSet rs=stmt.executeQuery(sql);
	rs.next();
	name=rs.getString("name");
	author=rs.getString("author");
	type0=rs.getString("type0");
	finish=rs.getString("finish");
	imagepath=rs.getString("imagepath");
	txtpath=rs.getString("txtpath");
	
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
//读取txt文件
ArrayList<String> arraylist=new ArrayList<>();
try{
	String pathTemp=txtpath;
	File file=new File(pathTemp);
	//File file=new File("novel/xuanhuan/10001.txt");
	InputStreamReader inputReader=new InputStreamReader(new FileInputStream(file),"UTF-8");
	BufferedReader br=new BufferedReader(inputReader);
	
	String line;
	while((line=br.readLine())!=null){
		if(line.equals(""))//空白行
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
ArrayList<String> arraytitle=new ArrayList<>();//保存章节
int num=0;//某章节对应的
int t=0;//用于去掉正文的章节名
String content_show="";
for(int i=0;i<length;i++){
	String s=arraylist.get(i);
	if(!s.equals(""))
	{
		
		String text0="";
		text0=s.substring(0,1);
		boolean judge=s.contains("章");
		int len=s.length();
		if(text0.equals("第")&&judge&&len<30){//找到有第*章的行
			num++;
			arraytitle.add(s);
			//System.out.println(s);
		}
		if(num==chapter)
		{
			if(t>0)//不是章节名
			{
				content_show=content_show+s;//拼接属于该章节的行
			}
			t++;
		}
		
	}
}
System.out.println(num);
if(chapter<=0||chapter>num){//章节数不存在
	System.out.println("sdf");
	request.getRequestDispatcher("novel_item_info.jsp").forward(request, response);
}
%>
<!-- 主要内容显示 -->
<div class="main_container">
  <div class="main_container_catalog">
    <ul>
      <a href="novel_read?catalog=l"><li>目录</li></a>
	  <a href = "javascript:void(0)" onclick = "document.getElementById('light').style.display='block'"><li>设置</li></a>
          <div id="light" class="white_content">
          <a href = "javascript:void(0)" onclick = "document.getElementById('light').style.display='none'">关闭</a>
          </div> 
	  <a href="#c"><li>书架</li></a>
    </ul>
  </div>
  
  <div class="main_container_show">
     <div class="main_container_show_title"><%out.print(arraytitle.get(chapter-1)); %></div>
     <div class="main_container_show_operate">
       <a href="novel_read.jsp?id=<%=id0%>&usertype=<%=usertype%>&nid=<%=nid%>&chapter=<%=chapterSub%>"><button>上一章</button></a>
       <a href="novel_item_info.jsp?id=<%=id0%>&usertype=<%=usertype%>&nid=<%=nid%>"><button>目录</button></a>
       <a href="novel_read.jsp?id=<%=id0%>&usertype=<%=usertype%>&nid=<%=nid%>&chapter=<%=chapterAdd%>"><button>下一章</button></a>
     </div>
     <div class="main_container_show_show"><%out.print(content_show); %></div>
     <div class="main_container_show_operate">
       <a href="novel_read.jsp?id=<%=id0%>&usertype=<%=usertype%>&nid=<%=nid%>&chapter=<%=chapterSub%>"><button>上一章</button></a>
       <a href="novel_item_info.jsp?id=<%=id0%>&usertype=<%=usertype%>&nid=<%=nid%>"><button>目录</button></a>
       <a href="novel_read.jsp?id=<%=id0%>&usertype=<%=usertype%>&nid=<%=nid%>&chapter=<%=chapterAdd%>"><button>下一章</button></a>
     </div>
  </div>
</div>
</body>
</html>