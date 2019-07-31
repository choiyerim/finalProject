package com.kh.myhouse.chat.model.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.kh.myhouse.chat.model.dao.ChatDAO;
import com.kh.myhouse.chat.model.vo.Chat;
import com.kh.myhouse.chat.model.vo.Msg;

@Service
public class ChatServiceImpl implements ChatService {

	@Autowired
	ChatDAO chatDAO; 
	
	@Override
	public String findChatIdByMemberId(String memberId) {
		System.out.println("findChatIdByMemberId service success");
		return chatDAO.findChatIdByMemberId(memberId);
	}

	@Override
	public int insertChatRoom(List<Chat> list) {
		int result = 0;
		for(Chat chatRoom: list){
			result += chatDAO.insertChatRoom(chatRoom);
		}
		return result;
	}

	@Override
	public List<Msg> findChatListByChatId(String chatId) {
		return chatDAO.findChatListByChatId(chatId);
	}

	@Override
	public int insertChatLog(Msg fromMessage) {
		//메세지 입력시 lastCheck컬럼값도 갱신
		updateLastCheck(fromMessage);
		return chatDAO.insertChatLog(fromMessage);
	}

	@Override
	public int updateLastCheck(Msg fromMessage) {
		return chatDAO.updateLastCheck(fromMessage);
	}

	@Override
	public List<Map<String, String>> findRecentList(String memberId) {
		System.out.println("findRecentList ServiceImpl작동");
		return chatDAO.findRecentList(memberId);
	}

	@Override
	public int chatClean(String chatId) {
		return chatDAO.chatClean(chatId);
	}

	@Override
	public String findReceiveId(String chatId) {
		return chatDAO.findReceiveId(chatId);
	}


}
