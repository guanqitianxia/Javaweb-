<%@ page language="java" import="javax.swing.*,java.util.*,java.sql.*" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>注册后台</title>
</head>
<body>
<%
String usertype=request.getParameter("usertype");
String sql="",sql1="";
//String rpassword="",rname="",rgrade="小白",rmail="",rposition="",raddress="";int rid=0,rsex=0;

//String apassword="",arealname="", apenname="",agrade="新手",aidentityID="",apositionC="",apositionX="",aphone="",amail="";int aid=0,asex=0,aqq=0;

String allValue=new String(request.getParameter("tempString").getBytes("iso-8859-1"), "utf-8");
System.out.println(allValue);
String array[]=null;
if(allValue!=null)
{
	  array=allValue.split(",");
}
int flag=0;
Connection conn=null;
Statement stmt=null;

try
{
	Class.forName("com.mysql.cj.jdbc.Driver");
	conn=DriverManager.getConnection("jdbc:mysql://localhost:3306/redlen?serverTimezone=UTC&&useUnicode=true&&characterEncoding=UTF-8","root","jisuanji");
	PreparedStatement ps,ps1;
	//插入登录信息表
	sql1="insert into userlogin value(?,?,?)";
	int id=Integer.parseInt(array[1]);
	ps1=conn.prepareStatement(sql1);
	ps1.setInt(1,id);ps1.setString(2,array[0]);
	
	if(usertype.equals("reader"))
	{
		ps1.setInt(3,0);
		
		sql="insert into novelreaderinfo(rid,rname,rgrade,rsex,rmail,rposition,raddress) value(?,?,?,?,?,?,?)";
		ps=conn.prepareStatement(sql);
		for(int i=1;i<8;i++)
		{
			if(i==1||i==4){
				int temp=0;
				if(!array[i].equals("")){temp=Integer.parseInt(array[i]);}
				ps.setInt(i,temp);
			}else{
				ps.setString(i,array[i]);
			}
		}
		ps.executeUpdate();ps.close();
	}
	if(usertype.equals("author"))
	{
		ps1.setInt(3,1);
		
		sql="insert into novelauthorinfo(aid,arealname,apenname,agrade,aidentityID,asex,apositionC,apositionX,aphone,amail,aqq) value(?,?,?,?,?,?,?,?,?,?,?)";
		ps=conn.prepareStatement(sql);
		for(int i=1;i<12;i++)
		{
			if(i==1||i==6||i==11){
				int temp=0;
				if(!array[i].equals("")){temp=Integer.parseInt(array[i]);}
				ps.setInt(i,temp);
			}else{
				ps.setString(i,array[i]);
			}
		}
		ps.executeUpdate();ps.close();
	}
	ps1.executeUpdate();ps1.close();
	flag=1;
}
catch(SQLException e)
{
	%>
	<script>
	alert("注册失败");
	window.location.href="login.html?valus=registSuc";
	</script>
	<%
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
if(flag==1)
{
	%>
	<script>
	alert("注册成功");
	window.location.href="login.html?valus=registSuc";
	</script>
	<%
	//request.getRequestDispatcher("login.html?message=registSuc").forward(request, response);
	
}
%>
</body>
</html>