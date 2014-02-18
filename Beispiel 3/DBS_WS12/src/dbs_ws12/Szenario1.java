package dbs_ws12;

import java.sql.*;
import java.util.Scanner;
import java.util.logging.Level;
import java.util.logging.Logger;

public class Szenario1 {
	
	private Connection connection = null;
	
	public static void main(String[] args) {
		if (args.length <= 6 && args.length >= 4) {
			/*
			* args[0] ... type -> [a|b], 
			* args[1] ... server, 
			* args[2] ... port,
			* args[3] ... database, 
			* args[4] ... username, 
			* args[5] ... password
			*/
			
			Connection conn = null;
			
			if (args.length == 4) {
				conn = DBConnector.getConnection(args[1], args[2], args[3]);
			} 
			else {
				if (args.length == 5) {
					conn = DBConnector.getConnection(args[1], args[2], args[3], args[4], "");
				} 
				else {
					conn = DBConnector.getConnection(args[1], args[2], args[3], args[4], args[5]);
				}
			}
			
			if (conn != null) {
				Szenario1 s = new Szenario1(conn);
				
				if (args[0].equals("a")) {
					s.runTransactionA();
				} 
				else {
					s.runTransactionB();
				}
			}
		} 
		else {
			System.err.println("Ungueltige Anzahl an Argumenten!");
		}
	}
	
	public Szenario1(Connection connection) {
		this.connection = connection;
	}
	
	/*
	* Beschreibung siehe Angabe
	*/
	public void runTransactionA() {
		/*
		* Vorgegebener Codeteil
		* ################################################################################
		*/
		wait("Druecken Sie <ENTER> zum Starten der Transaktion ...");
		/*
		* ################################################################################
		*/
		
		System.out.println("Transaktion A Start");
		
		/*
		* Setzen Sie das aus Ihrer Sicht passende Isolation-Level:
		*/
		try{
			connection.setTransactionIsolation(Connection.TRANSACTION_READ_COMMITTED);
		}
		catch(SQLException e) {
			System.err.println(e.toString());
		}
		/*
		* Abfrage 1:
		* Ermitteln Sie das Durchschnittsalter jener Personen, welche
		* zumindest an einem der letzten drei Wettkaempfe teilgenommen
		* haben und geben Sie dieses auf der Konsole aus.
		*/
		Statement stmt = null;
		ResultSet rs = null;
		double schnitt1=0.0;
		try{
			stmt = connection.createStatement();
			rs = stmt.executeQuery(
				"SELECT avg(age) "+
				"FROM (SELECT distinct p.id,extract( year FROM age(geburtsdatum)) as age "+
				"FROM person p, truppenmitglied t, absolviert a WHERE p.id=t.person_id AND t.truppen_id=a.truppen_id AND a.wettkampf_id in( "+
				"SELECT id FROM wettkampf "+
				"ORDER BY bis DESC "+
				"LIMIT 3)) sub;");
			while(rs.next()) {
				schnitt1=rs.getDouble(1);
				System.out.println("Durchschnittsalter aller Personen die zumindest an einem der letzten 3 Wettkaempfe teilgenommen haben: " +schnitt1);
			}
			
			rs.close();
			stmt.close();
		}
		catch(SQLException e) {
			System.err.println(e.toString());
		}
		finally{
			try{
				if(rs != null)
					rs.close();
			}
			catch(SQLException e) {
				System.err.println(e.toString());
			}
			try{
				if(stmt != null)
					stmt.close();
			}
			catch(SQLException e) {
				System.err.println(e.toString());
			}
		}
		/*
		* Vorgegebener Codeteil
		* ################################################################################
		*/
		wait("Druecken Sie <ENTER> zum Fortfahren ...");
		/*
		* ################################################################################
		*/
		
		/*
		* Abfrage 2:
		* Ermitteln Sie das Durschnittsalter aller 
		* Personen und geben Sie dieses auf der der Konsole aus.
		*/
		double schnitt2=0.0;
		try{
			stmt = connection.createStatement();
			rs = stmt.executeQuery(
				"SELECT avg(extract(year FROM age(geburtsdatum))) " +
				"FROM person;");
			while(rs.next()) {
				schnitt2=rs.getDouble(1);
				System.out.println("Durchschnittsalter aller Personen : " +schnitt2);
			}
			
			rs.close();
			stmt.close();
		}
		catch(SQLException e) {
			System.err.println(e.toString());
		}
		finally{
			try{
				if(rs != null)
					rs.close();
			}
			catch(SQLException e) {
				System.err.println(e.toString());
			}
			try{
				if(stmt != null)
					stmt.close();
			}
			catch(SQLException e) {
				System.err.println(e.toString());
			}
		}
		
		/*
		* Geben Sie das Verhaeltnis der beiden abgefragten Werte aus
		*/
		System.out.println("Verhaeltnis: " + schnitt1/schnitt2);
		
		/*
		* Vorgegebener Codeteil
		* ################################################################################
		*/
		wait("Druecken Sie <ENTER> zum Beenden der Transaktion ...");
		/*
		* ################################################################################
		*/
		
		/*
		* Beenden Sie die Transaktion
		*/
		try{
			connection.commit();
			System.out.println("Transaktion A Ende");
		}
		catch(SQLException e) {
			
		}
		finally{
			try{
				if(rs != null)
					rs.close();
			}
			catch(SQLException e) {
				System.err.println(e.toString());
			}
			try{
				if(stmt != null)
					stmt.close();
			}
			catch(SQLException e) {
				System.err.println(e.toString());
			}
		}
	}
	
	public void runTransactionB() {
		/*
		* Vorgegebener Codeteil
		* ################################################################################
		*/
		wait("Druecken Sie <ENTER> zum Starten der Transaktion ...");
		
		System.out.println("Transaktion B Start");
		
		try {
			Statement stmt = connection.createStatement();
			
			stmt.executeUpdate("INSERT INTO Person (Vorname, Nachname, Geburtsdatum, Beitritt, " +
				"Telefon, Dienstgrad, Dienstgrad_seit, Mannschaft) VALUES (" +
				"'Samuel', 'Sanchez', '1984-07-23', current_date, " +
				"'993248', 9, current_date, 30);");
			
			stmt.close();
			
			System.out.println("Eine Person wurde hinzugefuegt ...");
			
			wait("Druecken Sie <ENTER> zum Beenden der Transaktion ...");
			
			connection.commit();
		} 
		catch (SQLException ex) {
			Logger.getLogger(Szenario1.class.getName()).log(Level.SEVERE, null, ex);
		}
		
		System.out.println("Transaktion B Ende");
		/*
		* ################################################################################
		*/
	}
	
	private static void wait(String message) {
		/* 
		* Vorgegebener Codeteil 
		* ################################################################################
		*/
		Scanner s = new Scanner(System.in);
		try {
			System.out.println(message);
			s.nextLine();
		} 
		catch (Exception ex) {
			Logger.getLogger(Szenario1.class.getName()).log(Level.SEVERE, null, ex);
		}
		/*
		* ################################################################################
		*/
	}
}
