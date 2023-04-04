package com.rs.rdoe.demo.ui;

import java.awt.event.*;

import javax.swing.*;

public class DemoButton extends JButton 
{
	public DemoButton(String text)
	{
		super(text);
		setVerticalTextPosition(AbstractButton.CENTER);
		setHorizontalTextPosition(AbstractButton.CENTER);
		setActionCommand(text);
		
		ActionListener clickListener = new ActionListener() {
			public void actionPerformed(ActionEvent event) {
				System.out.println(event.getActionCommand() + " button pressed");
			}
		};
		addActionListener(clickListener);
	}
}
