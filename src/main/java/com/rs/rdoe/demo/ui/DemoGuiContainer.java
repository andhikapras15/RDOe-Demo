/*
 * Created on Aug 2, 2007
 *
 */
package com.rs.rdoe.demo.ui;

import java.awt.Color;
import java.awt.Dimension;
import java.awt.GridLayout;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.KeyEvent;

import javax.swing.BorderFactory;
import javax.swing.Box;
import javax.swing.BoxLayout;
import javax.swing.JButton;
import javax.swing.JPanel;
import javax.swing.JTextArea;
import javax.swing.border.Border;

import com.rs.rdoe.demo.ProductInfo;
import com.rs.rdoe.demo.ProductNameMnemonic;

public class DemoGuiContainer extends JPanel
			implements ActionListener
{
	private JTextArea displayText;
	private ProductInfo productInfo = null;
	
	private ProductNameMnemonic[] products = { 
			new ProductNameMnemonic("RDOe", KeyEvent.VK_E),
			new ProductNameMnemonic("RDOi", KeyEvent.VK_I),
			new ProductNameMnemonic("DM", KeyEvent.VK_D),
			new ProductNameMnemonic("CM", KeyEvent.VK_C) 
	};
	
	public DemoGuiContainer(ProductInfo productInfo)
	{
		this.productInfo = productInfo; 
		setLayout(new BoxLayout(this, BoxLayout.PAGE_AXIS));
			
		add(Box.createRigidArea(new Dimension(0, 10)));
		add(createDisplayPane());
		add(Box.createRigidArea(new Dimension(0, 10)));
		add(createButtonPane());
	}
	
	public void actionPerformed(ActionEvent event)
	{
		String cmd = event.getActionCommand();
		for (int i=0; i < products.length; i++)
		{
			if (cmd.equals(products[i].productName))
			{
				String desc = productInfo.getDescription(cmd);
				String oldText = displayText.getText();
				displayText.setText(desc.trim());
				
				if (displayText.getRows() < 3)
				{
					displayText.setRows(3);
				}
				break;
			}
		}
	}
	
	private JPanel createDisplayPane()
	{
		String initialMsg = productInfo.getDescription(ProductInfo.SELECT_PRODUCT);
		String descTitle = productInfo.getDescription(ProductInfo.PRODUCT_DESC_TITLE);
		displayText = new JTextArea(initialMsg);
		displayText.setLineWrap(true);
		displayText.setWrapStyleWord(true);
		displayText.setEditable(false);
		displayText.setColumns(initialMsg.length() + 1);
		Border textBorder = BorderFactory.createCompoundBorder(
				BorderFactory.createLineBorder(Color.BLACK),
				BorderFactory.createEmptyBorder(5, 5, 5, 5));
		displayText.setBorder(textBorder);
		
		JPanel display = new JPanel();
		display.add(displayText);
		display.setBorder(BorderFactory.createTitledBorder(descTitle));
		display.setVisible(true);
		display.setSize(new Dimension(displayText.getPreferredSize().width, 
				displayText.getPreferredSize().height + getInsets().top + getInsets().bottom*2));
		display.setVisible(true);		
		return display;
	}
	
	private JPanel createButtonPane()
	{
		JPanel buttonContainer = new JPanel();
		String productTitle = productInfo.getDescription(ProductInfo.PRODUCTS_TITLE);
		buttonContainer.setBorder(BorderFactory.createTitledBorder(productTitle));
		buttonContainer.setPreferredSize(new Dimension(400, 55));
		buttonContainer.setMaximumSize(new Dimension(6000, 65));
		buttonContainer.setLayout(new GridLayout(1, products.length));
		
		for (int i=0; i < products.length; i++)
		{
			JButton b = new DemoButton(products[i].productName);
			b.setMnemonic(products[i].mnemonic);
			b.addActionListener(this);
			b.setToolTipText("Click this button for information about " + 
					products[i].productName);
			buttonContainer.add(b);
		}
		return buttonContainer;
	}
}
