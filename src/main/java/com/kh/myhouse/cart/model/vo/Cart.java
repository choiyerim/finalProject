package com.kh.myhouse.cart.model.vo;

public class Cart {
	private int cartNo;
	private int memberNo;
	private int estateNo;
	private int cartCheck;
	public Cart() {
		super();
	}
	public Cart(int cartNo, int memberNo, int estateNo, int cartCheck) {
		super();
		this.cartNo = cartNo;
		this.memberNo = memberNo;
		this.estateNo = estateNo;
		this.cartCheck = cartCheck;
	}
	public int getCartNo() {
		return cartNo;
	}
	public void setCartNo(int cartNo) {
		this.cartNo = cartNo;
	}
	public int getMemberNo() {
		return memberNo;
	}
	public void setMemberNo(int memberNo) {
		this.memberNo = memberNo;
	}
	public int getEstateNo() {
		return estateNo;
	}
	public void setEstateNo(int estateNo) {
		this.estateNo = estateNo;
	}
	public int getCartCheck() {
		return cartCheck;
	}
	public void setCartCheck(int cartCheck) {
		this.cartCheck = cartCheck;
	}
	@Override
	public String toString() {
		return "Cart [cartNo=" + cartNo + ", memberNo=" + memberNo + ", estateNo=" + estateNo + ", cartCheck="
				+ cartCheck + "]";
	}
	
	
}
