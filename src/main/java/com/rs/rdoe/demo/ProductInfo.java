/*
 * Created on Aug 6, 2007
 *
 */
package com.rs.rdoe.demo;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.Properties;


public class ProductInfo 
{
	private Properties namesDescriptions = new Properties();

	public static final String TITLE = "Title";
	public static final String RDOE = "RDOe";
	public static final String RDOI = "RDOi";
	public static final String DM = "DM";
	public static final String CM = "CM";
	
	public static final String SELECT_PRODUCT = "SelectProduct";
	public static final String PRODUCTS_TITLE = "ProductsTitle";
	public static final String PRODUCT_DESC_TITLE = "ProductDescTitle";
	
	
	

	public ProductInfo() {
		readInfo();
	}

	public String getDescription(String productName) {
		return (String) namesDescriptions.get(productName);
	}

	public void readInfo() {
		BufferedReader br = null;

		try {
			InputStream is = this.getClass().getClassLoader().getResourceAsStream("messages.properties");

			br = new BufferedReader(new InputStreamReader(is, "UTF-8"));

			namesDescriptions.load(br);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if (br != null) {
				try {
					br.close();
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
		}
	}
}
