package com.kh.myhouse.chat.model.dao;

import java.util.List;
import java.util.Map;

import com.kh.myhouse.chat.model.vo.Chat;
import com.kh.myhouse.chat.model.vo.Msg;

public interface ChatDAO {

	String findChatIdByMemberId(String memberId);
	List<Msg> findChatListByChatId(String chatId);

	int insertChatRoom(Chat chatRoom);
	
	int insertChatLog(Msg fromMessage);
	
	int updateLastCheck(Msg fromMessage);
	
	List<Map<String, String>> findRecentList(String memberId);

	int chatClean(String chatId);
	
	String findReceiveId(String chatId);

}
