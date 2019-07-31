package com.kh.myhouse.note.model.dao;

import java.util.List;
import java.util.Map;

public interface NoteDAO {

	List<Map<String, String>> selectNoteList(int cPage, int numPerPage, int memberNo);

	int selectNoteTotalContents(int memberNo);

	List<Object> selectNote(int noteno);

	void deleteNote(List<Integer> noteNo);

	int selectNoReadContents(int memberNo);

	void updateNoteYN(int noteno);

	


}
