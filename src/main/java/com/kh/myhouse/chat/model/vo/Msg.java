package com.kh.myhouse.chat.model.vo;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@ToString
public class Msg {
	private long chatNo;
	private String chatId;
	private String memberId;
	private String receiveId;
	private String msg;
	private long time;
	private MsgType type;
}
