package com.kh.myhouse.common.typehandler;

import java.sql.CallableStatement;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import org.apache.ibatis.type.JdbcType;
import org.apache.ibatis.type.TypeHandler;
/**
 * 
 * Dev.devLang:String[] -> db테이블 dev.dev_lang:문자형
 * 
 * getter
 * 1. resultset 컬럼이름
 * 2. resultset 컬럼인덱스
 * 3. procedure(CallableStatement)
 * 
 * setter
 * 
 *
 */
public class StrArrTypeHandler 
	implements TypeHandler<String[]> {

	@Override
	public void setParameter(PreparedStatement ps, int i, String[] parameter, JdbcType jdbcType) throws SQLException {
		if(parameter != null)
			ps.setString(i, String.join(",", parameter));
		else
			ps.setString(i, "");
	}

	@Override
	public String[] getResult(ResultSet rs, String columnName) throws SQLException {
		String str = rs.getString(columnName);//java,c,javascript
		String[] strArr = null;
		if(str != null) strArr = str.split(",");
		return strArr;
	}

	@Override
	public String[] getResult(ResultSet rs, int columnIndex) throws SQLException {
		String str = rs.getString(columnIndex);//java,c,javascript
		String[] strArr = null;
		if(str != null) strArr = str.split(",");
		return strArr;
	}

	@Override
	public String[] getResult(CallableStatement cs, int columnIndex) throws SQLException {
		String str = cs.getString(columnIndex);//java,c,javascript
		String[] strArr = null;
		if(str != null) strArr = str.split(",");
		return strArr;
	}

}
