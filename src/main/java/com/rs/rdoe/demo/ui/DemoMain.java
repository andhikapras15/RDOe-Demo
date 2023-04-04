/*
 * Created on Aug 2, 2007
 *
 */
package com.rs.rdoe.demo.ui;

import javax.swing.*;

/**
 * @author jeffw
 * Main class for running Aldon demo application
 */
public class DemoMain {

	public static void main(String[] args) 
	{
		SwingUtilities.invokeLater(new Runnable() {
			public void run() {
				createAndShowGui();
			}
		});
	}
	
	public static void createAndShowGui()
	{
		JFrame dFrame = new DemoFrame();
		dFrame.pack();
		dFrame.setSize(500, 220);
		dFrame.setVisible(true);
	}
}
