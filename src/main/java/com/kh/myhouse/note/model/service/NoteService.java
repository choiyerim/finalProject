package com.kh.myhouse.note.model.service;

import java.util.List;
import java.util.Map;

public interface NoteService {

	List<Map<String, String>> selectNoteList(int cPage, int numPerPage, int memberNo);

	int selectNoteTotalContents(int memberNo);

	List<Object> selectNote(int noteno);

	void deleteNote(List<Integer> list);

	int selectNoContents(int memberNo);

	void updateNoteYN(int noteno);

}
