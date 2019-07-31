package com.kh.myhouse.agent.model.vo;

import java.sql.Date;

public class Agent {
	private int memberNo;
	private String memberEmail;
	private String memberName;
	private String memberPwd;
	private String phone;
	private Date enrollDate;
	private Date quitDate;
	private char quitYN;
	private char status;
	private char receiveMemoYN;
	private String companyRegNo;
	private char approveYN;
	
	public Agent() {}

	public Agent(int memberNo, String memberEmail, String memberName, String memberPwd, String phone, Date enrollDate,
			Date quitDate, char quitYN, char status, char receiveMemoYN, String companyRegNo, char approveYN) {
		super();
		this.memberNo = memberNo;
		this.memberEmail = memberEmail;
		this.memberName = memberName;
		this.memberPwd = memberPwd;
		this.phone = phone;
		this.enrollDate = enrollDate;
		this.quitDate = quitDate;
		this.quitYN = quitYN;
		this.status = status;
		this.receiveMemoYN = receiveMemoYN;
		this.companyRegNo = companyRegNo;
		this.approveYN = approveYN;
	}

	public int getMemberNo() {
		return memberNo;
	}

	public void setMemberNo(int memberNo) {
		this.memberNo = memberNo;
	}

	public String getMemberEmail() {
		return memberEmail;
	}

	public void setMemberEmail(String memberEmail) {
		this.memberEmail = memberEmail;
	}

	public String getMemberName() {
		return memberName;
	}

	public void setMemberName(String memberName) {
		this.memberName = memberName;
	}

	public String getMemberPwd() {
		return memberPwd;
	}

	public void setMemberPwd(String memberPwd) {
		this.memberPwd = memberPwd;
	}

	public String getPhone() {
		return phone;
	}

	public void setPhone(String phone) {
		this.phone = phone;
	}

	public Date getEnrollDate() {
		return enrollDate;
	}

	public void setEnrollDate(Date enrollDate) {
		this.enrollDate = enrollDate;
	}

	public Date getQuitDate() {
		return quitDate;
	}

	public void setQuitDate(Date quitDate) {
		this.quitDate = quitDate;
	}

	public char getQuitYN() {
		return quitYN;
	}

	public void setQuitYN(char quitYN) {
		this.quitYN = quitYN;
	}

	public char getStatus() {
		return status;
	}

	public void setStatus(char status) {
		this.status = status;
	}

	public char getReceiveMemoYN() {
		return receiveMemoYN;
	}

	public void setReceiveMemoYN(char receiveMemoYN) {
		this.receiveMemoYN = receiveMemoYN;
	}

	public String getCompanyRegNo() {
		return companyRegNo;
	}

	public void setCompanyRegNo(String companyRegNo) {
		this.companyRegNo = companyRegNo;
	}

	public char getApproveYN() {
		return approveYN;
	}

	public void setApproveYN(char approveYN) {
		this.approveYN = approveYN;
	}

	@Override
	public String toString() {
		return "Agent [memberNo=" + memberNo + ", memberEmail=" + memberEmail + ", memberName=" + memberName
				+ ", memberPwd=" + memberPwd + ", phone=" + phone + ", enrollDate=" + enrollDate + ", quitDate="
				+ quitDate + ", quitYN=" + quitYN + ", status=" + status + ", receiveMemoYN=" + receiveMemoYN
				+ ", companyRegNo=" + companyRegNo + ", approveYN=" + approveYN + "]";
	}
	
	
	
}
