<%@ page language="java" import="java.awt.*,java.awt.event.*,java.sql.*,javax.swing.*,java.util.ArrayList" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%
request.setCharacterEncoding("UTF-8");
response.setCharacterEncoding("UTF-8");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link href="CSS\reader_info.css" rel="stylesheet" type="text/css" media="all">
<title>读者专区</title>
</head>
<body>
<%
String username=request.getParameter("rid");int rid=0;if(username!=null){rid=Integer.parseInt(username);}
String usertype=request.getParameter("usertype");
String sql0="";String getname="";
if(usertype.equals("1")){
	sql0="select * from novelauthorinfo where aid="+rid;getname="apenname";
}else{
	sql0="select * from novelreaderinfo where rid="+rid;getname="rname";
}
Connection conn0=null;
Statement stmt0=null;

String name0="";
if(username!=null)
{
	try
	{
		Class.forName("com.mysql.cj.jdbc.Driver");
		conn0=DriverManager.getConnection("jdbc:mysql://localhost:3306/redlen?serverTimezone=UTC&&useUnicode=true&&characterEncoding=UTF-8","chenguanhao","jisuanji");
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

String operate=request.getParameter("operate");

%>
<div class="header">
  <a href="index.jsp?id=<%=username%>&usertype=<%=usertype%>"><button><img src="PIC\home.jpg" alt=""/>视听首页</button></a>
  <a href="novel_index.jsp?id=<%=username%>&usertype=<%=usertype%>"><button><img src="PIC\bookhome.jpg" alt=""/>小说首页</button></a>
  <a href="login.html"><button style='float:right;font-size:15px;' id="cancel">注销</button></a>
</div>
<%
if(username==null)
{
	%>
	<div class="notlogin">
	  <h1>未登录</h1>
	  <a href="login.html">登录</a>
	</div>
	<%
}
Connection conn=null;
Statement stmt=null;
//novelreaderinfo表
String rname="",rgrade="",rmail="",rposition="",raddress="",rimagepath="";
//novelreaderwallet表
int rbalance=0,rticket=0,rsex=0;
//novelreadersubscribe表
String bname="",btime="";
int btype=1;
int bmoney=0,bnumber=0,subNid=0;
//novelreaderbookshelf表
int shelfNid=0;
if(username!=null)
{
	//rid=Integer.parseInt(username);
	String sql="";
	if(usertype.equals("0"))//非作者身份
	{
		sql="select * from novelreaderinfo i LEFT JOIN novelreaderwallet w ON i.rid=w.rid LEFT JOIN novelreaderbookshelf s ON i.rid=s.rid LEFT JOIN novelreadersubscribe c ON i.rid=c.rid where i.rid="+rid;
	}else{
		sql="select * from novelreaderwallet w,novelreadersubscribe c where w.rid=c.rid and w.rid="+rid;
	}
	//String sql="select * from novelreaderinfo i LEFT JOIN novelreaderwallet w ON i.rid=w.rid LEFT JOIN novelreaderbookshelf s ON i.rid=s.rid LEFT JOIN novelreadersubscribe c ON i.rid=c.rid where i.rid="+rid;
	String sql1="select * from novelbase where novelbase.nid in (select novelreaderbookshelf.nid from novelreaderbookshelf where rid="+rid+")";
	try
	{
		Class.forName("com.mysql.cj.jdbc.Driver");
		conn=DriverManager.getConnection("jdbc:mysql://localhost:3306/redlen?serverTimezone=UTC&&useUnicode=true&&characterEncoding=UTF-8","chenguanhao","jisuanji");
		stmt=conn.createStatement();
		ResultSet rs=stmt.executeQuery(sql);
		boolean rsnext=rs.next();
		if(rsnext){
			if(usertype.equals("0")){
				rname=rs.getString("i.rname");
				rgrade=rs.getString("i.rgrade");
				rmail=rs.getString("i.rmail");
				rposition=rs.getString("i.rposition");
				raddress=rs.getString("i.raddress");
				rsex=rs.getInt("i.rsex");
				rimagepath=rs.getString("i.imagepath");
			}

		rbalance=rs.getInt("w.rbalance");
		rticket=rs.getInt("w.rticket");
		}
		
if(usertype.equals("0"))//用户为读者
	{
	rimagepath=rimagepath.replace('\\','/');
		%>
		<div class="info">
		  <form action="ReaderUploadServlet?rid=<%=rid%>&rimagepath=<%=rimagepath %>" id="infoform" name="infoform" method="post" enctype="multipart/form-data">
		    <input type="hidden" id="allcontent" name="allcontent"/><!-- 隐形控件 -->
		  <input type="file" name="imgupload" id="imgupload" style="display:none;" onchange="drawcanvas()" multiple="multiple"/>
		  <canvas id="readercanvas"></canvas>
<script>
window.onload=function(){
	//draw();
	var cvs=document.getElementById('readercanvas');
	var imagepath="<%out.print(rimagepath);%>";
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
    document.getElementById('readerimage').src=imagepath;
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
            var canvas = document.querySelector("#readercanvas"); 
            var context = canvas.getContext("2d"); 
            canvas.width = 100; // 设置canvas的画布宽度为图片宽度 image.width to 100px;
            canvas.height = 100; 
            context.drawImage(image, 0, 0, 100, 100) // 在canvas上绘制图片 
        } 
    }
}
function deliver(){
	var name=document.getElementById('name').value;
    var sex=document.getElementById('sex').value;
    var mail=document.getElementById('mail').value;
    var position=document.getElementById('position').value;
    var redress=document.getElementById('redress').value;
    var all=name+","+sex+","+mail+","+position+","+redress;

    document.getElementById("allcontent").value=all
    document.infoform.submit();
   
}
</script>
		    <ul>
		     <li><span>用户名:</span><input type="text" maxlength="30" id="name"name="name" value="<%out.print(rname);%>"></li>
		     <li><span>ID:</span><input type="text" id="id"name="id" readonly="readonly" value="<%out.print(rid);%>"></li>
		     <li><span>等级:</span><input type="text" id="grade"name="grade" readonly="readonly" value="<%out.print(rgrade);%>"></li>
		     <li> <span>性别:</span>
		     <select id="sex" name="sex">
		         <%if(rsex==1)
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
		     <li><span>邮箱:</span><input type="text" maxlength="30" style="ime-mode:disabled" id="mail"name="mail" value="<%out.print(rmail);%>"></li>
		     <li><span>地区:</span><input type="text" maxlength="100" id="position"name="position" value="<%out.print(rposition);%>"></li>
		    </ul>
		    <div class="info_last">
		    收货地址:<input type="text" maxlength="150" id="redress" name="redress" value="<%out.print(raddress);%>">
		      <button onclick="deliver()" type="button">保存</button>
		    </div>
		  </form>
		</div>
<%
}
%>
<div class="catalog">
  <ul>
    <li><a href="reader_info.jsp?operate=wallet&rid=<%=rid%>&usertype=<%=usertype%>">钱包</a></li>
    <li><a href="reader_info.jsp?operate=sucribe&rid=<%=rid%>&usertype=<%=usertype%>">订阅书籍</a></li>
    <li><a href="reader_info.jsp?operate=bookshell&rid=<%=rid%>&usertype=<%=usertype%>">书架</a></li>
    <li><a href="reader_info.jsp?operate=collection&rid=<%=rid%>&usertype=<%=usertype%>">收藏</a></li>
    <li><a href="reader_info.jsp?operate=history&rid=<%=rid%>&usertype=<%=usertype%>">阅读记录</a></li>
  </ul>
</div>

<%
if(operate.equals("wallet")||operate.equals("sucribe"))//first表示显示钱包和订阅
{
		%>
<div class="container">
  <%
  if(operate.equals("wallet")){
  %>
  <!-- 钱包 -->
  <div class="wallet" name="#w">
  <ul>
    <li><p>余额:&emsp;&emsp;&emsp;<b><%out.print(rbalance);%></b>元</p><a><button>充值</button></a></li>
    <li><p>月票:&emsp;&emsp;&emsp;<b><%out.print(rticket);%></b>张</p><a><button>充值</button></a></li>
  </ul>
  </div>
  <%
  }else{
  %>
  <div class="subscribe" name="#s">
    <table cellspacing="0">
      <caption>电子书</caption>
      <tr>
        <th>序号</th>
        <th>书名</th>
        <th>金额</th>
        <th>时间</th>
      </tr>
<%
int num=0,num0=0,num1=0;
if(rsnext){
bname=rs.getString("c.bname");
btime=rs.getString("c.btime");
btype=rs.getInt("c.btype");
bmoney=rs.getInt("c.bmoney");
bnumber=rs.getInt("c.bnumber");
subNid=rs.getInt("c.nid");
}
//获取实体书数据
String[] bname0=new String[300];
String[] btime0=new String[300];
int[] bmoney0=new int[300];
int[] bnumber0=new int[300];
int[] subNid0=new int[300];

if(rsnext){
do
{
	num+=1;
	if(num>1)
	{
	bname=rs.getString("c.bname");
	btime=rs.getString("c.btime");
	btype=rs.getInt("c.btype");
	bmoney=rs.getInt("c.bmoney");
	bnumber=rs.getInt("c.bnumber");
	subNid=rs.getInt("c.nid");
	}
	if(btype==0)//电子书
	{
		num1+=1;
		%>
		<tr>
		<td><%out.print(num1);%></td>
        <td><%out.print(bname);%></td>
        <td><%out.print(bmoney);%>元</td>
        <td><%out.print(btime);%></td>
        </tr>
		<%
	}else{
		num0+=1;//从1开始
		bname0[num0]=bname;
		btime0[num0]=btime;
		bmoney0[num0]=bmoney;
		bnumber0[num0]=bnumber;
		subNid0[num0]=subNid;
	}
	
}while(rs.next());
}
%>
    </table>
    <table cellspacing="0">
      <caption>实体书</caption>
      <tr>
        <th>序号</th>
        <th>书名</th>
        <th>金额</th>
        <th>时间</th>
        <th>数量</th>
      </tr>
      <%
      for(int i=1;i<=num0;i++)
      {
    	  %>
    	  <tr>
           <td><%out.print(i);%></td>
           <td><%out.print(bname0[i]);%></td>
           <td><%out.print(bmoney0[i]);%>元</td>
           <td><%out.print(btime0[i]);%></td>
           <td><%out.print(bnumber0[i]);%>本</td>
          </tr>
    	  <%
      }
      %>
      
    </table>
  </div>
</div>
		<%}
		
}
if(operate.equals("bookshell"))//书架
{
	%>
	<div class="bookshell">
	  <%
	  //获取书架数据
	  ResultSet rs1=stmt.executeQuery(sql1);
	  String imagepath="",name="";
	  int nid=0;
	  while(rs1.next())
	  {
		  imagepath=rs1.getString("imagepath");
		  nid=rs1.getInt("nid");
		  name=rs1.getString("name");
		  %>
		  <a href="novel_item_info.jsp?nid=<%=nid%>&id=<%=rid%>&usertype=<%=usertype%>">
          <div class="content_show_item">
             <img src="<%out.print(imagepath); %>" alt=""/>
             <div class="content_show_item_last">
             <span><%out.print(name); %></span></a>
             <form action="AddORDeltoShelServlet?nid=<%=nid%>&id=<%=rid%>&usertype=<%=usertype%>&ShelOperate=Del" name="deletebook" method="post">
             <input name="submit" type="image" src="PIC\deletelogo.png" onclick ="document.deletebook.submit()"/>
             </form>
             </div>
          </div>
		  <%
	  }
	  %>
    </div>
	<%
}
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
}
%>

  
<div class="collection">
    
</div>
  
<div class="history">
</div>
</body>
</html>