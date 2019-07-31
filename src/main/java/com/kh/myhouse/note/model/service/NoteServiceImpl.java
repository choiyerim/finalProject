package com.kh.myhouse.note.model.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.kh.myhouse.note.model.dao.NoteDAO;

@Service
public class NoteServiceImpl implements NoteService{
	
	@Autowired
	private NoteDAO noteDAO;
	
	@Override
	public List<Map<String, String>> selectNoteList(int cPage, int numPerPage, int memberNo) {
		return noteDAO.selectNoteList(cPage, numPerPage, memberNo);
	}

	@Override
	public int selectNoteTotalContents(int memberNo) {
		return noteDAO.selectNoteTotalContents(memberNo);
	}

	@Override
	public List<Object> selectNote(int noteno) {
		return noteDAO.selectNote(noteno);
	}

	@Override
	public void deleteNote(List<Integer> noteNo) {
		noteDAO.deleteNote(noteNo);
	}

	@Override
	public int selectNoContents(int memberNo) {
		return noteDAO.selectNoReadContents(memberNo);
	}

	@Override
	public void updateNoteYN(int noteno) {
		noteDAO.updateNoteYN(noteno);
	}

}
