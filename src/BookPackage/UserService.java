package BookPackage;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class UserService {
	Connection conn;
	ResultSet rs;
public void init() throws ClassNotFoundException, SQLException {
	Class.forName("com.mysql.cj.jdbc.Driver");
    conn=DriverManager.getConnection("jdbc:mysql://localhost:3306/redlen?serverTimezone=UTC&&useUnicode=true&&characterEncoding=UTF-8","root","jisuanji");	
}
public List<entitybook> getallUser(int rid) throws SQLException, ClassNotFoundException{
	    init();
        List<entitybook> list=new ArrayList<entitybook>();
        PreparedStatement ps;
        String sql="select * from novelauthorentity e,cart c where e.bid=c.bid and c.rid="+rid;
        try {
			ps=conn.prepareStatement(sql);
			rs=ps.executeQuery();
			while (rs.next()) {
				entitybook book=new entitybook();
				book.setcid(rs.getInt("c.cid"));
				book.setaid(rs.getInt("e.aid"));
				book.setbid(rs.getInt("e.bid"));
				book.setbname(rs.getString("e.bname"));
				book.setbmoney(rs.getInt("e.bmoney"));
				book.setbnumber(rs.getInt("e.bnumber"));
				book.setvalue(rs.getInt("c.value"));
				list.add(book);
			}
			ps.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
        
		return list;

	}
public void insert(int rid,int bid,int value) throws ClassNotFoundException, SQLException {
	init();
	try{
		
		
		String sql="insert into cart(rid,bid,value) value(?,?,?)";
		
		PreparedStatement ps=conn.prepareStatement(sql);
		ps.setInt(1, rid);ps.setInt(2, bid);ps.setInt(3, value);
		
		ps.executeUpdate();
		ps.close();
		conn.close();
	}catch(Exception e){
		System.out.println("error"+e.toString());
	}
}
public void delete(int cid)throws ClassNotFoundException, SQLException {
	init();
	try{
		String sql="delete from cart where cid="+cid;
		
		PreparedStatement ps=conn.prepareStatement(sql);
		
		ps.executeUpdate();
		ps.close();
		conn.close();
	}catch(Exception e){
		System.out.println("error"+e.toString());
	}
}
public void update(int cid,int value,int bnumber,int bid)throws ClassNotFoundException, SQLException {
	init();
	try{
		PreparedStatement ps,ps0;
		String sql;
		if(value==0)
		{
			String sql0="select * from cart where cid="+cid;
			ps0=conn.prepareStatement(sql0);
			rs=ps0.executeQuery();
			int getvalue=0;
			while(rs.next())
			{
				getvalue=rs.getInt("value");
			}
			if(getvalue-1<0)
			{
				conn.close();
				return;
			}else {
				sql="update cart set value=value-1 where cid="+cid;
				ps=conn.prepareStatement(sql);
			}
			
		}else {
			String sql0="select * from cart where bid="+bid;
			ps0=conn.prepareStatement(sql0);
			rs=ps0.executeQuery();
			int sumvalue=0;
			while(rs.next())
			{
				sumvalue=sumvalue+rs.getInt("value");
				System.out.println(sumvalue);
			}
			System.out.println("bnumber:"+bnumber);
			if(sumvalue>=bnumber)
			{
				conn.close();
				return;
			}else {
				sql="update cart set value=value+1 where cid="+cid;
				ps=conn.prepareStatement(sql);
				
			}
			
		}
		ps.executeUpdate();
		ps.close();
		conn.close();
		
	}catch(Exception e){
		System.out.println("error"+e.toString());
	}
}
public int orderSubmit(int rid,int total) throws ClassNotFoundException, SQLException {
	init();
	int rbalance = 0;//获取余额
	try {
		PreparedStatement ps;
		String sql="select * from novelreaderwallet where rid="+rid;
		ps=conn.prepareStatement(sql);
		rs=ps.executeQuery();
		while(rs.next())
		{
			rbalance=rs.getInt("rbalance");
		}
		ps.close();
		if(rbalance<total) {//余额不足
			return 0;
		}else {//余额充足，删除购物车表的信息，插入novelreadersubscribe表、更新novelauthorentity表的信息（后期还会有销售统计表）
			String sql_cart="select * from cart where rid="+rid;
			ArrayList citem_bid = new ArrayList();//动态数组保存bid
			ArrayList citem_value = new ArrayList();//动态数组保存value
			ps=conn.prepareStatement(sql_cart);rs=ps.executeQuery();
			while(rs.next()) {citem_bid.add(rs.getInt("bid"));citem_value.add(rs.getInt("value"));}ps.close();
			//System.out.println(citem_bid.size());
			//插入novelreader。。表
			for(int i=0;i<citem_bid.size();i++)
			{
				String bname="";int bmoney=0;
				String sql_EntitySelect="select * from novelauthorentity where bid="+citem_bid.get(i);//获取信息
				ps=conn.prepareStatement(sql_EntitySelect);
				rs=ps.executeQuery();
				while(rs.next()){bname=rs.getString("bname");bmoney=rs.getInt("bmoney");}ps.close();
				//System.out.println(bmoney);
				try{
					String sql_SubscribeInsert="insert into novelreadersubscribe(rid,nid,btype,bname,bmoney,bnumber,btime) value(?,?,?,?,?,?,?)";
					ps=conn.prepareStatement(sql_SubscribeInsert);
					ps.setInt(1, rid);ps.setInt(2, (int) citem_bid.get(i));ps.setInt(3, 1);
					ps.setString(4, bname);ps.setInt(5, bmoney);ps.setInt(6, (int)citem_value.get(i));
					Timestamp d = new Timestamp(System.currentTimeMillis());
					ps.setTimestamp(7, d);
					ps.executeUpdate();
					//更新entitybook表
					String sql_entityupdate="update novelauthorentity set bnumber=bnumber-"+citem_value.get(i)+" where bid="+citem_bid.get(i);
					PreparedStatement ps_eu=conn.prepareStatement(sql_entityupdate);
					ps_eu.executeUpdate();
					ps_eu.close();
					ps.close();
				}catch(Exception e){
					System.out.println("error"+e.toString());
				}
			}
			//更新钱包
			String sql_Walletupdate="update novelreaderwallet set rbalance=rbalance-"+total+" where rid="+rid;//该表书籍id为主键，即实体书书籍id号唯一
			ps=conn.prepareStatement(sql_Walletupdate);ps.executeUpdate();ps.close();
			//删除,放在最后
			String sql_CartDelete="delete from cart where rid="+rid;
			ps=conn.prepareStatement(sql_CartDelete);ps.executeUpdate();ps.close();
		}
		
	}catch(Exception e){
		System.out.println("error"+e.toString());
	}
	return 1;
}
}
