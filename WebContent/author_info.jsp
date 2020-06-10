<%@ page language="java" import="java.util.Random,java.awt.*,java.awt.event.*,java.sql.*,javax.swing.*,java.util.ArrayList" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link href="CSS\\author_info.css" rel="stylesheet" type="text/css" media="all">
<title>作者专区-个人资料</title>
</head>
<body>
<%
int ims=0;
String username=request.getParameter("aid");
if(username==null||username.equals("0")){username="999999";}
int aid=0;
if(username!=null){aid=Integer.parseInt(username);}
%>
<div class="header">
  <a href="index.jsp?id=<%=aid%>&usertype=1"><button><img src="PIC\home.jpg" alt=""/>视听首页</button></a>
  <a href="novel_index.jsp?id=<%=aid%>&usertype=1"><button><img src="PIC\bookhome.jpg" alt=""/>小说首页</button></a>
  <a href="login.html"><button style='float:right;font-size:15px;'>注销</button></a>
</div>
<%
//获取操作参数
String operate=request.getParameter("operate");
String operate1=request.getParameter("operate1");if(operate1==null){operate1="nul";}
if(operate==null)
{
	operate="read";
}
//读取

//aid=100001;//测试用
//作者信息
String arealname="",apenname="",agrade="",aidentityID="",apositionC="",apositionX="",aphone="",amail="",aimagepath="";
int asex=0,aqq=0;
try{
	String sql="select * from novelauthorinfo where aid="+aid;
	Class.forName("com.mysql.cj.jdbc.Driver");
	Connection conn=DriverManager.getConnection("jdbc:mysql://localhost:3306/redlen?serverTimezone=UTC&&useUnicode=true&&characterEncoding=UTF-8","chenguanhao","jisuanji");
	Statement stmt=conn.createStatement();
	ResultSet rs=stmt.executeQuery(sql);
	while(rs.next()){
	arealname=rs.getString("arealname");apenname=rs.getString("apenname");agrade=rs.getString("agrade");
	aidentityID=rs.getString("aidentityID");apositionC=rs.getString("apositionC");apositionX=rs.getString("apositionX");
	aphone=rs.getString("aphone");amail=rs.getString("amail");aqq=rs.getInt("aqq");aimagepath=rs.getString("aimagepath");
	asex=rs.getInt("asex");
	}
	
	conn.close();
	
}catch(Exception e){
	System.out.println("error"+e.toString());
}
aimagepath=aimagepath.replace('\\','/');
%>
<div class="catalog">
   <ul>
     <li><a href="author_info.jsp?operate=read&aid=<%=aid%>">个人资料</a></li>
    <li class="dropbtn"><a href="">实体书</a>
      <div class="dropdown">
        <a href="author_bookmanage.jsp?booktype=entitymanage&aid=<%=aid%>">管理</a>
        <a href="">数据统计</a>
      </div>
    </li>
    <li class="dropbtn"><a href="">电子书</a>
      <div class="dropdown">
        <a href="author_bookmanage.jsp?booktype=netmanage&aid=<%=aid%>">管理</a>   
        <a href="">数据统计</a>
      </div>
    </li>
   </ul>
</div>
<script>
window.onload=function(){
	//draw();
	var cvs=document.getElementById('authorcanvas');
	var imagepath="<%out.print(aimagepath);%>";
	var ctx=cvs.getContext('2d');
	var img=new Image();
	img.onload=function(){
		ctx.drawImage(img,0,0,300,160);
	}
	img.src=imagepath;
	//alert(imagepath);
	cvs.addEventListener('click',function(e){
		document.getElementById("imgupload").click()
	});
}
function draw(){
    var imagepath=document.getElementById('imgupload').value;
    document.getElementById('authorimage').src=imagepath;
}
function drawcanvas(){
	var image;
    let file = document.querySelector('input[type=file]').files[0]  // 获取选择的文件，这里是图片类型
    var imagepath=document.getElementById('imgupload').value;
    let reader = new FileReader()
    reader.readAsDataURL(file) //读取文件并将文件以URL的形式保存在resulr属性中 base64格式
    reader.onload = function(e) { // 文件读取完成时触发 
        let result = e.target.result // base64格式图片地址 
        image = new Image();
        image.src = result // 设置image的地址为base64的地址 
        image.onload = function(){ 
            var canvas = document.querySelector("#authorcanvas"); 
            var context = canvas.getContext("2d"); 
            canvas.width = 100; // 设置canvas的画布宽度为图片宽度 image.width to 100px;
            canvas.height = 100; 
            context.drawImage(image, 0, 0, 100, 100) // 在canvas上绘制图片 
        } 
    }
}
function saveFunc(){
	var arealname=document.getElementById('arealname').value;
    var apenname=document.getElementById('apenname').value;
    var agrade=document.getElementById('agrade').value;
    var aidentityID=document.getElementById('aidentityID').value;
    var asex=document.getElementById('asex').value;
    var apositionC=document.getElementById('apositionC').value;
    var apositionX=document.getElementById('apositionX').value;
    var aphone=document.getElementById('aphone').value;
    var amail=document.getElementById('amail').value;
    var aqq=document.getElementById('aqq').value;
    
    var all=arealname+","+apenname+","+agrade+","+aidentityID+","+asex+","+apositionC+","+apositionX+","+aphone+","+amail+","+aqq;

    document.getElementById("allcontent").value=all
	document.uploadimg.submit();
}
</script>
<div class="info">
  <form action="AuthorUploadServlet?aid=<%=aid%>&aimagepath=<%=aimagepath %>" name="uploadimg" method="post" enctype="multipart/form-data">
  
  <input type="hidden" id="allcontent" name="allcontent"/><!-- 隐形控件 -->
  <div class="image">
    <input type="file" name="imgupload" id="imgupload" style="display:none;" onchange="drawcanvas()" multiple="multiple"/>
    <canvas id="authorcanvas"></canvas>
    <p><%out.print(apenname); %></p>
  </div>
  
  <div class="information">
    <ul>
       <li>笔名:<input type="text" maxlength="30" id="apenname" name="apenname" value="<%out.print(apenname); %>"></li>
       <li>真名:<input type="text" maxlength="30" id="arealname" name="arealname" value="<%out.print(arealname); %>"></li>
       <li>称号等级:<input type="text" id="agrade"name="agrade" readonly="readonly" value="<%out.print(agrade); %>"></li>
       <li>作家ID:<input type="text" aid="aid"aname="ID" readonly="readonly" value="<%out.print(aid); %>"></li>
       <li>证件号:<input type="text" maxlength="30" style="ime-mode:disabled" id="aidentityID"name="aidentityID" value="<%out.print(aidentityID); %>"></li>
       <li>性别:
       <select id="asex" name="asex">
         <%if(asex==1)
        	{
        	 %>
        	 <option value="1" selected = "selected">男</option>
             <option value="0">女</option>
        	 <%
        	}else{
        	  %>
           	 <option value="1">男</option>
              <option value="0" selected = "selected">女</option>
           	 <%
        	}
          %>
       </select>
       </li>
       <li>常住地:<input type="text" maxlength="50" id="apositionC" name="apositionC" value="<%out.print(apositionC); %>"></li>
       <li>详细地址:<input type="text" maxlength="50" id="apositionX" name="apositionX" value="<%out.print(apositionX); %>"></li>
       <li>手机号码:<input type="number" maxlength="11" id="aphone" name="aphone" value="<%out.print(aphone); %>"></li>
       <li>电子邮箱:<input type="text" maxlength="20" style="ime-mode:disabled" id="amail" name="amail" value="<%out.print(amail); %>"></li>
       <li>QQ号:<input type="number" maxlength="11" id="aqq" name="aqq" value="<%out.print(aqq); %>"></li>
    </ul>
    <button type="button" onclick="saveFunc()">保存</button>
  </div>
</form>
<%
%>
</div>
</body>
</html>