<%@ page language="java" import="java.awt.*,java.awt.event.*,java.sql.*,javax.swing.*,java.util.ArrayList" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8" isELIgnored="false"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%
request.setCharacterEncoding("utf-8"); 
response.setCharacterEncoding("utf-8"); 
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=uft-8">
<link href="CSS\entitybook.css" rel="stylesheet" type="text/css" media="all">
<title>实体书专窗</title>
</head>
<body>
<%
String SF=request.getParameter("SF");
if(SF!=null){
	if(SF.equals("1")){%><script>alert("提交成功")</script><%}else{%><script>alert("余额不足")</script><%}
}
String username0=request.getParameter("id");
int id0=0;if(username0!=null){id0=Integer.parseInt(username0);}
String usertype=request.getParameter("usertype");
//id0=100001;usertype="0";//测试
String sql0="";String getname="";
if(usertype.equals("1")){
	sql0="select * from novelauthorinfo where aid="+id0;getname="apenname";
}else{
	sql0="select * from novelreaderinfo where rid="+id0;getname="rname";
}
Connection conn=null;
Statement stmt0=null;

String name0="";
if(username0!=null)
{
	try
	{
		Class.forName("com.mysql.cj.jdbc.Driver");
		conn=DriverManager.getConnection("jdbc:mysql://localhost:3306/redlen?serverTimezone=UTC&&useUnicode=true&&characterEncoding=UTF-8","root","jisuanji");
		stmt0=conn.createStatement();
		ResultSet rs=stmt0.executeQuery(sql0);
		rs.next();
		name0=rs.getString(getname);
		
		conn.close();
	}
	catch(Exception e){
		System.out.println("error"+e.toString());
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
	  <a href="reader_info.jsp?rid=<%=id0%>&usertype=<%=usertype%>&operate=bookshell"><button>书架</button></a>
	  <%
  }
  %>
</div>
<%

%>
<div class="main_container">
  <!-- 最顶部的分类 -->
  <div class="main_container_header">
  <ul>
    <li><a class="active" href="novel_index.jsp?type=all&id=<%=id0%>&usertype=<%=usertype%>">全部作品</a></li>
    <li><a class="active" href="novel_index.jsp?type=finsh&id=<%=id0%>&usertype=<%=usertype%>">完本</a></li>
    <li><a class="active" href="">排行榜</a></li>
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
</div>
 
<div class="operation">
  <a href="entitybook.jsp?operate=city&id=<%=id0%>&usertype=<%=usertype%>"><button><img src="PIC\shoppingCity.png" alt=""/>实体书商城</button></a>
  <form action="cartServlet?id=<%=id0%>&usertype=<%=usertype%>&sql_operate=readtocart" method="post" enctype="multipart/form-data">
  <button class="special" type="submit"><img src="PIC\shoppingCat.png" alt=""/>购物车</button>
  </form>
</div>
<%
String operate=request.getParameter("operate");
//operate="city";//测试
if(operate.equals("city"))
{
%>
<div class="entity_search">
    <script>
    function EntiSeaID(){
    	document.entiseaID.submit();
    }
    function EntiSeaName(){
    	document.entiseaName.submit();
    }
    function EntiSeaType(){
    	document.entiseaType.submit();
    }
    </script>
    <div class="entity_search_title">查询</div>
     <ul>
        <form action="EntiSeaServlet?searchtype=bid" name="entiseaID" method="post">
        <li><input type="number" placeholder="按书籍编号查找" id="bookID" name="bookID"><img src="PIC\search.png" onclick="EntiSeaID()"/></li>
        </form>
        <form action="EntiSeaServlet?searchtype=bname" name="entiseaName" method="post">
        <li><input type="text" placeholder="按书籍名称查找" id="bookName" name="bookName"><img src="PIC\search.png" onclick="EntiSeaName()"/></li>
        </form>
        <form action="EntiSeaServlet?searchtype=btype" name="entiseaType" method="post">
        <li><input type="text" placeholder="按书籍类型查找(输入拼音)" style="ime-mode:disabled" id="bookType" name="bookType"><img src="PIC\search.png" onclick="EntiSeaType()"/></li>
        </form>
     </ul>
</div>
<script>
function showsMes(bid){
	var div=document.getElementById("showsMes"+bid);
	div.style.display="block";
}
function MesSubmit(){
	document.insertform.submit();
}
function Mesreturn(bid){
	var div=document.getElementById("showsMes"+bid);
	div.style.display="none";
}
</script>

<div class="book_show">
  <div class="book_table">
    <table id="book_table">
        <tr>
          <th>书籍编号</th>
          <th>商家编号</th>
          <th>名称</th>
          <th>类型</th>
          <th>作者</th>
          <th>金额</th>
          <th>剩余数量</th>
          <th>操作</th>
        </tr>
<%
//Connection conn=null;
Statement stmt=null;
String sql="select * from novelauthorentity";
int aid=0,bid=0,bmoney=0,bnumber=0;
String bname="",btype="",bauthor="";
try{
	Class.forName("com.mysql.cj.jdbc.Driver");
	conn=DriverManager.getConnection("jdbc:mysql://localhost:3306/redlen?serverTimezone=UTC&&useUnicode=true&&characterEncoding=UTF-8","root","jisuanji");
	stmt=conn.createStatement();
	ResultSet rs=stmt.executeQuery(sql);
	while(rs.next())
	{
		aid=rs.getInt("aid");bid=rs.getInt("bid");
		bmoney=rs.getInt("bmoney");bnumber=rs.getInt("bnumber");
		bname=rs.getString("bname");btype=rs.getString("btype");
		bauthor=rs.getString("bauthor");
		%>
		<tr>
          <td><%out.print(bid); %></td>
          <td><%out.print(aid); %></td>
          <td><%out.print(bname); %></td>
          <td><%switch(btype)
          {
          case "xuanhuan":out.print("玄幻");break; case "wuxia":out.print("武侠");break; case "xianxia":out.print("仙侠");break;
          case "dushi":out.print("都市");break; case "junshi":out.print("军事");break; case "lishi":out.print("历史");break;
          case "xuanyi":out.print("游戏");break; case "kehuan":out.print("科幻");break; case "youxi":out.print("游戏");break;
          default:
        	  out.print("无");
        	  break;
          }%></td>
          <td><%out.print(bauthor); %></td>
          <td><%out.print(bmoney); %>元</td>
          <td><%out.print(bnumber); %>本</td>
          <td>
          <form class="insertform" action="cartServlet?id=<%=id0%>&sql_operate=insert&bid=<%=bid %>&usertype=<%=usertype%>" method="post">
          <button type="button" onclick="showsMes(<%out.print(bid); %>)">加入购物车</button> 
          <div id="showsMes<%out.print(bid); %>" style="text-align:center;display:none;">
            <input type="number" name="value" placeholder="输入<%out.print(bid); %>号书籍的数量" style="width:260px;height:30px;border:none;"><br>
            <input type="button" class="showsMes" onclick="Mesreturn(<%out.print(bid); %>)" value="取消" style="width:130px;height:30px;border:none;">
            <input type="submit" class="showsMes" onclick="MesSubmit()" value="确认" style="width:130px;height:30px;border:none;">
          </div>
          </form>
          </td>
          
        </tr>
		<%
	}
	conn.close();
}catch(Exception e){
	System.out.println("error"+e.toString());
} 
%>
    </table>
  </div>
</div>
<%
}else{
	%>
	<div class="cartContainer">
	  <div class="cartTil">购物车</div>
	  <table>
	    <tr>
	     <th width="10%">序号</th>
	     <th width="30%">商品名称</th>
	     <th width="10%">价格(元)</th>
	     <th width="15%">&nbsp;数量(本)</th>
	     <th width="10%">库存(本)</th>
	     <th width="10%">小计</th>
	     <th width="10%">操作</th>
	    </tr>
	    <!-- 遍历购物车信息 -->
	    <script>
	    
	    </script>
	    <c:set var="total" value="0"/>
	    <c:forEach items="${cartlist}" var="book" varStatus="vs">
	    <tr>
	      <td width="10%">${vs.count}</td>
	      <td width="30%">${book.bname}</td>
	      <td width="10%">${book.bmoney}</td>
	      <td width="15%" style="padding-left:20px;">
	      <form class="updateMinusform" name="updateMinusform" action="cartServlet?id=<%=id0%>&sql_operate=updateMinus&cid=${book.cid}&bnumber=${book.bnumber}&bid=${book.bid}&usertype=<%=usertype%>" method="post">
	         <input type="submit" value='-' style="width:30px;text-align:center;float:left;border:none;" name="minus">
	      </form>
	         <input type="text" class="bvalue" value="${book.value}" name="value" style="width:50px;text-align:center;float:left;border:none;"/>
	      <form class="updatePlusform" name="updatePlusform" action="cartServlet?id=<%=id0%>&sql_operate=updatePlus&cid=${book.cid}&bnumber=${book.bnumber}&bid=${book.bid}&usertype=<%=usertype%>" method="post">   
	         <input type="submit" value='+' style="width:30px;text-align:center;float:left;border:none;" name="plus">
	      </form>
	      
	      </td>
	      <td width="10%"> &nbsp;${book.bnumber}</td>
	      <td width="10%">${book.bmoney*book.value }</td>
	      <td width="10%">
	      <form class="deleteform" name="deleteform" action="cartServlet?id=<%=id0%>&sql_operate=delete&cid=${book.cid}&usertype=<%=usertype%>" method="post">
	      <button type="submit" style="border:none;">删除</button>
	      </form>
	      </td>
	    </tr>
	    <c:set value="${total+book.bmoney*book.value }" var="total"> </c:set>
	    </c:forEach>
	  </table>
	  <!-- 合计信息 -->
	 <table cellspacing="1" class="carttable">
	   <tr>
	     <td style="text-align:center;padding-right:40px;">
	     <font style="color:#FF6600;font-weight:bold">合计:&nbsp;&nbsp;${total}元</font>
	     </td>
	   </tr>
	 </table>
	 <div class="cartLasBtn">
	   <!-- 继续购书 -->
	   <a href="entitybook.jsp?operate=city&id=<%=id0%>&usertype=<%=usertype%>"><button>继续购书</button></a>
	   <form class="orderform" name="orderform" action="cartServlet?id=<%=id0%>&sql_operate=order&total=${total}&usertype=<%=usertype%>" method="post">
	   <button>提交订单</button>
	   </form>
	 </div> 
	</div>
	<%
}
%>
</body>
</html>