<%@ page language="java" import="java.awt.*,java.awt.event.*,java.sql.*,javax.swing.*,java.util.ArrayList" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%
request.setCharacterEncoding("utf-8"); 
response.setCharacterEncoding("utf-8"); 
%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link href="CSS\\author_bookmanage.css" rel="stylesheet" type="text/css" media="all">
<title>作者专区-书籍管理</title>
</head>
<body>
<%
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
<!-- 实体书管理 -->
<%

if(username!=null){aid=Integer.parseInt(username);}
//aid=100001;
String bookstyle=request.getParameter("booktype");
if(bookstyle==null)
{
	bookstyle="entitymanage";
}
try{
	Class.forName("com.mysql.cj.jdbc.Driver");
	Connection conn=DriverManager.getConnection("jdbc:mysql://localhost:3306/redlen?serverTimezone=UTC&&useUnicode=true&&characterEncoding=UTF-8","root","jisuanji");
	Statement stmt=conn.createStatement();
if(bookstyle.equals("entitymanage"))
{
	
	%>
	<div class="entity_book">
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
   <div class="entity_search">
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
  
  <div class="entity_show">
    <p id="test">书籍列表</p>
    <button onclick="addEntityBook()" type="button"><img src="PIC\add2.jpg" alt=""/><span>添加书籍</span></button>
    <table>
      <tr>
       <th>书籍编号</th>
       <th>书籍名称</th>
       <th>书籍类型</th>
       <th>书籍作者</th>
       <th>金额</th>
       <th>数量</th>
       <th>操作</th>
      </tr>
      <%
    		String sql="select * from novelauthorentity where aid="+aid;
    		ResultSet rs=stmt.executeQuery(sql);
    		String bname="",btype="",bintro="",bauthor="";
    		int bmoney=0,bnumber=0,bid=0;
    		int num=0;//序号
    		while(rs.next())
    		{
    			num++;
    			bid=rs.getInt("bid");
    			bname=rs.getString("bname");
    			btype=rs.getString("btype");
    			bintro=rs.getString("bintro");
    			bmoney=rs.getInt("bmoney");
    			bnumber=rs.getInt("bnumber");
    			bauthor=rs.getString("bauthor");
    			%>
    	<tr>
          <td><%out.print(bid); %></td>
          <td>《<%out.print(bname); %>》</td>
          <td>
          <%
          switch(btype)
          {
          case "xuanhuan":out.print("玄幻");break; case "wuxia":out.print("武侠");break; case "xianxia":out.print("仙侠");break;
          case "dushi":out.print("都市");break; case "junshi":out.print("军事");break; case "lishi":out.print("历史");break;
          case "xuanyi":out.print("游戏");break; case "kehuan":out.print("科幻");break; case "youxi":out.print("游戏");break;
          default:
        	  out.print("无");
        	  break;
          }
          %>
          </td>
          <td><%out.print(bauthor); %></td>
          <td><%out.print(bmoney); %>元</td>
          <td><%out.print(bnumber); %></td>
          <td>
          <button onclick="UpdateEntityBook(<%=bid%>)" type="button">修改信息</button>
          <form action="EntiUpAnDelServlet?operate=delete&aid=<%=aid%>&bid=<%=bid%>" method="post">
          <button type="submit">下架</button>
          </form>
          </td>
        </tr>   
    			<%
    		}
    		
      %>
    </table>
  </div>
</div>
<script>
function addEntityBook() {     //url是你模式窗口对应的页面，w、h分别是模式窗口的高度和宽度
	var url="author_addbook.jsp?operate=insert&aid=<%=aid%>&bid=<%=bid%>";
    var obj = new Object();
    obj.value = "3";
    obj.name = "4";
    obj.sew = "5"; 
    window.open (url, 'newwindow', 'height=450, width=400, top=150, left=300, toolbar=no, menubar=no, scrollbars=no, resizable=no,location=no, status=no');
}
function UpdateEntityBook(bid_temp) {     //url是你模式窗口对应的页面，w、h分别是模式窗口的高度和宽度
	var url="author_addbook.jsp?operate=update&aid=<%=aid%>&bid="+bid_temp;
    var obj = new Object();
    obj.value = "3";
    obj.name = "4";
    obj.sew = "5"; 
    window.open (url, 'newwindow', 'height=450, width=400, top=150, left=300, toolbar=no, menubar=no, scrollbars=no, resizable=no,location=no, status=no');
}
</script>
	<%
}
if(bookstyle.equals("netmanage")){
	%>
	<!-- 网文管理 -->
<div class="net_book">
  <div class="netbook_show">
    
    <div class="net_book_table">
      <table>
        <tr>
          <th>编号</th>
          <th>封面</th>
          <th>名称</th>
          <th>章节数</th>
          <th>分类</th>
          <th>标签</th>
          <th>操作</th>
        </tr>
        
        <%
    		String sql="select * from novelbase b,novelmessage m where b.nid=m.nid and b.nid in (select nid from novelbase where aid="+aid+")";
    		ResultSet rs=stmt.executeQuery(sql);
    		String imagepath="",name="",type0="",Llabel="";
    		String author="";
    		int nid=0,chapternum=0;
    		int num=0;//序号
    		while(rs.next())
    		{
    			num++;
    			nid=rs.getInt("b.nid");
    			imagepath=rs.getString("b.imagepath");
    			name=rs.getString("b.name");
    			type0=rs.getString("b.type0");
    			Llabel=rs.getString("m.Llabel");
    			chapternum=rs.getInt("m.chapternum");
    			
    			author=rs.getString("author");
    			%>
    	<tr>
          <td><%out.print(nid); %></td>
          <td><img src="<%out.print(imagepath); %>" alt=""/></td>
          <td><%out.print(name); %></td>
          <td><%out.print(chapternum); %>章</td>
          <td><%
          switch(type0)
          {
          case "xuanhuan":out.print("玄幻");break; case "wuxia":out.print("武侠");break; case "xianxia":out.print("仙侠");break;
          case "dushi":out.print("都市");break; case "junshi":out.print("军事");break; case "lishi":out.print("历史");break;
          case "xuanyi":out.print("游戏");break; case "kehuan":out.print("科幻");break; case "youxi":out.print("游戏");break;
          default:
        	  out.print("无");
        	  break;
          }
          %></td>
          <td><%out.print(Llabel); %></td>
          <td class="table_opration">
            <form action="NovTexSavServlet?operate=write&writetype=readchapter&aid=<%=aid%>&nid=<%=nid%>" name="entiseaID" method="post">
               <button type="submit">写作</button>
            </form>
            <a href="author_write.jsp?operate=info&infotype=update&aid=<%=aid%>&nid=<%=nid%>"><button>修改作品信息</button></a>
          </td>
        </tr> 
    			<%
    		}
    		
      %>
      </table>
    </div>
    <div class="netbook_show_title">
       <span>作品总数为<%out.print(num); %>本</span>
       <a href="author_write.jsp?operate=info&infotype=create&aid=<%=aid%>&nid=<%=nid%>"><button><img src="PIC\add3.jpg" alt=""/>创建新作品</button></a>
    </div>
  </div>
</div>
	<%
}
conn.close();
}catch(Exception e){
	System.out.println("error"+e.toString());
}      
%>


</body>
</html>