package com.kh.myhouse.note.model.vo;

import java.util.Date;

public class Note {
	private int noteNo;
	private int sendNo;
	private String noteContents;
	private String noteYN;
	private Date noteDate;
	public Note(int noteNo, int fromNo, int sendNo, String noteContents, String noteYN, Date noteDate) {
		super();
		this.noteNo = noteNo;
		this.sendNo = sendNo;
		this.noteContents = noteContents;
		this.noteYN = noteYN;
		this.noteDate = noteDate;
	}
	public int getNoteNo() {
		return noteNo;
	}
	public void setNoteNo(int noteNo) {
		this.noteNo = noteNo;
	}
	public int getSendNo() {
		return sendNo;
	}
	public void setSendNo(int sendNo) {
		this.sendNo = sendNo;
	}
	public String getNoteContent() {
		return noteContents;
	}
	public void setNoteContent(String noteContents) {
		this.noteContents = noteContents;
	}
	public String getNoteYN() {
		return noteYN;
	}
	public void setNoteYN(String noteYN) {
		this.noteYN = noteYN;
	}
	public Date getNoteDate() {
		return noteDate;
	}
	public void setNoteDate(Date noteDate) {
		this.noteDate = noteDate;
	}
	@Override
	public String toString() {
		return "note [noteNo=" + noteNo + ", sendNo=" + sendNo + ", noteContents=" + noteContents
				+ ", noteYN=" + noteYN + ", noteDate=" + noteDate + "]";
	}
}
