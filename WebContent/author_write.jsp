<%@ page language="java" import="java.awt.*,java.awt.event.*,java.sql.*,javax.swing.*,java.util.ArrayList,java.io.IOException,java.util.Random,
java.io.BufferedReader,java.io.BufferedWriter,java.io.File,java.io.FileInputStream,java.io.FileOutputStream,java.io.InputStreamReader,java.io.OutputStreamWriter" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link href="CSS\\author_write.css" rel="stylesheet" type="text/css" media="all">
<title>写作管理</title>
</head>
<body>
<%
int aid=0,nid=0;
String aid_temp=request.getParameter("aid");
String nid_temp=request.getParameter("nid");
if(aid_temp==null||aid_temp.equals("0")){aid_temp="0";}if(aid_temp!=null){aid=Integer.parseInt(aid_temp);}
if(nid_temp==null||nid_temp.equals("0")){nid_temp="0";}if(nid_temp!=null){nid=Integer.parseInt(nid_temp);}
//aid=100001;bid=10001;//测试用
//System.out.println(aid+"&id&"+bid);
%>
<div class="header">
  <a href="index.jsp?id=<%=aid%>&usertype=1"><button><img src="PIC\home.jpg" alt=""/>视听首页</button></a>
  <a href="novel_index.jsp?id=<%=aid%>&usertype=1"><button><img src="PIC\bookhome.jpg" alt=""/>小说首页</button></a>
</div>
<div class="catalog">
   <ul>
     <li><a href="author_info.jsp?operate=read&aid=<%=aid%>">个人资料</a></li>
    <li class="dropbtn"><a href="">实体书</a>
      <div class="dropdown">
        <a href="author_bookmanage.jsp?booktype=entitymanage&aid=<%=aid%>">管理</a>
        <a>数据统计</a>
      </div>
    </li>
    <li class="dropbtn"><a href="">电子书</a>
      <div class="dropdown">
        <a href="author_bookmanage.jsp?booktype=netmanage&aid=<%=aid%>">管理</a>   
        <a>数据统计</a>
      </div>
    </li>
   </ul>
</div>

<div class="operation">
  <form action="NovTexSavServlet?operate=write&writetype=readchapter&aid=<%=aid%>&nid=<%=nid%>" name="entiseaID" method="post">
  <button type="submit"><img src="PIC\bookedit.png" alt=""/>写作</button>
  </form>
  <a href="author_write.jsp?operate=info&infotype=update&aid=<%=aid%>&nid=<%=nid%>"><button><img src="PIC\bookinfo.png" alt=""/>作品信息</button></a>
</div>
<%
String operate=request.getParameter("operate");if(operate==null){operate="info";}
String infotype=request.getParameter("infotype");if(infotype==null){infotype="update";}
Connection conn;
if(operate.equals("info"))
{
	String author="";//作者笔名
	String bname="",type0="",blabel="",intro="",imagepath="";
	int finish=0;
	if(infotype.equals("update"))//读取数据
	{
	try{
		Class.forName("com.mysql.cj.jdbc.Driver");
		conn=DriverManager.getConnection("jdbc:mysql://localhost:3306/redlen?serverTimezone=UTC&&useUnicode=true&&characterEncoding=UTF-8","chenguanhao","jisuanji");
		Statement stmt=conn.createStatement();
		String sql="select * from novelbase where aid="+aid+" and nid="+nid;
		ResultSet rs=stmt.executeQuery(sql);
		while(rs.next())
		{
			author=rs.getString("author");
			bname=rs.getString("name");
			type0=rs.getString("type0");
			blabel=rs.getString("Llabel");
			intro=rs.getString("intro");
			imagepath=rs.getString("imagepath");
			finish=rs.getInt("finish");
		}
		imagepath=imagepath.replace('\\','/');
		conn.close();
	}catch(Exception e){
			System.out.println("error"+e.toString());
	}
	}
	if(infotype.equals("create")){
		try{
			Class.forName("com.mysql.cj.jdbc.Driver");
			conn=DriverManager.getConnection("jdbc:mysql://localhost:3306/redlen?serverTimezone=UTC&&useUnicode=true&&characterEncoding=UTF-8","chenguanhao","jisuanji");
			Statement stmt=conn.createStatement();
			String sql="";
			ResultSet rs;
			//获取作者笔名
			sql="select * from novelauthorinfo where aid="+aid;rs=stmt.executeQuery(sql);while(rs.next()){author=rs.getString("apenname");}
			//产生随机五位数
			Random rand=new Random();
			int randNid=0;
			do
			{
				randNid =rand.nextInt(99999 - 10000 + 1) + 10000;
				sql="select * from novelbase where nid="+randNid;
				rs=stmt.executeQuery(sql);
				
			}while(rs.next());//数据库中不存在该id
			nid=randNid;
			conn.close();
		}catch(Exception e){
				System.out.println("error"+e.toString());
		}
	}
	%>
	<!-- 作品信息 --> 
<script type="text/javascript">
window.onload=function(){
	//draw();
	var cvs=document.getElementById('novelcanvas');
	var imagepath="<%out.print(imagepath);%>";
	var ctx=cvs.getContext('2d');
	var img=new Image();
	img.onload=function(){
		ctx.drawImage(img,0,0,300,150);
	}
	img.src=imagepath;
	
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
            var canvas = document.querySelector("#novelcanvas"); 
            var context = canvas.getContext("2d"); 
            canvas.width = 100; // 设置canvas的画布宽度为图片宽度 image.width to 100px;
            canvas.height = 100; 
            context.drawImage(image, 0, 0, 100, 100) // 在canvas上绘制图片 
        } 
    }
}
</script>
<div class="bookinfo">
  
  <form action="UploadServlet?aid=<%=aid%>&bid=<%=nid%>&infotype=<%=infotype%>&imagepath=<%=imagepath %>" name="infoform" method="post" enctype="multipart/form-data">
  <input type="hidden" id="allcontent" name="allcontent"/><!-- 隐形控件 -->
  
  <h1><%out.print(author); %></h1>
  <div class="head_sculpture">
    <canvas id="novelcanvas"></canvas>
    <input type="file" name="imgupload" id="imgupload" style="display:none;" onchange="drawcanvas()" multiple="multiple"/>
    <input type="button" value="上传图片" onclick="imgupload.click()">
  </div>
  <input type="hidden" value="false" name="resubmit "/>
  <script>
function draw(){
    var imagepath=document.getElementById('imgupload').value;
    document.getElementById('novelimage').src=imagepath;
    
}
function deliver(){
	var bookName=document.getElementById('bookName').value;
    var bookStyle=document.getElementById('bookStyle').value;
    var bookLabel=document.getElementById('bookLabel').value;
    var bookIntro=document.getElementById('bookIntro').value;
    var finish=document.getElementById('finish').value;
    var all=bookName+"*"+bookStyle+"*"+bookLabel+"*"+finish+"*"+bookIntro;
    
    document.getElementById("allcontent").value=all
    document.infoform.submit();
    <%
    //request.setCharacterEncoding("UTF-8");
    //response.setCharacterEncoding("UTF-8");
	session.setAttribute("author", author);
    %>
}

 </script>
  <div class="bookinfolist">
    <ul>
      <li><span>作品ID:</span><input type="text" name="bookId" readonly="readonly" value="<%out.print(nid); %>"></li>
      <li><span>作品名称:</span><input type="text" id="bookName" name="bookName" value="<%out.print(bname); %>"></li>
      <li><span>状态:</span>
             <select id="finish" name="finish">
               <option value="0" <%if(finish==0){%>selected = "selected"<%} %>>连载</option>
               <option value="1" <%if(finish==1){%>selected = "selected"<%} %>>完本</option>
             </select>
      </li>
      <li><span>类型:</span>
             <select id="bookStyle" name="bookStyle">
               <option value="xuanhuan" <%if(type0.equals("xuanhuan")){%>selected = "selected"<%} %>>玄幻</option>
               <option value="wuxia" <%if(type0.equals("wuxia")){%>selected = "selected"<%} %>>武侠</option>
               <option value="xianxia" <%if(type0.equals("xianxia")){%>selected = "selected"<%} %>>仙侠</option>
               <option value="dushi" <%if(type0.equals("dushi")){%>selected = "selected"<%} %>>都市</option>
               <option value="junshi" <%if(type0.equals("junshi")){%>selected = "selected"<%} %>>军事</option>
               <option value="lishi" <%if(type0.equals("lishi")){%>selected = "selected"<%} %>>历史</option>
               <option value="xuanyi" <%if(type0.equals("xuanyi")){%>selected = "selected"<%} %>>悬疑</option>
               <option value="kehuan" <%if(type0.equals("kehuan")){%>selected = "selected"<%} %>>科幻</option>
               <option value="youxi" <%if(type0.equals("youxi")){%>selected = "selected"<%} %>>游戏</option>
             </select>
      </li>
      <li><span>标签:</span>
             <select id="bookLabel" name="bookLabel">
               <option value="Lall" <%if(blabel.equals("Lall")){%>selected = "selected"<%} %>>全部</option>
               <option value="Lsoldier" <%if(blabel.equals("Lsoldier")){%>selected = "selected"<%} %>>特种兵</option>
               <option value="Linvincible" <%if(blabel.equals("Linvincible")){%>selected = "selected"<%} %>>无敌文</option>
               <option value="Lreborn" <%if(blabel.equals("Lreborn")){%>selected = "selected"<%} %>>重生</option>
               <option value="Lrefuse" <%if(blabel.equals("Lrefuse")){%>selected = "selected"<%} %>>废材流</option>
               <option value="Lsystem" <%if(blabel.equals("Lsystem")){%>selected = "selected"<%} %>>系统流</option>
               <option value="Lteacher" <%if(blabel.equals("Lteacher")){%>selected = "selected"<%} %>>老师</option>
             </select>
      </li>
    </ul>
    <span>&emsp; &emsp; 作品介绍:</span><textarea rows="5" placeholder="书籍相关介绍（禁止输入*字符）" id="bookIntro" name="bookIntro"><%out.print(intro); %></textarea>
    
    <div class="savebtn">
      <button onclick="deliver()" type="button">保存</button>
    </div>
  </div>
  </form>
</div>
	<%
}

if(operate.equals("write"))
{
	String chapternum=request.getParameter("chapternum");
	%>
	<!-- 写作 -->
	
<script>
function crecha(){
	var chaptername=prompt("输入章节名字");
	if(chaptername!=null){
		//alert(chaptername);
		document.getElementById("chanameinput").value=chaptername;
		document.createchapter.submit();
	}else{
		return;
	}
}
function delcha(NM){
	document.getElementById("chaptNM").value=NM;
	document.deletechapter.submit();
}
function redCon(NM_content){
	document.getElementById("chaptNM_content").value=NM_content;
	document.readcontent.submit();
}
function savCon(chatID){
	document.getElementById("save_content").value=chatID;
	document.savecontent.submit();
}
</script>
<div class="catalog_write">
  
  <div class="catalog1">
  <!-- 新增章节表单 -->
    <form action="NovTexSavServlet?operate=write&writetype=createchapter&aid=<%=aid%>&nid=<%=nid%>" name="createchapter" method="post">
    <input type="hidden" id="chanameinput" name="chanameinput"/>
    </form>
  <!-- 删除章节表单 -->
    <form action="NovTexSavServlet?operate=write&writetype=deletechapter&aid=<%=aid%>&nid=<%=nid%>" name="deletechapter" method="post">
    <input type="hidden" id="chaptNM" name="chaptNM"/>
    </form>
  <!-- 读取章节内容表单 -->
  <form action="NovTexSavServlet?operate=write&writetype=readcontent&aid=<%=aid%>&nid=<%=nid%>" name="readcontent" method="post" >
    <input type="hidden" id="chaptNM_content" name="chaptNM_content"/>
  </form>
  
    <div class="catalog_header">
     <span>共<%out.print(chapternum); %>章</span>
      <button>发布(无)</button>
      <button type="button" onclick="crecha()">新增</button>
    </div>
   <div class="catalog_list">
     <ul id="allchapter">
     <c:forEach items="${key_list}" var="usr" varStatus="idx">
       <li onclick ="redCon('${usr.chaptername}')">${usr.chaptername}<br><span>2019\11\12</span>
       <input type="image" src="PIC\deletelogo.png" onclick ="delcha('${usr.chaptername}')"/>
       </li>
       </c:forEach>
     </ul>
   </div>
  </div>
<%

%>
  <div class="write">
  <c:forEach items="${contentlist}" var="cl" varStatus="clx">
    <div class="write_header">
      <button onclick="savCon(${cl.chatID})">保存</button>
      <button>发布(无)</button>
    </div>
    <!-- 保存章节内容表单 -->
  <form action="NovTexSavServlet?operate=write&writetype=savecontent&aid=<%=aid%>&nid=<%=nid%>" name="savecontent" method="post" >
    <input type="hidden" id="save_content" name="save_content"/>
    
    <div class="write_content">
      <span>第${cl.chatID}章:</span><input type="text" placeholder="章节名。示例：“万物所生”" id="title" name="title" value="${cl.title}">
      <textarea rows="35" placeholder="输入正文" id="bodytext" name="bodytext">${cl.content}</textarea>
    </div>
  </form>
  </c:forEach>
  </div>

</div>
	<%
}

%>


</body>
</html>