package com.kh.myhouse.interest.model.vo;

import java.util.Arrays;

public class Interest {
	private int interestNo;
	private int memberNo;
	private String regionCode;
	private String[] estateType;
	private char pet;
	private char elevator;
	private char parking;
	private char subway;
	private String city;
	private String state;
	public Interest() {
		super();
	}
	public Interest(int interestNo, int memberNo, String regionCode, String[] estateType, char pet, char elevator,
			char parking, char subway, String city, String state) {
		super();
		this.interestNo = interestNo;
		this.memberNo = memberNo;
		this.regionCode = regionCode;
		this.estateType = estateType;
		this.pet = pet;
		this.elevator = elevator;
		this.parking = parking;
		this.subway = subway;
		this.city = city;
		this.state = state;
	}
	public int getInterestNo() {
		return interestNo;
	}
	public void setInterestNo(int interestNo) {
		this.interestNo = interestNo;
	}
	public int getMemberNo() {
		return memberNo;
	}
	public void setMemberNo(int memberNo) {
		this.memberNo = memberNo;
	}
	public String getRegionCode() {
		return regionCode;
	}
	public void setRegionCode(String regionCode) {
		this.regionCode = regionCode;
	}
	public String[] getEstateType() {
		return estateType;
	}
	public void setEstateType(String[] estateType) {
		this.estateType = estateType;
	}
	public char getPet() {
		return pet;
	}
	public void setPet(char pet) {
		this.pet = pet;
	}
	public char getElevator() {
		return elevator;
	}
	public void setElevator(char elevator) {
		this.elevator = elevator;
	}
	public char getParking() {
		return parking;
	}
	public void setParking(char parking) {
		this.parking = parking;
	}
	public char getSubway() {
		return subway;
	}
	public void setSubway(char subway) {
		this.subway = subway;
	}
	public String getCity() {
		return city;
	}
	public void setCity(String city) {
		this.city = city;
	}
	public String getState() {
		return state;
	}
	public void setState(String state) {
		this.state = state;
	}
	@Override
	public String toString() {
		return "Interest [interestNo=" + interestNo + ", memberNo=" + memberNo + ", regionCode=" + regionCode
				+ ", estateType=" + Arrays.toString(estateType) + ", pet=" + pet + ", elevator=" + elevator
				+ ", parking=" + parking + ", subway=" + subway + ", city=" + city + ", state=" + state + "]";
	}

	
}