package com.kh.myhouse.estate.model.vo;

import java.sql.Date;

public class EstateAttach {
	private int attachNo;
	private int estateNo;
	private String originalFileName;
	private String renamedFileName;
	private Date uploadDate;
	
	
	public EstateAttach() {
		super();
		// TODO Auto-generated constructor stub
	}


	public EstateAttach(int attachNo,int estateNo, String originalFileName, String renamedFileName, Date uploadDate) {
		super();
		this.estateNo = estateNo;
		this.originalFileName = originalFileName;
		this.renamedFileName = renamedFileName;
		this.uploadDate = uploadDate;
		this.attachNo = attachNo;
	}
	public int getAttachNo() {
		return attachNo;
	}


	public void setAttachNo(int attachNo) {
		this.attachNo = attachNo;
	}


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


	public Date getUploadDate() {
		return uploadDate;
	}


	public void setUploadDate(Date uploadDate) {
		this.uploadDate = uploadDate;
	}


	@Override
	public String toString() {
		return "EstateAttach [attachNo=" + attachNo + ", estateNo=" + estateNo + ", originalFileName="
				+ originalFileName + ", renamedFileName=" + renamedFileName + ", uploadDate=" + uploadDate + "]";
	}


	
	
	
}
