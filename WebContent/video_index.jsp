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
<link href="CSS\video_index.css" rel="stylesheet" type="text/css" media="all">
<title>视听网站-视频-电影</title>
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
<div class="search-container">
    <form action="video_search.jsp?id=<%=id0%>&usertype=<%=usertype%>" method="post">
      <input type="text" placeholder=" 搜索...." name="search">
      <button type="submit">提交</button>
    </form>
</div>

 <div class="parent_classify">
   <a href="video_index.jsp?id=<%=id0%>&usertype=<%=usertype%>"><button style="background-color:#ccc" onclick="Export()" type="submit">电影</button></a>
   <a href="video_comic.jsp?id=<%=id0%>&usertype=<%=usertype%>"><button>动漫</button></a>
   <a href="video_drama.jsp?id=<%=id0%>&usertype=<%=usertype%>"><button>电视剧</button></a>
   <a href="video_variety.jsp?id=<%=id0%>&usertype=<%=usertype%>"><button>综艺</button></a>
   <button>小视频</button>
 </div>
 
 <div class="sub_classify">
   <button onclick="Export()" type="submit">确定</button>
   <label><input name="sub_clif" value="china" type="checkbox" />中国</label>
   <label><input name="sub_clif" value="euam" type="checkbox" />欧美</label>
   <label><input name="sub_clif" value="asia" type="checkbox" />亚洲</label>
     <br>
   <label><input name="sub_clif" value="comedy" type="checkbox" />喜剧</label>
   <label><input name="sub_clif" value="science" type="checkbox" />科幻</label>
   <label><input name="sub_clif" value="military" type="checkbox" />军事</label>
   <label><input name="sub_clif" value="love" type="checkbox" />爱情</label>
   <label><input name="sub_clif" value="terror" type="checkbox" />恐怖</label>
   <label><input name="sub_clif" value="urban" type="checkbox" />都市</label>
   <label><input name="sub_clif" value="youth" type="checkbox" />青春</label>
   <form name="thisform" method="post">
   <input type="hidden" id="tempString" name="tempString"/><!-- 隐形控件 -->
   </form>
 </div>
 <!-- 获取checkbox的值 -->
 <script>

 function Export(){
	 var obj=document.getElementsByName("sub_clif");
	 var sub_clif="";
	 var temp="";
	 for(var i=0;i<obj.length;i++){
		 if(obj[i].checked){
			 //sub_clif.push(obj[i].value);
			 temp=obj[i].value;
			 sub_clif=sub_clif+","+temp;
		 }
	 }
	 alert(sub_clif);
	 document.getElementById("tempString").value=sub_clif
	 .substring(1,sub_clif.length);
	 document.thisform.submit();
	
 }
 </script>
<action>
 <%
//String judge=request.getParameter("judge");
String tempString=request.getParameter("tempString");

 String temp[]=null;
if(tempString!=null)
{
	temp= tempString.split(",");
}
 
int[] vidlist=new int[300];//保存满足条件的视频id号
int id_num=0;
String type[]=new String[4];//类型
Connection conn=null;
Statement stmt=null;
String sql="select * from videobase where type0='film'";
int flag=1;
try
{
	
	Class.forName("com.mysql.cj.jdbc.Driver");
	conn=DriverManager.getConnection("jdbc:mysql://localhost:3306/redlen?serverTimezone=UTC","chenguanhao","jisuanji");
	stmt=conn.createStatement();
	ResultSet rs=stmt.executeQuery(sql);
	while(rs.next())
	{
		
		int vid_1=rs.getInt("vid");
		type[1]=rs.getString("type1");
		type[2]=rs.getString("type2");
		type[3]=rs.getString("type3");
		
		if(tempString==null)
		{
			flag=1;
		}else{
			for(int i=0;i<tempString.split(",").length;i++)
			{
				if(type[1].equals(temp[i]) || type[2].equals(temp[i]) || type[3].equals(temp[i]))
				{//有存在不符合选择类型的'
					flag=1;
					continue;
					//out.print(vidlist[id_num]);
				}else{
					flag=0;
				}
			}
		}
		
		
		if(flag==1)
		{
			vidlist[id_num]=vid_1;
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
finally{
	conn.close();
}

%>
<div class="video_container">
<%

Class.forName("com.mysql.cj.jdbc.Driver");
conn=DriverManager.getConnection("jdbc:mysql://localhost:3306/redlen?serverTimezone=UTC","chenguanhao","jisuanji");
stmt=conn.createStatement();
String imagepath="";
String name1="";
int show_num=0;
for(int j=0;j<id_num;j++)
{
	
	sql="select * from videomessage where vid="+vidlist[j];
	ResultSet rs1=stmt.executeQuery(sql);
	while(rs1.next())
	{
		imagepath=rs1.getString("imagepath");
		name1=rs1.getString("name");
	}
	//out.print(imagepath);
	if(j%4==0)
	{
		show_num=0;
		%>
		<div class="container_list">
		<%
	}
	%>
	<a href="video_play.jsp?name=<%=vidlist[j]%>&id=<%=id0%>&usertype=<%=usertype%>">"><div class="container_item">
         <img src="<%out.print(imagepath);%>" alt=""/>
         <div>
           <span><%out.print(name1);%></span>
         </div>
      </div></a>
	<%
	show_num++;
	if(show_num==4)
	{
		%>
		</div>
		<%
	}
}
if(show_num!=4)//数量不足够凑一行时
{
	%>
	</div>
	<%
}
conn.close();


 %>
 </div>
 </action>
</body>
</html>