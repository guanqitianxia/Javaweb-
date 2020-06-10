<%@ page language="java" import="java.util.Random,java.awt.*,java.awt.event.*,java.sql.*,javax.swing.*" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link href="CSS\regist.css" rel="stylesheet" type="text/css" media="all">
<title>注册</title>
</head>
<body>
<div class="header">
  <span class="title">视听网站</span>
</div>
<a href="login.html"><button class="returnBtn">返回</button></a>
<%
String usertype=request.getParameter("usertype"); 
if(usertype==null){usertype="reader";}
int id=0;
try{
	Class.forName("com.mysql.cj.jdbc.Driver");
	Connection conn=DriverManager.getConnection("jdbc:mysql://localhost:3306/redlen?serverTimezone=UTC&&useUnicode=true&&characterEncoding=UTF-8","chenguanhao","jisuanji");
	Statement stmt=conn.createStatement();
	String sql_temp="";
	String sql="";
	ResultSet rs;
	Random rand=new Random();
	int randNid=0;
	if(usertype.equals("reader")){sql_temp="select * from novelreaderinfo where rid=";}
	if(usertype.equals("author")){sql_temp="select * from novelauthorinfo where aid=";}
	do
	{
		randNid =rand.nextInt(99999 - 10000 + 1) + 10000;
		sql=sql_temp+randNid;
		rs=stmt.executeQuery(sql);
		
	}while(rs.next());//数据库中不存在该id
	id=randNid;
	conn.close();
}catch(Exception e){
		System.out.println("error"+e.toString());
}

%>
<script>
function getvalue(){
	var allValue;
	var flag=0;
	var flag1=0;
	<%if(usertype.equals("reader")){
		%>
		var rid=document.getElementById("rid").value;
		var rpassword=document.getElementById("rpassword").value;
		if(rpassword==''){alert('密码不能为空');rpassword.style.color="red";docuemnt.getElementById("rpassword").focus();}else{flag=flag+1;}
		var rname=document.getElementById("rname").value;
		if(rname==''){alert('用户名不能为空');rname.style.color="red";docuemnt.getElementById("rname").focus();}else{flag=flag+1;}
		var rsex=document.getElementById("rsex").value;
		var rmail=document.getElementById("rmail").value;if(rmail==''){rmail="null";}
		var rposition=document.getElementById("rposition").value;if(rposition==''){rposition="null";}
		var raddress=document.getElementById("raddress").value;if(raddress==''){raddress="null";}
		allValue=rpassword+","+rid+","+rname+","+"小白,"+rsex+","+rmail+","+rposition+","+raddress;
		
		<%
	}else{
		%>
		var aid=document.getElementById("aid").value;
		var apassword=document.getElementById("apassword").value;if(apassword==''){alert('密码不能为空');docuemnt.getElementById("apassword").focus();}else{flag1=flag1+1;}
		var arealname=document.getElementById("arealname").value;if(arealname==''){alert('名字不能为空');docuemnt.getElementById("arealname").focus();}else{flag1=flag1+1;}
		var apenname=document.getElementById("apenname").value;if(apenname==''){alert('笔名不能为空');docuemnt.getElementById("apenname").focus();}else{flag1=flag1+1;}
		var asex=document.getElementById("asex").value;var aidentityID=document.getElementById("aidentityID").value;if(aidentityID==''){aidentityID="null";}
		var aphone=document.getElementById("aphone").value;if(aphone==''){aphone="null";}
		var aqq=document.getElementById("aqq").value;if(aqq==''){aqq="11111";}
		var amail=document.getElementById("amail").value;if(amail==''){amail="null";}
		var apositionC=document.getElementById("apositionC").value;if(apositionC==''){apositionC="null";}
		var apositionX=document.getElementById("apositionX").value;if(apositionX==''){apositionX="null";}
		allValue=apassword+","+aid+","+arealname+","+apenname+","+"新手,"+aidentityID+","+asex+","+apositionC+","+apositionX+","+aphone+","+amail+","+aqq;
		<%
	}%>
	alert(allValue);
	document.getElementById("tempString").value=allValue;
	if(flag==2||flag1==3)
	{
	document.thisform.submit();
	}else{
		alert("sdf");
	}
	
}
</script>
<form class="thisform" name="thisform" action="regist_Judge.jsp?usertype=<%=usertype%>&id=<%=id%>" method="post">
<input type="hidden" id="tempString" name="tempString"/><!-- 隐形控件 -->
<div class="registContainer">
  <%
  if(usertype.equals("reader"))
  {
	  %>
	  <div class="ConTil">读者注册</div>
	  <div class="ConList">
	    <ul>
	      <li><span>ID:</span><input type="text" id="rid" name="rid" readonly="readonly" value="<%out.print(id);%>"></li>
	      <li><span>密码:</span><input type="password" maxlength="10" id="rpassword" name="rpassword" value=""></li>
	      <li><span>用户名:</span><input type="text" maxlength="30" id="rname" name="rname" value=""></li>
	      <li><span>性别:</span>
	      <select id="rsex" name="rsex">
	        <option value="1">男</option>
	        <option value="01">女</option>
	      </select>
	      </li>
	      <li><span>邮箱:</span><input type="text" id="rmail" name="rmail" maxlength="40" style="ime-mode:disabled" value=""></li>
	      <li><span>地址:</span><input type="text" id="rposition" name="rposition" maxlength="100" value=""></li>
	      <li><span>收货（详细）地址:</span><input type="text" id="raddress" name="raddress" maxlength="150" value=""></li>
	    </ul>
	  </div>
	  <%
  }else{
	  %>
	  <div class="ConTil">作者注册</div>
	  <div class="ConList">
	    <ul>
	      <li><span>ID:</span><input type="text" id="aid" name="aid" readonly="readonly" value="<%out.print(id);%>"></li>
	      <li><span>密码:</span><input type="password" maxlength="10" id="apassword"name="apassword" value=""></li>
	      <li><span>真名:</span><input type="text" maxlength="30" id="arealname" name="arealname" value=""></li>
	      <li><span>笔名:</span><input type="text" maxlength="30" id="apenname" name="apenname" value=""></li>
	      <li><span>性别:</span>
	      <select id="asex" name="asex">
	        <option value="1">男</option>
	        <option value="01">女</option>
	      </select>
	      </li>
	      <li><span>身份证号:</span><input type="text" maxlength="30" id="aidentityID" name="aidentityID" value=""></li>
	      <li><span>手机号:</span><input type="number" maxlength="11" id="aphone" name="aphone" value=""></li>
	      <li><span>QQ:</span><input type="number" maxlength="11" id="aqq"name="aqq" value=""></li>
	      <li><span>邮箱:</span><input type="text" maxlength="20" id="amail" name="amail" style="ime-mode:disabled" value=""></li>
	      <li><span>常用地址:</span><input type="text" maxlength="50" id="apositionC" name="apositionC" value=""></li>
	      <li><span>详细地址:</span><input type="text" maxlength="50" id="apositionX" name="apositionX" value=""></li>
	    </ul>
	  </div>
	  <%
  }
  %>
      <div class="ConBtn">
	    <button type="button" onclick="getvalue()">确定</button>
	  </div>
</div>
</form>

</body>
</html>