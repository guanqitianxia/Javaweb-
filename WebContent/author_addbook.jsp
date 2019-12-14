<%@ page language="java" import="java.awt.*,java.awt.event.*,java.sql.*,javax.swing.*,java.util.ArrayList" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<jsp:useBean id="book" class="BookPackage.entitybook"></jsp:useBean>
<jsp:setProperty property="*" name="book"/>
<%
request.setCharacterEncoding("utf-8"); 
response.setCharacterEncoding("utf-8"); 
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link href="CSS\author_addbook.css" rel="stylesheet" type="text/css" media="all">
<title>添加书籍</title>
</head>
<body>
<script type="text/javascript">
function getbtype(){
	var flag=0;
	var btypeselect=document.getElementById("btype");
	var index=btypeselect.selectedIndex;
	var btype=btypeselect.options[index].value;
	
	var bname=document.getElementById("bname").value;
	if(bname==""){alert("书名不能为空");$("#bname").css('color','red');}
	else{flag=flag+1;
	var bauthor=document.getElementById("bauthor").value;
	if(bauthor==""){alert("书籍作者不能为空");}
	else{flag=flag+1;var bmoney=document.getElementById("bmoney").value;
	if(bmoney==""){alert("书籍价格不能为空");}
	else{flag=flag+1;var bnumber=document.getElementById("bnumber").value;
	if(bnumber==""){alert("书籍剩余数量不能为空");}
	else{flag=flag+1;var bintro=document.getElementById("bintro").value;
	if(bintro==""){alert("书籍介绍不能为空");}
	else{flag=flag+1;}}}}}

	if(flag==5){
		document.addbookform.submit();
	}
}
</script>
<%
//获取操作
String operate=request.getParameter("operate");
if(operate==null){operate="other";}
String operate1=request.getParameter("operate1");
if(operate1==null){operate1="other";}
int aid=0,bid=0;
String username=request.getParameter("aid");
String bid_temp=request.getParameter("bid");
if(username==null||username.equals("0")){username="0";}if(username!=null){aid=Integer.parseInt(username);}
if(bid_temp==null||bid_temp.equals("0")){bid_temp="0";}if(bid_temp!=null){bid=Integer.parseInt(bid_temp);}

String bname0="",btype0="",bauthor0="";
int bmoney0=0,bnumber0=0;
String bintro0="";
if(operate.equals("update"))
{
	try{
		Class.forName("com.mysql.cj.jdbc.Driver");
		Connection conn=DriverManager.getConnection("jdbc:mysql://localhost:3306/redlen?serverTimezone=UTC&&useUnicode=true&&characterEncoding=UTF-8","root","jisuanji");
		String sql="select * from novelauthorentity where aid="+aid+" and bid="+bid;
		Statement stmt=conn.createStatement();
		ResultSet rs=stmt.executeQuery(sql);
		while(rs.next()){
			bname0=rs.getString("bname");
			btype0=rs.getString("btype");
			bauthor0=rs.getString("bauthor");
			bmoney0=rs.getInt("bmoney");
			bnumber0=rs.getInt("bnumber");
			bintro0=rs.getString("bintro");
		}
	}catch(Exception e){
		System.out.println("error"+e.toString());
	}
	
}
if(operate.equals("insert"))
{
	bid=bid+1;
}
if(operate1.equals("update")){
	//获取信息
		String btype=request.getParameter("btype");
		String bname=request.getParameter("bname");
		if(bname==null){bname="isnull";}else{bname= new String(request.getParameter("bname").getBytes("iso-8859-1"), "utf-8");}
		String bmoney_temp=request.getParameter("bmoney");
		int bmoney=0;
		if(bmoney_temp!=null){if(!bmoney_temp.equals("")){bmoney=Integer.parseInt(bmoney_temp);}}
		String bnumber_temp=request.getParameter("bnumber");
		int bnumber=0;
		if(bnumber_temp!=null){if(!bnumber_temp.equals("")){bnumber=Integer.parseInt(bnumber_temp);	}}
		String bintro=request.getParameter("bintro");
		if(bintro==null){bintro="isnull";}else{bintro=new String(request.getParameter("bintro").getBytes("iso-8859-1"), "utf-8");}
		String bauthor=request.getParameter("bauthor");
		if(bauthor==null){bauthor="isnull";}else{bauthor=new String(request.getParameter("bauthor").getBytes("iso-8859-1"), "utf-8");}
		try{
			Class.forName("com.mysql.cj.jdbc.Driver");
			Connection conn=DriverManager.getConnection("jdbc:mysql://localhost:3306/redlen?serverTimezone=UTC&&useUnicode=true&&characterEncoding=UTF-8","root","jisuanji");
			String sql="update novelauthorentity set aid=?,bid=?,bname=?,btype=?,bmoney=?,bnumber=?,bintro=?,bauthor=? where aid="+aid+" and bid="+bid;
			
			PreparedStatement ps=conn.prepareStatement(sql);
			ps.setInt(1, aid);
			ps.setInt(2,bid);
			ps.setString(3,bname);
			ps.setString(4,btype);
			ps.setInt(5,bmoney);
			ps.setInt(6,bnumber);
			ps.setString(7,bintro);
			ps.setString(8,bauthor);
			
			int row=ps.executeUpdate();
			ps.close();
			conn.close();
			%>
			<script type="text/javascript">
			alert("修改成功");
			</script>
			<%
		}catch(Exception e){
			System.out.println("error"+e.toString());
		}
		
}
if(operate1.equals("insert"))//不为空才创建
{
	//获取信息
	String btype=request.getParameter("btype");
	String bname=request.getParameter("bname");
	if(bname==null){bname="isnull";}else{bname= new String(request.getParameter("bname").getBytes("iso-8859-1"), "utf-8");}
	String bmoney_temp=request.getParameter("bmoney");
	int bmoney=0;
	if(bmoney_temp!=null){if(!bmoney_temp.equals("")){bmoney=Integer.parseInt(bmoney_temp);}}
	String bnumber_temp=request.getParameter("bnumber");
	int bnumber=0;
	if(bnumber_temp!=null){if(!bnumber_temp.equals("")){bnumber=Integer.parseInt(bnumber_temp);	}}
	String bintro=request.getParameter("bintro");
	if(bintro==null){bintro="isnull";}else{bintro=new String(request.getParameter("bintro").getBytes("iso-8859-1"), "utf-8");}
	String bauthor=request.getParameter("bauthor");
	if(bauthor==null){bauthor="isnull";}else{bauthor=new String(request.getParameter("bauthor").getBytes("iso-8859-1"), "utf-8");}
try{
	Class.forName("com.mysql.cj.jdbc.Driver");
	Connection conn=DriverManager.getConnection("jdbc:mysql://localhost:3306/redlen?serverTimezone=UTC&&useUnicode=true&&characterEncoding=UTF-8","root","jisuanji");
	String sql="insert into novelauthorentity(aid,bid,bname,btype,bmoney,bnumber,bintro,bauthor) value(?,?,?,?,?,?,?,?)";
	
	PreparedStatement ps=conn.prepareStatement(sql);
	ps.setInt(1, aid);
	ps.setInt(2,bid);
	ps.setString(3,bname);
	ps.setString(4,btype);
	ps.setInt(5,bmoney);
	ps.setInt(6,bnumber);
	ps.setString(7,bintro);
	ps.setString(8,bauthor);
	
	int row=ps.executeUpdate();
	ps.close();
	conn.close();
	%>
	<script type="text/javascript">
	alert("插入<%out.print(row);%>行成功");
	</script>
	<%
}catch(Exception e){
	System.out.println("error"+e.toString());
}
}
%>
<div class="booklist">
  <form action="author_addbook.jsp?operate1=<%=operate %>&aid=<%=aid%>&bid=<%=bid%>" name="addbookform" method="post">
  <ul>
    <li><span>书籍名称:</span><input type="text" placeholder="输入书籍名称" id="bname" name="bname" value="<%out.print(bname0);%>"></li>
    <li><span>书籍类型:</span>
             <select id="btype" name="btype">
               <option value="xuanhuan">玄幻</option>
               <option value="wuxia">武侠</option>
               <option value="xianxia">仙侠</option>
               <option value="dushi">都市</option>
               <option value="junshi">军事</option>
               <option value="lishi">历史</option>
               <option value="xuanyi">悬疑</option>
               <option value="kehuan">科幻</option>
               <option value="youxi">游戏</option>
             </select>
    </li>
    <li><span>书籍作者:</span><input type="text" placeholder="输入书籍作者" id="bauthor" name="bauthor" value="<%out.print(bauthor0);%>"></li>
    <li><span>金额:</span><input type="number" placeholder="输入书籍所需金额" id="bmoney" name="bmoney" value="<%out.print(bmoney0);%>"></li>
    <li><span>数量:</span><input type="number" placeholder="输入书籍剩余数量" id="bnumber" name="bnumber" value="<%out.print(bnumber0);%>"></li>
    <li><span>相关介绍:</span><textarea rows="5" placeholder="输入书籍相关介绍" id="bintro" name="bintro"><%out.print(bintro0);%></textarea></li>
    <li class="btn"><button onclick="getbtype()" type="button" onclick="addconfirm">确定</button></li>
  </ul>
  </form>
</div>
</body>
</html>