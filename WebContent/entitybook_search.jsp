<%@ page language="java" import="java.awt.*,java.awt.event.*,java.sql.*,javax.swing.*,java.util.ArrayList" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%
request.setCharacterEncoding("utf-8"); 
response.setCharacterEncoding("utf-8"); 
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link href="CSS\entitybook_search.css" rel="stylesheet" type="text/css" media="all">
<title>实体书搜索结果</title>
</head>
<body>
<%
String username0=request.getParameter("id");int id0=0;if(username0!=null){id0=Integer.parseInt(username0);}
String usertype=request.getParameter("usertype");
id0=200001;usertype="1";//测试
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
		conn0=DriverManager.getConnection("jdbc:mysql://localhost:3306/redlen?serverTimezone=UTC&&useUnicode=true&&characterEncoding=UTF-8","root","jisuanji");
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
<!-- 实体书 -->
<div class="operation">
  <a href="entitybook.jsp?operate=city&id=<%=id0%>&usertype=<%=usertype%>"><button><img src="PIC\shoppingCity.png" alt=""/>返回实体书专窗</button></a>
</div>
<script>
function addshel(name,bid){
	var subornot=confirm("将"+name+"加入购物车");
	document.getElementById("bid").value=bid;
	if(subornot==true){
		document.addtoshel.submit();	
	}
	//document.getElementById("addtoshel").submit();
}
</script>
<form action="cartServlet?id=<%=id0%>&sql_operate=insert&usertype=<%=usertype%>" id="addtoshel" name="addtoshel" method="post">
      <input type="hidden" id="bid" name="bid"/>
</form>
<div class="entity_searchshow">
  <ul>
  <c:forEach items="${key_list}" var="usr" varStatus="idx">
    <li>
      <p class="bname">${usr.bname}</p>
      <p><span class="bmoney">￥${usr.bmoney}</span><span class="bnumber">库存：${usr.bnumber}本</span></p>
      <p class="bauthor_btype">${usr.bauthor} 著/${usr.btype}</p>
      <p class="bintro">${usr.bintro}</p>
      <button type="button" onclick="addshel('${usr.bname}','${usr.bid}')">加入购物车</button>
    </li>
   </c:forEach>
  </ul>
</div>
</body>
</html>