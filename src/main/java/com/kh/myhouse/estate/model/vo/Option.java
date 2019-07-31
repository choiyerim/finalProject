package com.kh.myhouse.estate.model.vo;

import java.util.Arrays;

public class Option {
	private int estateNo;
	private String[] optionDetail;
	private String[] construction;
	private String[] floorOpt;

	public Option() {
		super();
		
	}

	public Option(int estateNo, String[] optionDetail,String[] construction,String[] floorOpt) {
		super();
		this.estateNo = estateNo;
		this.optionDetail = optionDetail;
		this.construction = construction;
		this.floorOpt = floorOpt;
		
	}

	public int getEstateNo() {
		return estateNo;
	}

	public void setEstateNo(int estateNo) {
		this.estateNo = estateNo;
	}

	public String[] getOptionDetail() {
		return optionDetail;
	}

	public void setOptionDetail(String[] optionDetail) {
		this.optionDetail = optionDetail;
	}
	
	public String[] getConstruction() {
		return construction;
	}

	public void setConstruction(String[] construction) {
		this.construction = construction;
	}

	public String[] getFloorOpt() {
		return floorOpt;
	}

	public void setFloorOpt(String[] floorOpt) {
		this.floorOpt = floorOpt;
	}


	@Override
	public String toString() {
		return "Option [estateNo=" + estateNo + ", optionDetail=" + Arrays.toString(optionDetail) + 
				 Arrays.toString(construction) + Arrays.toString(floorOpt) +"]";
	}
}