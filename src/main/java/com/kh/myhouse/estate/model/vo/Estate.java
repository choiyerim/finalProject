package com.kh.myhouse.estate.model.vo;
import java.util.Date;
import java.util.List;
public class Estate {

	private int EstateNo;
	private String RegionCode;
	private int MemberNo;
	private int BusinessMemberNo;
	private String Phone;
	private String BusinessPhone;
	private String Address;
	private char EstateType;
	private char TransActionType;
	private int EstatePrice;
	private int ManageMentFee;
	private int EstateArea;
	private String SubwayStation;
	private String EstateContent;
	private Date WrittenDate;
	private int Deposit;
	private String AddressDetail;
	private List<Option> option;
	private List<EstateAttach> attachList;
	

	public List<Option> getOption() {
		return option;
	}

	public void setOption(List<Option> option) {
		this.option = option;
	}

	public List<EstateAttach> getAttachList() {
		return attachList;
	}

	public void setAttachList(List<EstateAttach> attachList) {
		this.attachList = attachList;
	}

	public Estate() {
		super();
		// TODO Auto-generated constructor stub
	}
	
	public Estate(int estateNo, String regionCode, int memberNo, int businessMemberNo, String phone, String businessPhone,
			String address, char estateType, char transActionType, int estatePrice, int manageMentFee, int estateArea,
			String subwayStation, String estateContent, Date writtenDate, int deposit,String addressDetail, List<EstateAttach> attachList) {
		super();
		EstateNo = estateNo;
		RegionCode = regionCode;
		MemberNo = memberNo;
		BusinessMemberNo = businessMemberNo;
		Phone = phone;
		BusinessPhone = businessPhone;
		Address = address;
		EstateType = estateType;
		TransActionType = transActionType;
		EstatePrice = estatePrice;
		ManageMentFee = manageMentFee;
		EstateArea = estateArea;
		SubwayStation = subwayStation;
		EstateContent = estateContent;
		WrittenDate = writtenDate;
		Deposit = deposit;
		AddressDetail =addressDetail;
		this.attachList = attachList;
	}
	
	public Estate(int estateNo, String regionCode, int memberNo, int businessMemberNo, String phone,
			String businessPhone, String address, char estateType, char transActionType, int estatePrice,
			int manageMentFee, int estateArea, String subwayStation, String estateContent, Date writtenDate,
			int deposit, String addressDetail, List<Option> option, List<EstateAttach> attachList) {
		super();
		EstateNo = estateNo;
		RegionCode = regionCode;
		MemberNo = memberNo;
		BusinessMemberNo = businessMemberNo;
		Phone = phone;
		BusinessPhone = businessPhone;
		Address = address;
		EstateType = estateType;
		TransActionType = transActionType;
		EstatePrice = estatePrice;
		ManageMentFee = manageMentFee;
		EstateArea = estateArea;
		SubwayStation = subwayStation;
		EstateContent = estateContent;
		WrittenDate = writtenDate;
		Deposit = deposit;
		AddressDetail = addressDetail;
		this.option = option;
		this.attachList = attachList;
	}

	public Estate(int estateNo, String regionCode, int memberNo, int businessMemberNo, String phone,
			String businessPhone, String address, char estateType, char transActionType, int estatePrice,
			int manageMentFee, int estateArea, String subwayStation, String estateContent, Date writtenDate,
			int deposit, String addressDetail) {
		super();
		EstateNo = estateNo;
		RegionCode = regionCode;
		MemberNo = memberNo;
		BusinessMemberNo = businessMemberNo;
		Phone = phone;
		BusinessPhone = businessPhone;
		Address = address;
		EstateType = estateType;
		TransActionType = transActionType;
		EstatePrice = estatePrice;
		ManageMentFee = manageMentFee;
		EstateArea = estateArea;
		SubwayStation = subwayStation;
		EstateContent = estateContent;
		WrittenDate = writtenDate;
		Deposit = deposit;
		AddressDetail = addressDetail;
	}

	public int getEstateNo() {
		return EstateNo;
	}
	public void setEstateNo(int estateNo) {
		EstateNo = estateNo;
	}
	public String getRegionCode() {
		return RegionCode;
	}
	public void setRegionCode(String regionCode) {
		RegionCode = regionCode;
	}
	public int getMemberNo() {
		return MemberNo;
	}
	public void setMemberNo(int memberNo) {
		MemberNo = memberNo;
	}
	public int getBusinessMemberNo() {
		return BusinessMemberNo;
	}
	public void setBusinessMemberNo(int businessMemberNo) {
		BusinessMemberNo = businessMemberNo;
	}
	public String getPhone() {
		return Phone;
	}
	public void setPhone(String phone) {
		Phone = phone;
	}
	public String getBusinessPhone() {
		return BusinessPhone;
	}
	public void setBusinessPhone(String businessPhone) {
		BusinessPhone = businessPhone;
	}
	public String getAddress() {
		return Address;
	}
	public void setAddress(String address) {
		Address = address;
	}
	public char getEstateType() {
		return EstateType;
	}
	public void setEstateType(char estateType) {
		EstateType = estateType;
	}
	public char getTransActionType() {
		return TransActionType;
	}
	public void setTransActionType(char transActionType) {
		TransActionType = transActionType;
	}
	public int getEstatePrice() {
		return EstatePrice;
	}
	public void setEstatePrice(int estatePrice) {
		EstatePrice = estatePrice;
	}
	public int getManageMentFee() {
		return ManageMentFee;
	}
	public void setManageMentFee(int manageMentFee) {
		ManageMentFee = manageMentFee;
	}
	public int getEstateArea() {
		return EstateArea;
	}
	public void setEstateArea(int estateArea) {
		EstateArea = estateArea;
	}
	public String getSubwayStation() {
		return SubwayStation;
	}
	public void setSubwayStation(String subwayStation) {
		SubwayStation = subwayStation;
	}
	public String getEstateContent() {
		return EstateContent;
	}
	public void setEstateContent(String estateContent) {
		EstateContent = estateContent;
	}
	public Date getWrittenDate() {
		return WrittenDate;
	}
	public void setWrittenDate(Date writtenDate) {
		WrittenDate = writtenDate;
	}
	public int getDeposit() {
		return Deposit;
	}
	public void setDeposit(int deposit) {
		Deposit = deposit;
	}
	public String getAddressDetail() {
		return AddressDetail;
	}
	public void setAddressDetail(String addressDetail) {
		AddressDetail = addressDetail;
	}
	@Override
	public String toString() {
		return "Estate [EstateNo=" + EstateNo + ", RegionCode=" + RegionCode + ", MemberNo=" + MemberNo
				+ ", BusinessMemberNo=" + BusinessMemberNo + ", Phone=" + Phone + ", BusinessPhone=" + BusinessPhone
				+ ", Address=" + Address + ", EstateType=" + EstateType + ", TransActionType=" + TransActionType
				+ ", EstatePrice=" + EstatePrice + ", ManageMentFee=" + ManageMentFee + ", EstateArea=" + EstateArea
				+ ", SubwayStation=" + SubwayStation + ", EstateContent=" + EstateContent + ", WrittenDate="
				+ WrittenDate + ", Deposit=" + Deposit +", AddressDetail= "+AddressDetail+", attachList=" + attachList + "]";
	}

}