package BookPackage;
import javax.servlet.http.HttpServlet;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.io.RandomAccessFile;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Scanner;
import java.util.Set;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
@WebServlet("/NovTexSavServlet")
public class NovTexSavServlet extends javax.servlet.http.HttpServlet implements javax.servlet.Servlet{

	private static Connection conn;
	private static Statement st;
	private String txtpath="";
	private int num=0;//章节的隐式序号
	public NovTexSavServlet() {
		super();
	}
	static {
		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
			conn=DriverManager.getConnection("jdbc:mysql://localhost:3306/redlen?serverTimezone=UTC&&useUnicode=true&&characterEncoding=UTF-8","chenguanhao","jisuanji");
			st=conn.createStatement();
		}catch(Exception e) {
			e.printStackTrace();
		}
	}
	protected void service(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException{
		List<Map> list=new ArrayList<Map>();
		request.setCharacterEncoding("utf-8"); 
		response.setCharacterEncoding("utf-8");
		
		int aid=0,nid=0;
		String aid_temp=request.getParameter("aid");
		String nid_temp=request.getParameter("nid");
		if(aid_temp==null||aid_temp.equals("0")){aid_temp="0";}if(aid_temp!=null){aid=Integer.parseInt(aid_temp);}
		if(nid_temp==null||nid_temp.equals("0")){nid_temp="0";}if(nid_temp!=null){nid=Integer.parseInt(nid_temp);}
		String writetype=request.getParameter("writetype");
		
		//获取文件路径
		int chapternum=0;
		String sql="select * from novelbase b,novelmessage m where b.nid=m.nid and b.aid="+aid+" and b.nid="+nid;
		try
		 {
			Class.forName("com.mysql.cj.jdbc.Driver");
			conn=DriverManager.getConnection("jdbc:mysql://localhost:3306/redlen?serverTimezone=UTC","chenguanhao","jisuanji");
			Statement stmt=conn.createStatement();
			ResultSet rs=stmt.executeQuery(sql);
			while(rs.next()){
				txtpath=rs.getString("txtpath");
				chapternum=rs.getInt("chapternum");
			}
			
		 }catch(Exception e){
				System.out.println("error"+e.toString());
		 }
		
		//System.out.print(txtpath);
		int temp=readchapter(list)+1;//获取num
		if(writetype.contentEquals("createchapter")) {
			String chaptername=request.getParameter("chanameinput");
			String chapternameAll="\n第"+temp+"章  "+chaptername+"\n";
			//System.out.println("name::"+chapternameAll);
			createchapter(chapternameAll);
		}
		if(writetype.contentEquals("deletechapter")) {
			String chaptername=request.getParameter("chaptNM");
			deletechapter(chaptername);
		}
		List<Map> contentlist=new ArrayList<Map>();
		if(writetype.contentEquals("readcontent")) {
			String chaptername=request.getParameter("chaptNM_content");
			readcontent(chaptername,contentlist);
			request.setAttribute("contentlist", contentlist);
		}
		if(writetype.contentEquals("savecontent")) {
			String chapterID_temp=request.getParameter("save_content");int chapterID=Integer.parseInt(chapterID_temp);
			String title=request.getParameter("title");
			String bodytext=request.getParameter("bodytext");
			savecontent(chapterID,title,bodytext);
		}
		sql_change(aid,nid);//同步数据库数据
		
		List<Map> list1=new ArrayList<Map>();
		readchapter(list1);//再读取，刷新
		String url="/author_write.jsp?operate=write&aid="+aid+"&nid="+nid+"&chapternum="+chapternum;
		request.setAttribute("key_list", list1);
		request.getRequestDispatcher(url).forward(request, response);
		
	}
	public void sql_change(int aid,int nid) {
    	System.out.println(txtpath);
    	/*
		Map<String, Integer> map=new HashMap<String , Integer>();
		try {
			BufferedReader br=new BufferedReader(new InputStreamReader(new FileInputStream(txtpath)));
			String s=null;
			String name=null;
			while((s=br.readLine())!=null) {
				name=s.split(",")[1];
				if(map.containsKey(name)) {
					map.put(name,map.get(name)+1);
				}else {
					map.put(name, 1);
				}
			}
			Set<Entry<String,Integer>> set=map.entrySet();
			List<Entry<String,Integer>> list=new ArrayList<Entry<String,Integer>>(set);
			Collections.sort(list,new Comparator<Entry<String,Integer>>(){
				public int compare(Entry<String,Integer> o1,
						Entry<String,Integer> o2) {
					    int i=o1.getValue();
					    int j=o2.getValue();
					    if(i!=j) {
					    	return i-j;
					    }
					    return o1.getKey().compareTo(o2.getKey());}});
			for(Entry<String,Integer> entry:list) {
				String n=entry.getKey();
				Integer i=entry.getValue();
				System.out.println(n+":"+i);
			}
		}catch (IOException e) {
			e.printStackTrace();
		}*/
		
	}
	public void savecontent(int chapterID,String title,String bodytext) {
		title="第"+chapterID+"章"+title+"\n";
		//System.out.println(title);
		ArrayList<String> arraylist=new ArrayList<>();
		try {
			File file=new File(txtpath);
			InputStreamReader inputReader=new InputStreamReader(new FileInputStream(file),"UTF-8");
			BufferedReader br=new BufferedReader(inputReader);
			int chatIDTmp=0;int addnum=0;
			String line;
			while((line=br.readLine())!=null) {
				if(!line.contentEquals("")) {//获取章节id
					 String text0=line.substring(0,1);
					 boolean judge=line.contains("章");
					 if(text0.equals("第")&&judge&&line.length()<30){//遇到下一章节
						 chatIDTmp++;
					 } 
				 }
				if(chatIDTmp!=chapterID)
				{
					System.out.println("chatIDTmp:"+chatIDTmp);
					if(chatIDTmp==(chapterID+1)&&addnum==0) {//addnum是为了避免多次添加title+bodytext
						addnum++;
						System.out.println("yes");
						arraylist.add(title);
						arraylist.add(bodytext);
					}
					arraylist.add(line);		
				}
			}
			if(chapterID==chatIDTmp) {arraylist.add(title);arraylist.add(bodytext);}//当更改的是最后一章
			//将内容重新写入
			 OutputStreamWriter OutputWriter=new OutputStreamWriter(new FileOutputStream(file),"UTF-8");
			 BufferedWriter bw=new BufferedWriter(OutputWriter);
			 int chapter_ID=0;
			 for(int i=0;i<arraylist.size();i++)
			 {
				 String s=arraylist.get(i);
				 //System.out.print(s);
				 if(!s.equals(""))
				 {
				  String text0=s.substring(0,1);
				  boolean judge=s.contains("章");
				  if(text0.equals("第")&&judge&&s.length()<30){//需要对章节名称进行修改
					  chapter_ID++;
					  String str=s.substring(0,s.indexOf("章"));
					  String bb=s.substring(str.length()+1,s.length());//获取章之后的字符串
					  s="第"+chapter_ID+"章"+bb;
				  }
				 }
				 bw.write(s);
				 bw.newLine();
			 }
			 bw.flush();
			 bw.close();
			
		}catch(IOException e){
			 e.printStackTrace();
		 }
	}
	public void readcontent(String chaptername,List<Map> contentlist) {
		try {
			File file=new File(txtpath);
			InputStreamReader inputReader=new InputStreamReader(new FileInputStream(file),"UTF-8");
			BufferedReader br=new BufferedReader(inputReader);
			int rednum=0;int chatID=0;boolean Tiljud=false;
			String line;
			String title="";
			String content="";
			while((line=br.readLine())!=null) {
				if(line.equals(chaptername))
				 {
					rednum=1;Tiljud=true;
					String str=line.substring(0,line.indexOf("章"));
					String bb=line.substring(str.length()+1,line.length());//获取章之后的字符串
					title=bb;
				 }
				if(rednum==1&&!line.equals(chaptername)) {//不是该章的题目行时设置Tiljud=false
					Tiljud=false;
				}
				 if(rednum==1&&!line.equals(chaptername))//已经遇到过该章后
				 {
					 if(!line.contentEquals("")) {
						 String text0=line.substring(0,1);
						 boolean judge=line.contains("章");
						 if(text0.equals("第")&&judge&&line.length()<30){//遇到下一章节
							 rednum=2;
						 } 
					 } 
				 }
				if(!line.contentEquals("")&&rednum<2) {//获取该章节对应的章节id
						 String text0=line.substring(0,1);
						 boolean judge=line.contains("章");
						 if(text0.equals("第")&&judge&&line.length()<30){//遇到下一章节
							 chatID++;
						 } 
				} 
				 if(rednum==1&&!Tiljud) {//Tiljud==true时表示题目
					 content=content+line;
				 }
			}
			Map map=new HashMap();
			map.put("chatID",chatID);
			map.put("title",title);
			map.put("content",content);
			contentlist.add(map);
		}catch(IOException e){
			 e.printStackTrace();
		 }
	}
	public void deletechapter(String chaptername) {
		ArrayList<String> arraylist=new ArrayList<>();
		 try{
			 String pathTemp=txtpath;
			 File file=new File(pathTemp);
			 InputStreamReader inputReader=new InputStreamReader(new FileInputStream(file),"UTF-8");
			 BufferedReader br=new BufferedReader(inputReader);
			 String line;
			 int delnum=0;
			 while((line=br.readLine())!=null){
				 if(line.equals(chaptername))
				 {
					 delnum=1;
				 }
				 if(delnum==1&&!line.equals(chaptername))
				 {
					 if(!line.contentEquals("")) {
						 String text0=line.substring(0,1);
						 boolean judge=line.contains("章");
						 if(text0.equals("第")&&judge&&line.length()<30){//遇到下一章节
							 delnum=2;
						 } 
					 } 
				 }
				 if(delnum!=1)//delnum=1时还在要删的章节内
				 {
					 arraylist.add(line);//不包含需要删除的内容
				 }
				 
			 }
			 br.close();
			 inputReader.close();
			 //将内容重新写入
			 OutputStreamWriter OutputWriter=new OutputStreamWriter(new FileOutputStream(file),"UTF-8");
			 BufferedWriter bw=new BufferedWriter(OutputWriter);
			 int chapter_ID=0;
			 for(int i=0;i<arraylist.size();i++)
			 {
				 String s=arraylist.get(i);
				 if(!s.equals(""))
				 {
				  String text0=s.substring(0,1);
				  boolean judge=s.contains("章");
				  if(text0.equals("第")&&judge&&s.length()<30){//需要对章节名称进行修改
					  chapter_ID++;
					  String str=s.substring(0,s.indexOf("章"));
					  String bb=s.substring(str.length()+1,s.length());//获取章之后的字符串
					  s="第"+chapter_ID+"章"+bb;
				  }
				 }
				 bw.write(s);
				 bw.newLine();
			 }
			 bw.flush();
			 bw.close();
			 
			 
		 }catch(IOException e){
			 e.printStackTrace();
		 }
	}
	public void createchapter(String chapternameAll) {
		try {
			//打开一个随机访问文件流，按读写方式
			RandomAccessFile randomFile=new RandomAccessFile(txtpath,"rw");
			//移到文件末尾
			randomFile.seek(randomFile.length());
			//写入
			randomFile.write(chapternameAll.getBytes("utf-8"));
			randomFile.close();
		}catch(IOException e) {
			e.printStackTrace();
		}
	}
	public int readchapter(List<Map> list) {
		//读取txt文件获取章节
		 num=0;
		 ArrayList<String> arraylist=new ArrayList<>();
		 try{
			 String pathTemp=txtpath;
			 //System.out.println(pathTemp);
			 File file=new File(pathTemp);
			 InputStreamReader inputReader=new InputStreamReader(new FileInputStream(file),"UTF-8");
			 BufferedReader br=new BufferedReader(inputReader);
			 
			 String line;
			 while((line=br.readLine())!=null){
				 if(line.equals(""))
				 {
					 continue;
				 }
				 arraylist.add(line);//将每一行放入arraylist
			 }
			 br.close();
			 inputReader.close();
		 }catch(IOException e){
			 e.printStackTrace();
		 }
		 int length=arraylist.size();
		 ArrayList<String> arraytitle=new ArrayList<>();
		 int t=0;
		 
		 for(int i=0;i<length;i++){
			 String s=arraylist.get(i);
			 if(!s.equals(""))
			 {
				 String text0="";
				 text0=s.substring(0,1);
				 boolean judge=s.contains("章");
				 int len=s.length();
				 if(t==0){
					//System.out.print(s);
				 }
				 t++;
				 if(text0.equals("第")&&judge&&len<30){
					 num++;//对应章节序号
					 arraytitle.add(s);
					 Map map=new HashMap();
					 map.put("chapterID",num);
					 map.put("chaptername",s);
					 list.add(map);
					 //System.out.print("num:"+num+" name:"+s);
					 //for(Map map_1:list) {
					//		System.out.println(map_1);
					//}
				 }
			 }
		 }
		 return num;
	}
}
