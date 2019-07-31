package com.kh.myhouse.note.model.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.RowBounds;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class NoteDAOImpl implements NoteDAO{

	@Autowired
	SqlSessionTemplate sqlSession;
	
	@Override
	public List<Map<String, String>> selectNoteList(int cPage, int numPerPage, int memberNo) {
		RowBounds rowBounds = new RowBounds((cPage-1)*numPerPage, numPerPage);
		return sqlSession.selectList("note.selectNoteList",memberNo,rowBounds);
	}

	@Override
	public int selectNoteTotalContents(int memberNo) {
		return sqlSession.selectOne("note.selectNoteTotalContents", memberNo);
	}

	@Override
	public List<Object> selectNote(int noteno) {
		return sqlSession.selectList("note.selectNote",noteno);
	}

	@Override
	public void deleteNote(List<Integer> noteNo) {
		sqlSession.delete("note.deleteNote",noteNo);
	}

	@Override
	public int selectNoReadContents(int memberNo) {
		return sqlSession.selectOne("note.selectNoReadContents", memberNo);
	}

	@Override
	public void updateNoteYN(int noteno) {
		sqlSession.update("note.updateNoteYN",noteno);
	}

}
