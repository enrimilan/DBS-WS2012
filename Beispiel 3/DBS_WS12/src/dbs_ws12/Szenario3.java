package dbs_ws12;

import java.sql.*;
import java.math.BigDecimal;
import java.util.logging.Level;
import java.util.logging.Logger;

public class Szenario3 {
	
	private Connection connection = null;
	
	public static void main(String[] args) {
		if (args.length <= 5 && args.length >= 3) {
			/*
			* args[1] ... server, 
			* args[2] ... port,
			* args[3] ... database, 
			* args[4] ... username, 
			* args[5] ... password
			*/
			
			Connection conn = null;
			
			if (args.length == 3) {
				conn = DBConnector.getConnection(args[0], args[1], args[2]);
			} 
			else {
				if (args.length == 4) {
					conn = DBConnector.getConnection(args[0], args[1], args[2], args[3], "");
				} 
				else {
					conn = DBConnector.getConnection(args[0], args[1], args[2], args[3], args[4]);
				}
			}
			
			if (conn != null) {
				Szenario3 s = new Szenario3(conn);
				
				s.run();
			}
			
		} 
		else {
			System.err.println("Ungueltige Anzahl an Argumenten!");
		}
	}
	
	public Szenario3(Connection connection) {
		this.connection = connection;
	}
	
	public void run() {
		inflationsAusgleich(0.025);
	}
	
	/*
	* Beschreibung siehe Angabe
	*/
	public void inflationsAusgleich(double inflation) {
		Statement stmt = null;
		PreparedStatement pstmt = null;
		try {
			stmt = connection.createStatement();
			stmt.executeQuery("SELECT p_erhoehe_dienstgrad(2)");
			
			pstmt = connection.prepareStatement("UPDATE dienstgrad SET gehalt =gehalt+ gehalt*? WHERE gehalt>=? AND gehalt<?");
			
			
			pstmt.setDouble(1, 2.5*inflation);
			pstmt.setDouble(2, 0.0);
			pstmt.setDouble(3, 750.0);
			pstmt.executeUpdate();
			
			pstmt.setDouble(1, 2.0*inflation);
			pstmt.setDouble(3, 750.0);
			pstmt.setDouble(2, 1250.0);
			pstmt.executeUpdate();
			
			pstmt.setDouble(1, 1.5*inflation);
			pstmt.setDouble(2, 1250.0);
			pstmt.setDouble(3, 1750.0);
			pstmt.executeUpdate();
			
			pstmt.setDouble(1, inflation);
			pstmt.setDouble(2, 1750.0);
			pstmt.setDouble(3, 5001.0);
			pstmt.executeUpdate();
			
			pstmt.setDouble(1, 0.5*inflation);
			pstmt.setDouble(2, 5001.0);
			pstmt.setDouble(3, 1000000.0);
			pstmt.executeUpdate();
			
			ResultSet rs= stmt.executeQuery(
				"SELECT p.id,p.vorname,p.nachname,d.gehalt,f_bonus(p.id) "+
                                "FROM person p,dienstgrad d "+
                                "WHERE p.dienstgrad=d.id;");
                        while(rs.next()){
                        	System.out.print(rs.getInt(1) + ", ");
                        	System.out.print(rs.getString(2) + ", ");
                        	System.out.print(rs.getString(3) + ", ");
                        	System.out.println(rs.getDouble(4)+rs.getDouble(5));
                        }
			
			rs.close();
			stmt.close();
		}
		catch(SQLException e) {
			e.printStackTrace();
		}
		finally{
			try{
				if(stmt != null)
					stmt.close();
			}
			catch(SQLException e) {
				System.err.println(e.toString());
			}
		}
	}
}
