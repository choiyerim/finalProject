package com.kh.myhouse.estate.model.vo;

public class EstatePhoto {
	private int estateNo;
	private String originalFileName;
	private String renamedFileName;
	public int getEstateNo() {
		return estateNo;
	}
	public void setEstateNo(int estateNo) {
		this.estateNo = estateNo;
	}
	public String getOriginalFileName() {
		return originalFileName;
	}
	public void setOriginalFileName(String originalFileName) {
		this.originalFileName = originalFileName;
	}
	public String getRenamedFileName() {
		return renamedFileName;
	}
	public void setRenamedFileName(String renamedFileName) {
		this.renamedFileName = renamedFileName;
	}
	public EstatePhoto(int estateNo, String originalFileName, String renamedFileName) {
		super();
		this.estateNo = estateNo;
		this.originalFileName = originalFileName;
		this.renamedFileName = renamedFileName;
	}
	public EstatePhoto() {
		super();
	}
	
	
}
