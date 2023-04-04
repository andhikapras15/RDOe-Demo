package com.rs.rdoe.demo.ui;

import java.awt.Point;

import javax.swing.JFrame;
import javax.swing.JScrollPane;
import javax.swing.ScrollPaneConstants;

import com.rs.rdoe.demo.ProductInfo;

/**
 * This class is is the basic container frame for our demo application.
 */
public class DemoFrame extends JFrame 
{
	public DemoFrame()
	{
		ProductInfo pi = new ProductInfo();
		
		setLocation(new Point(100, 100));
		setTitle(pi.getDescription(ProductInfo.TITLE));
		setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		
		
		//create the demo gui as our content pane
		DemoGuiContainer newContentPane = new DemoGuiContainer(pi);
		newContentPane.setOpaque(true);
		
		JScrollPane scrollPane = new JScrollPane(newContentPane, 
				ScrollPaneConstants.VERTICAL_SCROLLBAR_AS_NEEDED,
				ScrollPaneConstants.HORIZONTAL_SCROLLBAR_AS_NEEDED);
		setContentPane(scrollPane);
	}
}
